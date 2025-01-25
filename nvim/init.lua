vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.havenerdfont = true
vim.opt.number = true
vim.opt.mouse = "c"
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 20
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- clear search highlights on esc
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- window nav
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- plugins!
require("lazy").setup({
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      "nvim-telescope/telescope-ui-select.nvim",
      {
        "nvim-tree/nvim-web-devicons",
        enabled = vim.g.have_nerd_font
      },
    },
    config = function()
      require("telescope").setup({
        extentions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown()
          }
        }
      })
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Find [F]iles" })
    end
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer"
    },
  },
  -- jellybeans ported to nvim+lua
  {
    "metalelf0/jellybeans-nvim",
    dependencies = {
      "rktjmp/lush.nvim"
    }
  }
})

local cmp = require("cmp")
cmp.setup({
  completion = {
    keyword_length = 1,
    completeopt = "menu,menuone,noinsert,noselect"
  },
  preselect = "none",
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = function (fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ["<S-Tab>"] = function (fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    -- if this is present, have to hit escape twice to get back to normal mode
    -- ["<Esc>"] = cmp.mapping.abort(),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer" }
  },
})

local caps = vim.lsp.protocol.make_client_capabilities()
caps = vim.tbl_deep_extend("force", caps, require("cmp_nvim_lsp").default_capabilities())

local lspconfig = require("lspconfig")
lspconfig.ruff.setup({
  capabilities = caps
})

lspconfig.clangd.setup({
  capabilities = caps
})

lspconfig.html.setup({
  capabilities = caps
})

lspconfig.css_variables.setup({
  capabilities = caps
})

lspconfig.ts_ls.setup({
  capabilities = caps
})

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    local mode = vim.api.nvim_get_mode().mode
    if vim.bo.modified == true and mode == "n" then
      vim.cmd("lua vim.lsp.buf.format()")
    end
  end
})

vim.cmd("colorscheme jellybeans-nvim")
