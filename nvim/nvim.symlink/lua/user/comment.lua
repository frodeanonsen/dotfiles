local status_ok, comment = pcall(require, "nvim_comment")
if not status_ok then
	return
end

comment.setup({
  -- Linters prefer comment and line to have a space in between markers
  marker_padding = true,
  -- should comment out empty or whitespace only lines
  comment_empty = true,
  -- Should key mappings be created
  create_mappings = true,
  -- Normal mode mapping left hand side
  line_mapping = "gcc",
  -- Visual/Operator mapping left hand side
  operator_mapping = "gc",
  -- Hook function to call before commenting takes place
  hook = nil
})
