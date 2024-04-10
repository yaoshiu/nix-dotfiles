return {
  "lualine.nvim",
  opts = function(_, opts)
    opts.options.section_separators = { left = "", right = "" }
    opts.options.component_separators = "|"

    opts.sections.lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } }

    opts.sections.lualine_z = {
      {
        function()
          return " " .. os.date("%R")
        end,
        separator = { right = "" },
        left_padding = 2,
      },
    }
    return opts
  end,
}
