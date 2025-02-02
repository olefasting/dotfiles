return {
  {
    '<leader>williamboman/mason.nvim',
    lazy = false,
    config = function()
      require('mason').setup()
    end,
  },
  {
    '<leader>williamboman/mason-lspconfig.nvim',
    lazy = false,
    opts = {
      auto_install = true,
    },
  },
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    config = function()
      local cmp_nvim_lsp = require('cmp_nvim_lsp')
      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_nvim_lsp.default_capabilities()
      )

      local lspconfig = require('lspconfig')

      local commonon_on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        --Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        local opts = { noremap=true, silent=true }

        buf_set_keymap('n', '<leader>g', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', '<leader>T', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap('n', '<leader>C', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', '<leader>M', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap('n', '<leader>I', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('n', '<leader>S', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_geymap('n', '<leader>R', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<leader>F', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
        buf_set_keymap('n', '<leader>w', '<cmd>lua vim.lsp.buf.add_workleader_folder()<CR>', opts)
        buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workleader_folder()<CR>', opts)
        buf_set_keymap('n', '<leader>wl', '<cmd>lua vim.lsp.buf.list_workleader_folders()<CR>', opts)
        buf_set_keymap('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        buf_set_keymap('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        buf_set_keymap('n', '<leader>s', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        buf_set_keymap('n', '<leader>b', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
        buf_set_keymap('n', '<leader>h', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
        buf_set_keymap('n', '<leader>l', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
      end

      local servers = {
        {
          'lua_ls',
          on_init = function(client)
            if client.workleader_folders then
              local path = client.workleader_folders[1].name
              if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
                return
              end
            end
            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                  version = 'LuaJIT'
              },
              workleader = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  '${XDG_CONFIG_HOME}/nvim/snippets',
                  -- Depending on the usage, you might want to add additional paths here.
                  -- '${3rd}/luv/library'
                  -- '${3rd}/busted/library',
                }
              }
            })
          end,
          settings = {
            Lua = {}
          }
        },
        { 'ruby_lsp' },
        { 'tailwindcss' },
        { 'pyright' },
        { 'rust_analyzer' },
        { 'tsserver' },
      }

      for _, v in ipairs(servers) do
        local lsp = v[0]
        lspconfig.[lsp].setup({
          capabilities = capabilities,
          on_init = lsp.on_init,
          on_attach = common_on_attach,
          flags = {
            debounce_text_changes = 150,
          },
          settings = lsp.settings,
        })
      end
    end,
  },
}
