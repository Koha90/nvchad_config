local conform = require("conform")

local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    go = { "gofumpt", "goimports", "golines", "goimports-reviser"},
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

conform.formatters.goimports_reviser = {
  command = "goimports-reviser",
  args = {
    "-rm-unused",
    "-set-alias",
    "-format",
    "$FILENAME",
  },
  stdin = false
}

return options
