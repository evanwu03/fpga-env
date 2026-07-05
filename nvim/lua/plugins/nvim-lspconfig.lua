local lspconfig = {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    local ruff = "ruff"
    local lsp = "basedpyright"

    local servers = { "pyright", "ruff", "ruff_lsp" }

    opts.servers = opts.servers or {}

    for _, server in ipairs(servers) do
      opts.servers[server] = opts.servers[server] or {}
      opts.servers[server].enabled = server == lsp or server == ruff
    end
  end,
}
return lspconfig
