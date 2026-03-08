vim.cmd([[cabbrev wq execute "Format sync" <bar> wq]]) -- Run formatting on wq.

vim.cmd([[
  " Kill a buffer and then close if only control windows are left.
  command! -nargs=0 -bang Qbuf bp<bang>|bw<bang> #|call CloseIfOnlyControlWinLeft()
  " Have q just wipe out a buffer and Q wipe out a split.
  cnoreabbr <expr> q getcmdtype() == ":" && getcmdline() == 'q' ? 'Qbuf' : 'q'
  cnoreabbr <expr> wq getcmdtype() == ":" && getcmdline() == 'wq' ? 'w<CR>:Qbuf' : 'wq'
  cnoreabbr <expr> Q getcmdtype() == ":" && getcmdline() == 'Q' ? '<C-w>q' : 'wq'
  autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll
  function! SynStack()
    for i1 in synstack(line("."), col("."))
      let i2 = synIDtrans(i1)
      let n1 = synIDattr(i1, "name")
      let n2 = synIDattr(i2, "name")
      echo n1 "->" n2
    endfor
  endfunction
  function! CloseIfOnlyControlWinLeft()
  if winnr("$") != 1
    return
  endif
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
      \ || &buftype == 'quickfix' || (line('$') == 1 && getline(1) == '')
    qa
  endif
  endfunction
]])
