return {
  "nvim-lspconfig",
  opts = {
    inlay_hints = {
      enabled = true,
    },
    codelens = {
      enabled = true,
    },
    servers = {
      nixd = {
        settings = {
          nixd = {
            formatting = {
              command = { "nixfmt" },
            },
          },
        },
      },
    },
  },
}
