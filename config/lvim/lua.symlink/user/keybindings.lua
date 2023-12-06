lvim.keys.normal_mode["|"] = ":vsplit<CR>"
lvim.keys.normal_mode["-"] = ":split<CR>"


-- lvim.keys.normal_mode["Zz"] = '<c-w>_'
-- lvim.keys.normal_mode["Zo"] = '<c-w>='

-- noremap Zz <c-w>_ \| <c-w>\|
-- noremap Zo <c-w>=

-- lvim.keys.normal_mode["p"] = '"_dP'
-- lvim.keys.visual_mode["p"] = '"_dP'

lvim.builtin.which_key.mappings["sz"] = {
  "<cmd>lua require'telescope'.extensions.zoxide.list{}<CR>", "Z"
}

lvim.builtin.which_key.mappings["sb"] = {
  "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find({ sorter = require('telescope.sorters').get_substr_matcher({})})<CR>",
  "Search buffer"
}

lvim.builtin.which_key.mappings["bm"] = {
  "<cmd>ZenMode<CR>", "Maximize buffer"
}
