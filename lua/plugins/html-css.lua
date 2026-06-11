-- ~/.config/nvim/lua/plugins/html-css.lua

return {
  {
    "Jezda1337/nvim-html-css",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    ft = {
      "html",
      "css",
      "scss",
      "tsx",
      "jsx",
      "typescriptreact",
      "javascriptreact",
    },
    opts = {
      enable_on = {
        "html",
        "tsx",
        "jsx",
        "typescriptreact",
        "javascriptreact",
      },

      handlers = {
        definition = {
          bind = "gd",
        },
        hover = {
          bind = "K",
          wrap = true,
          border = "rounded",
          position = "cursor",
        },
      },

      documentation = {
        auto_show = true,
      },

      peek = {
        enabled = true,
        border = "rounded",
        position = "center",
        width = 0.6,
        height = 0.6,
        focus = true,
        style = "minimal",
      },

      style_sheets = {},
    },
  },
}
