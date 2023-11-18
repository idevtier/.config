return {
  {
    'kristijanhusak/vim-dadbod-ui',
    lazy = true,
    cmd = { "DB", "DBUI" },
    ft = { "sql", "mysql", "plsql" },
    config = function()
      vim.g.db_ui_save_location = vim.fn.getcwd() .. "/sql/"
    end,
    dependencies = {
      'tpope/vim-dadbod',
      {
        'kristijanhusak/vim-dadbod-completion',
        config = function()
          vim.cmd [[
            augroup SqlCompletion
              autocmd!
              autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
            augroup end
          ]]
        end
      },
    }
  }
}
