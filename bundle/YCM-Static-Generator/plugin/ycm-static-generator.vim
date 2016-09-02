
let s:config_gen = expand("<sfile>:p:h:h") . "/simple_ycm_generator.sh"

command! -nargs=? -complete=file_in_path -bang GenerateConfig call s:GenerateConfig(<bang>0, "<args>")

function! s:GenerateConfig(overwrite, flags)
    let l:cmd = "! " . s:config_gen . " " . a:flags

    if a:overwrite
        let l:cmd = l:cmd . " -f"
    endif

    let l:cmd = l:cmd . " " . expand("%:p:h")

    execute l:cmd
endfunction
