
" C or lpc
au BufNewFile,BufRead *.c			call s:FTlpc()

func! s:FTlpc()
  if exists("g:lpc_syntax_for_c")
    let lnum = 1
    while lnum <= 12
      if getline(lnum) =~# '^\(//\|inherit\|private\|protected\|nosave\|string\|object\|mapping\|mixed\)'
	setf lpc
	return
      endif
      let lnum = lnum + 1
    endwhile
  endif
  setf c
endfunc

au BufRead,BufNewFile *.cc,*.cxx,*.c++,*.hh,*hxx,*.hpp,*.ipp,*.moc,*.tcc,*.inl setf cpp

" .h files can be C, Ch C++, ObjC or ObjC++.
" Set c_syntax_for_h if you want C, ch_syntax_for_h if you want Ch. ObjC is
" detected automatically.
au BufNewFile,BufRead *.h			call s:FTheader()

func! s:FTheader()
  if match(getline(1, min([line("$"), 200])), '^@\(interface\|end\|class\)') > -1
    setf objc
  elseif exists("g:c_syntax_for_h")
    setf c
  elseif exists("g:ch_syntax_for_h")
    setf ch
  else
    setf cpp
  endif
endfunc


