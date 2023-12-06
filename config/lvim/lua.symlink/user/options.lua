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
