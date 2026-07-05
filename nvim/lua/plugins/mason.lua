local mason = {
  "mason-org/mason.nvim",
  opts = {
    ensure_installed = {
      "verible",
      "pyright",
    },

    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  },
}
return mason
