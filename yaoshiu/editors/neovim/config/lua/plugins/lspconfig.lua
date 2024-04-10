return {
  "nvim-lspconfig",
  opts = {
    servers = {
      tailwindcss = {
        init_options = {
          userLanguages = {
            eelixir = "html-eex",
            eruby = "erb",
            rust = "html",
          },
        },
      },
    },
  },
}
