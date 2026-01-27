require("nvchad.configs.lspconfig").defaults()


local servers = { "html", "cssls" }
vim.lsp.enable(servers)

vim.lsp.config("*", {
  root_markers = { ".git" },
})

-- Go lsp (gopls)
vim.lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.mod", ".git" },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
      completeUnimported = true,
      usePlaceholders = true,
      gofumpt = true,
    },
  },
})


-- Lua
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
      telemetry = { enable = false },
    },
  },
})

-- TypeScript
vim.lsp.config("tsserver", {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  root_markers = { "package.json", "tsconfig.json", ".git" },
})

-- Rust
vim.lsp.config("rust_analyzer", {
  cmd = { "rust_analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", ".git" },
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
      checkOnSave = {
        command = "clippy"
      },
    },
  },
})

-- SQL
local load_env = require("configs.load_env")
load_env.load()

vim.lsp.config("sqls", {
  cmd = { "sqls" },
  filetypes = { "sql" },
  root_markers = { "sqls.json", ".git" },

  settings = {
    sqls = {
      connections = {
        {
          driver = vim.env.DB_DRIVER or "postgresql",
          host = vim.env.DB_HOST or "127.0.0.1",
          port = tonumber(vim.env.DB_PORT) or 5432,
          user = vim.env.DB_USER or "prostgres",
          password = vim.env.DB_PASSWORD or "secret",
          database = vim.env.DB_DATABASE or "mydb",
          schema = vim.env.DB_SCHEMA or "public",
        }
      }
    }
  }
})

-- enable servers
vim.lsp.enable({
  "gopls",
  "lua_ls",
  "tsserver",
  "rust_analyzer",
  "sqls",
})

-- read :h vim.lsp.config for changing options of lsp servers 
