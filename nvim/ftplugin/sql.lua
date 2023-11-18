vim.cmd [[
  autocmd BufWritePre,FileWritePre * %!sqlformat --reindent --keywords upper --identifiers lower -
]]
