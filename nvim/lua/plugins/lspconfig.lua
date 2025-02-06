return {
  'neovim/nvim-lspconfig',
  lazy = false,
  config = function()
    local lspconfig = require('lspconfig')
    local servers = {
      ['fish-lsp'] = {},
      ['rust-analyzer'] = {},
      ['lua-language-server'] = {},
      ['bash-language-server'] = {},
      ['vim-language-server'] = {},
      ['nginx-language-server'] = {},
      ['tailwindcss-language-server'] = {},
      ['kotlin-language-server'] = {},
      ['cmake-language-server'] = {},
      ['autotools-language-server'] = {},
      ['arduino-language-server'] = {},
      ['ansible-language-server'] = {},
      ['zls'] = {},
    }
    for name, settings in pairs(servers) do
      lspconfig[name].setup({
        settings = {
          [name] = settings,
        }
      })
    end
  end
}
