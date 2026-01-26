require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jj", "<ESC>")

-- go plugins
map("n", "<leader>gsj", "<cmd> GoTagAdd json <cr>", { desc = "Add json struct tags" })
map("n", "<leader>gsy", "<cmd> GoTagAdd yaml <cr>", { desc = "Add yaml struct tags" })
map("n", "<leader>gst", "<cmd> GoTagAdd toml <cr>", { desc = "Add toml struct tags" })
map("n", "<leader>gse", "<cmd> GoTagAdd env <cr>", { desc = "Add env struct tags" })

map("n", "<leader>dgt", function()
  require("dap-go").debug_test()
end, { desc = "Debug go test" })

map("n", "<leader>dgl", function()
  require("dap-go").debug_last()
end, { desc = "Debug last go test" })

map("n", "<leader>db", "<cmd> DapToggleBreakpoint <cr>", { desc = "Add breakpoint at line" })
map("n", "<leader>dus", function()
  local widgets = require("dap.ui.widgets");
  local sidebar = widgets.sidebar(widgets.scopes);
  sidebar.open();
end, { desc = "Open debugging sidebar" })
map("n", "<leader>duc", function()
  local widgets = require("dap.ui.widgets");
  local sidebar = widgets.sidebar(widgets.scopes);
  sidebar.close();
end, { desc = "Close debugging sidebar" })

map("n", "<leader>gtt", "<cmd> GoTest <cr>", { desc = "Go test file" })
map("n", "<leader>gtp", "<cmd> GoTestPkg <cr>", { desc = "Go test package" })
map("n", "<leader>gta", "<cmd> GoTestAll <cr>", { desc = "Go test all" })

-- TODO:
map("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })
map("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

-- lazygit
map("n", "<leader>lg", "<cmd> LazyGit <cr>", { desc = "LazyGit" })

-- lazydocker
map("n", "<leader>ld", function()
    require("lazydocker").open()
  end,
  { desc = "Open Lazydocker floating window" }
)

-- Lsp 
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- Format
map("n", "<leader>cf", function()
  vim.lsp.buf.format { async = true }
end, { desc = "Format file" })

-- Save file in ctrl+s
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
