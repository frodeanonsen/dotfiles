return {
  {
    "dhruvasagar/vim-table-mode",
    cmd = {
      "TableAddFormula",
      "TableEvalFormulaLine",
      "TableModeDisable",
      "TableModeEnable",
      "TableModeRealign",
      "TableModeToggle",
      "TableSort",
      "Tableize",
    },
    keys = {
      {
        "<C-t>f",
        "<CMD>TableAddFormula<CR>",
        desc = "Add Formula",
      },
      {
        "<C-t>e",
        "<CMD>TableEvalFormulaLine<CR>",
        desc = "Eval Formula Line",
      },
      {
        "<C-t>r",
        "<CMD>TableModeRealign<CR>",
        desc = "Realign",
      },
      {
        "<C-t>t",
        "<CMD>TableModeToggle<CR>",
        desc = "Toggle",
      },
      {
        "<C-t>s",
        "<CMD>TableSort<CR>",
        desc = "Sort",
      },
      {
        "<C-t>z",
        "<CMD>Tableize<CR>",
        desc = "Tableize",
      },
    },
    init = function()
      vim.g.table_mode_corner = "|"
      vim.g.table_mode_corner_corner = "|"
      vim.g.table_mode_header_fillchar = "-"
    end,
    config = function(_, opts)
      require("lazyvim.util").on_load("which-key.nvim", function()
        require("which-key").register({
          mode = { "n" },
          ["<C-t>"] = {
            name = "Table",
          },
        })
      end)
    end,
    -- enabled = vim.builtin.vim_table_mode.active,
  },
}
