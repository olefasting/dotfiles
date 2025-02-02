return {
  'vim-test/vim-test',
  dependencies = {
    'preservim/vimux'
  },
  config = function()
    vim.keymap.set('n', 'Tn', '<cmd>TestNearest<CR>', {})
    vim.keymap.set('n', 'Tf', '<cmd>TestFile<CR>', {})
    vim.keymap.set('n', 'Ta', '<cmd>TestSuite<CR>', {})
    vim.keymap.set('n', 'Tl', '<cmd>TestLast<CR>', {})
    vim.keymap.set('n', 'Tg', '<cmd>TestVisit<CR>', {})
    vim.cmd('let test#strategy = "vimux"')
  end,
}
