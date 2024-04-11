return {
  "nvim-neorg/neorg",
  dependencies = {
    {
      "vhyrro/luarocks.nvim",
      priority = 1000,
      config = true,
    },
  },
  cmd = "Neorg",
  ft = "norg",
  version = "*",
  opts = {
    load = {
      ["core.defaults"] = {},
      ["core.concealer"] = {},
      ["core.clipboard.code-blocks"] = {},
    },
  },
  config = true,
}
