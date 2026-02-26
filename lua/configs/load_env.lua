local M = {}

function M.load(path)
  path = path or (vim.fn.getcwd() .. "/.env")

  local f = io.open(path, "r")
  if not f then
    print("Env file not found: " .. path)
    return
  end

  for line in f:lines() do
    local k, v = line:match "^([%w_]+)%s*=%s*(.+)$"
    if k and v then
      v = v:gsub('^"(.*)"$', "%1")
      vim.env[k] = v
    end
  end

  f:close()
end

return M
