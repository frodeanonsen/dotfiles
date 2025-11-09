return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    code = {
      sign = false,
      width = "block",
      right_pad = 1,
    },
    heading = {
      sign = false,
      icons = {},
    },
    checkbox = {
      enabled = false,
    },
    latex = {
      -- Turn on / off latex rendering.
      enabled = true,
      -- Additional modes to render latex.
      render_modes = false,
      -- Executable used to convert latex formula to rendered unicode.
      -- If a list is provided the first command available on the system is used.
      converter = { "utftex", "latex2text" },
      -- Highlight for latex blocks.
      highlight = "RenderMarkdownMath",
      -- Determines where latex formula is rendered relative to block.
      -- | above  | above latex block                               |
      -- | below  | below latex block                               |
      -- | center | centered with latex block (must be single line) |
      position = "center",
      -- Number of empty lines above latex blocks.
      top_pad = 0,
      -- Number of empty lines below latex blocks.
      bottom_pad = 0,
    },
  },
  ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
  config = function(_, opts)
    require("render-markdown").setup(opts)
    Snacks.toggle({
      name = "Render Markdown",
      get = function()
        return require("render-markdown.state").enabled
      end,
      set = function(enabled)
        local m = require("render-markdown")
        if enabled then
          m.enable()
        else
          m.disable()
        end
      end,
    }):map("<leader>um")
  end,
}
