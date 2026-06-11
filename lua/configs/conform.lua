local conform = require "conform"

local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    html = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },

    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },

    json = { "prettier" },

    go = { "gofumpt", "goimports", "golines", "goimports-reviser" },
    python = { "ruff_format" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
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
  stdin = false,
}

return options
