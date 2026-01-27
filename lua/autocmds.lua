require "nvchad.autocmds"

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function (args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    -- Только gopls
    if client.name == "gopls" then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = args.buf,
        callback = function ()
          vim.lsp.buf.format({
            bufnr = args.buf,
            filter = function (c)
              return c.name == "gopls"
            end,
          })
        end,
      })
    end
  end,
})
