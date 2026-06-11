return {
  {
    "nvim-lua/plenary.nvim",
    config = function()
      local config = {
        fallback_extension = "scss",

        global_helpers = {
          "cn",
          "clsx",
          "classNames",
        },
      }

      local function notify_info(message)
        vim.notify(message, vim.log.levels.INFO)
      end

      local function notify_warn(message)
        vim.notify(message, vim.log.levels.WARN)
      end

      local function notify_error(message)
        vim.notify(message, vim.log.levels.ERROR)
      end

      local function file_exists(path)
        local stat = vim.loop.fs_stat(path)
        return stat ~= nil and stat.type == "file"
      end

      local function read_file(path)
        local file = io.open(path, "r")

        if not file then
          return ""
        end

        local content = file:read "*a"
        file:close()

        return content
      end

      local function append_file(path, content)
        local file = io.open(path, "a")

        if not file then
          notify_error("Не получилось открыть файл: " .. path)
          return false
        end

        file:write(content)
        file:close()

        return true
      end

      local function unique_sorted(items)
        local seen = {}
        local result = {}

        for _, item in ipairs(items) do
          if item ~= "" and not seen[item] then
            seen[item] = true
            table.insert(result, item)
          end
        end

        table.sort(result)

        return result
      end

      local function escape_pattern(value)
        return value:gsub("([^%w])", "%%%1")
      end

      local function resolve_path(base_file, relative_path)
        local base_dir = vim.fn.fnamemodify(base_file, ":p:h")
        return vim.fn.fnamemodify(base_dir .. "/" .. relative_path, ":p")
      end

      local function fallback_style_path(source_path)
        local dir = vim.fn.fnamemodify(source_path, ":p:h")
        local name = vim.fn.fnamemodify(source_path, ":t:r")

        return dir .. "/" .. name .. "." .. config.fallback_extension
      end

      local function extract_module_import(content)
        local patterns = {
          [=[import%s+([%w_]+)%s+from%s+["']([^"']+%.module%.scss)["']]=],
          [=[import%s+([%w_]+)%s+from%s+["']([^"']+%.module%.css)["']]=],
          [=[import%s+([%w_]+)%s+from%s+["']([^"']+%.module%.sass)["']]=],
        }

        for _, pattern in ipairs(patterns) do
          local styles_name, module_path = content:match(pattern)

          if styles_name and module_path then
            return styles_name, module_path
          end
        end

        return nil, nil
      end

      local function extract_global_style_import(content)
        local patterns = {
          [=[import%s+["']([^"']+%.scss)["']]=],
          [=[import%s+["']([^"']+%.css)["']]=],
          [=[import%s+["']([^"']+%.sass)["']]=],
        }

        for _, pattern in ipairs(patterns) do
          local style_path = content:match(pattern)

          if style_path and not style_path:match "%.module%." then
            return style_path
          end
        end

        return nil
      end

      local function add_classes_from_string(classes, value)
        local without_template_expressions = value:gsub("${.-}", " ")

        for class_name in without_template_expressions:gmatch "[%a_][%w_-]*" do
          table.insert(classes, class_name)
        end
      end

      local function extract_module_classes(content, styles_name)
        local classes = {}
        local styles_pattern = escape_pattern(styles_name)

        for class_name in content:gmatch(styles_pattern .. "%.([%a_][%w_]*)") do
          table.insert(classes, class_name)
        end

        for class_name in content:gmatch(styles_pattern .. "%[%s*[\"']([%w_-]+)[\"']%s*%]") do
          table.insert(classes, class_name)
        end

        return unique_sorted(classes)
      end

      local function extract_global_classes(content)
        local classes = {}

        local class_patterns = {
          [=[className%s*=%s*["']([^"']+)["']]=],
          [=[class%s*=%s*["']([^"']+)["']]=],
          [=[className%s*=%s*{%s*["']([^"']+)["']%s*}]=],
          [=[class%s*=%s*{%s*["']([^"']+)["']%s*}]=],
          [=[className%s*=%s*{%s*`([^`]+)`%s*}]=],
          [=[class%s*=%s*{%s*`([^`]+)`%s*}]=],
        }

        for _, pattern in ipairs(class_patterns) do
          for raw_value in content:gmatch(pattern) do
            add_classes_from_string(classes, raw_value)
          end
        end

        for _, helper in ipairs(config.global_helpers) do
          local helper_pattern = escape_pattern(helper)

          for args in content:gmatch(helper_pattern .. "%s*%((.-)%)") do
            for raw_value in args:gmatch "[\"']([^\"']+)[\"']" do
              add_classes_from_string(classes, raw_value)
            end
          end
        end

        return unique_sorted(classes)
      end

      local function class_exists(content, class_name)
        local escaped_class = escape_pattern(class_name)

        if content:match("%." .. escaped_class .. "%s*[{,:]") then
          return true
        end

        local bem_suffix = class_name:match "^[%w-]+(__.+)$"
          or class_name:match "^[%w-]+(_.+)$"
          or class_name:match "^[%w-]+(%-%-.+)$"

        if bem_suffix then
          local escaped_suffix = escape_pattern(bem_suffix)

          if content:match("&" .. escaped_suffix .. "%s*[{,:]") then
            return true
          end
        end

        return false
      end

      local function ensure_file(path)
        if file_exists(path) then
          return true
        end

        local ok = vim.fn.writefile({}, path) == 0

        if not ok then
          notify_error("Не получилось создать файл: " .. path)
          return false
        end

        return true
      end

      local function append_missing_classes(style_path, class_names)
        if not ensure_file(style_path) then
          return
        end

        local style_content = read_file(style_path)
        local missing = {}

        for _, class_name in ipairs(class_names) do
          if not class_exists(style_content, class_name) then
            table.insert(missing, class_name)
          end
        end

        if #missing == 0 then
          notify_info "Все классы уже есть ✨"
          vim.cmd("edit " .. vim.fn.fnameescape(style_path))
          return
        end

        local stub = "\n"

        for _, class_name in ipairs(missing) do
          stub = stub .. "." .. class_name .. " {\n}\n\n"
        end

        if append_file(style_path, stub) then
          notify_info("Добавлены классы: " .. table.concat(missing, ", "))
          vim.cmd("edit " .. vim.fn.fnameescape(style_path))
        end
      end

      local function run_style_stub()
        local source_path = vim.fn.expand "%:p"
        local source_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")

        local styles_name, module_relative_path = extract_module_import(source_content)

        if styles_name and module_relative_path then
          local module_path = resolve_path(source_path, module_relative_path)
          local module_classes = extract_module_classes(source_content, styles_name)

          if #module_classes == 0 then
            notify_info "Импорт CSS Module есть, но styles.* не нашёл"
            vim.cmd("edit " .. vim.fn.fnameescape(module_path))
            return
          end

          append_missing_classes(module_path, module_classes)
          return
        end

        local global_classes = extract_global_classes(source_content)

        if #global_classes == 0 then
          notify_info "Классов для SCSS-заготовки не нашёл"
          return
        end

        local global_relative_path = extract_global_style_import(source_content)
        local global_path = nil

        if global_relative_path then
          global_path = resolve_path(source_path, global_relative_path)
        else
          global_path = fallback_style_path(source_path)
          notify_warn(
            "Style-импорт не найден. Использую файл: "
              .. vim.fn.fnamemodify(global_path, ":t")
          )
        end

        append_missing_classes(global_path, global_classes)
      end

      vim.api.nvim_create_user_command("StyleStub", run_style_stub, {})

      vim.api.nvim_create_user_command("ScssModuleStub", function()
        run_style_stub()
      end, {})
    end,
  },
}
