return {
  "3rd/image.nvim",
  dependencies = {
    {
      "luarocks.nvim",
      opts = {
        rocks = {
          "magick",
        },
      },
    },
  },
  ft = { "markdown", "norg", "vimdoc" },
  config = true,
}
