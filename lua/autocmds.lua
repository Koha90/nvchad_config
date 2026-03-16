require "nvchad.autocmds"

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    -- Только gopls
    if client.name == "gopls" then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format {
            bufnr = args.buf,
            filter = function(c)
              return c.name == "gopls"
            end,
          }
        end,
      })
    end

    -- QML
    if client.name == "qmlls" then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format {
            bufnr = args.buf,
            filter = function(c)
              return c.name == "qmlls"
            end,
          }
        end,
      })
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format { async = false }
    -- vim.fn.system("goimports-reviser " .. vim.fn.expand("%"))
    -- vim.cmd("e")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "qml", "qmljs" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})
