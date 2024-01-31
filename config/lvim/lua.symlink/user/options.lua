lvim.log.level = "warn"
lvim.format_on_save = true

lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true
lvim.builtin.nvimtree.setup.filters.custom = {}

lvim.builtin.treesitter.ignore_install = {}
lvim.builtin.treesitter.highlight.enabled = true

lvim.builtin.project.detection_methods = { "lsp", "pattern" }
lvim.builtin.project.patterns = {
  ".git",
  "package-lock.json",
  "yarn.lock",
  "package.json",
  "requirements.txt",
}
-- lvim.transparent_window = true
-- use github-nvim-theme instead
-- lvim.builtin.lualine.theme = "catppuccin"

vim.opt.shell = "/bin/zsh"
vim.opt.relativenumber = true -- relative line numbers
vim.opt.shiftwidth = 2        -- the number of spaces inserted for each indentation
vim.opt.tabstop = 2           -- insert 2 spaces for a tab
vim.opt.wrap = false

vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.opt.linebreak = true

-- NEOVIDE config
-- Allow copy paste in neovim - NEOVIDE
vim.cmd [[set guifont=JetBrainsMono\ Nerd\ Font:h15]]
-- vim.cmd [[set mouse=]]
vim.g.neovide_input_use_logo = 1
vim.cmd [[map <D-v> "+p<CR>]]
vim.cmd [[map! <D-v> <C-R>+]]
vim.cmd [[tmap <D-v> <C-R>+]]
vim.cmd [[vmap <D-c> "+y<CR>]]

-- use github-nvim-theme instead
-- lvim.colorscheme = "catppuccin"

lvim.builtin.telescope.defaults.path_display = { shorten = 4 }
lvim.builtin.telescope.defaults.winblend = 10
lvim.builtin.telescope.on_config_done = function(telescope)
  pcall(telescope.load_extension, "zoxide")
  pcall(telescope.load_extension, "neoclip")
end

-- use nightly version of hrsh7th/nvim-cmp
lvim.builtin.cmp.experimental.ghost_text = true


-- folding powered by treesitter
-- https://github.com/nvim-treesitter/nvim-treesitter#folding
-- look for foldenable: https://github.com/neovim/neovim/blob/master/src/nvim/options.lua
-- Vim cheatsheet, look for folds keys: https://devhints.io/vim
vim.opt.foldmethod = "expr"                     -- default is "normal"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- default is ""
vim.opt.foldenable = true                       -- if this option is true and fold method option is other than normal, every time a document is opened everything will be folded.
vim.wo.fillchars = "fold: "
vim.wo.foldnestmax = 3
vim.wo.foldminlines = 1
vim.wo.foldlevel = 1
-- vim.wo.foldtext =
-- [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]

lvim.builtin.which_key.setup.plugins.presets.z = true

lvim.autocmds = {
  {
    "BufReadPost",       -- see `:h autocmd-events`
    {                    -- this table is passed verbatim as `opts` to `nvim_create_autocmd`
      pattern = { "*" }, -- see `:h autocmd-events`
      command = "normal zR",
    },

    "FileReadPost",      -- see `:h autocmd-events`
    {                    -- this table is passed verbatim as `opts` to `nvim_create_autocmd`
      pattern = { "*" }, -- see `:h autocmd-events`
      command = "normal zR",
    }
  },
}
