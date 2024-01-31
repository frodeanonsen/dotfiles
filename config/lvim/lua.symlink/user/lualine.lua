local function ins_left(component)
  table.insert(lvim.builtin.lualine.sections.lualine_x, component)
end

-- ins_left {
--   function()
--     return "TEST2"
--   end,
--   color = 'LualineModeInv',
--   padding = { left = 1, right = 0 }
-- }
