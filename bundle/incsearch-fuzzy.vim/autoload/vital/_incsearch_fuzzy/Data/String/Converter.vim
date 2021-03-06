"=============================================================================
" FILE: autoload/vital/__latest__/Data/String/Converter.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:TRUE = !0
let s:FALSE = 0
let s:escaped_backslash = '\m\%(^\|[^\\]\)\%(\\\\\)*'
let s:non_escaped_backslash = '\m\%(\%(^\|[^\\]\)\%(\\\\\)*\)\@1<=\\'

function! s:_throw(message) abort
  throw printf('vital: Data.String.Converter: %s', a:message)
endfunction

" fuzzy --
function! s:fuzzy(pattern)
    if a:pattern is# '' | return '' | endif
    let pattern = substitute(a:pattern, s:non_escaped_backslash . '[mMvV]', '', 'g')
    let pattern = substitute(pattern, s:escaped_backslash . '\([mMvV]\)', '\1', 'g')
    let chars = map(split(pattern, '\zs'), "escape(v:val, '\\')")
    let p =  '\c\V' .
    \   join(map(chars[0:-2], "
    \       printf('%s\\[^%s]\\{-}', v:val, v:val)
    \   "), '') . chars[-1]
    return p
endfunction

let s:nonwords = join([
\   '[:space:]',
\ ], '')

" fuzzy word --
function! s:fuzzyword(pattern)
    if a:pattern is# '' | return '' | endif
    let pattern = substitute(a:pattern, s:non_escaped_backslash . '[mMvV]', '', 'g')
    let pattern = substitute(pattern, s:escaped_backslash . '\([mMvV]\)', '\1', 'g')
    let chars = map(split(pattern, '\zs'), "escape(v:val, '\\')")
    let p =  '\c\V\<\?' .
    \   join(map(chars[0:-2], "
    \       printf('%s\\[^%s%s]\\{-}', v:val, s:nonwords, v:val)
    \   "), '') . chars[-1]
    return p
endfunction

" smartsign --
let s:sign_table = {}
let s:sign_table.us = {
\  ',' : '<', '.' : '>', '/' : '?',
\  '1' : '!', '2' : '@', '3' : '#', '4' : '$', '5' : '%',
\  '6' : '^', '7' : '&', '8' : '*', '9' : '(', '0' : ')', '-' : '_', '=' : '+',
\  ';' : ':', '[' : '{', ']' : '}', '`' : '~', "'" : "\"", '\' : '|',
\  }

let s:sign_table.ja = {
\  ',' : '<', '.' : '>', '/' : '?',
\  '1' : '!', '2' : '"', '3' : '#', '4' : '$', '5' : '%',
\  '6' : '&', '7' : "'", '8' : '(', '9' : ')', '0' : '_', '-' : '=', '^' : '~',
\  ';' : '+', ':' : '*', '[' : '{', ']' : '}', '@' : '`', '\' : '|',
\  }

" characters which should be escaped in rectangle ([]) of regular expressions
let s:escape_in_rec = '\]^-/?'

function! s:get_smartsign_table(...) abort
  let table = get(a:, 1, s:sign_table.us)
  if type(table) is# type('')
    if !has_key(s:sign_table, table)
      call s:_throw(printf('table named %s does not exist', table))
    else
      let tmp = s:sign_table[table]
      unlet table
      let table = tmp
    endif
  endif
  return table
endfunction

" assume '\V'
function! s:smartsign_char(sign, ...) abort
  let table = call(function('s:get_smartsign_table'), a:000)
  return has_key(table, a:sign) ?
  \     printf('\[%s%s]',
  \         escape(a:sign, s:escape_in_rec),
  \         escape(table[a:sign], s:escape_in_rec))
  \   : a:sign
endfunction

function! s:smartsign(pattern, ...) abort
  let table = call(function('s:get_smartsign_table'), a:000)
  let signs = '\m[' . escape(join(keys(table), ''), s:escape_in_rec) . ']'
  return '\V' . substitute(a:pattern, signs, '\=
  \                        s:smartsign_char(submatch(0), table)', 'g')
endfunction

" fuzzyspell --
function! s:fuzzyspell(pattern) abort
  let spell_save = &spell
  let &spell = s:TRUE
  try
    return substitute(a:pattern, '\k\+', '\=s:_make_fuzzy_spell(submatch(0))', 'g')
  finally
    let &spell = spell_save
  endtry
endfunction

function! s:_spellsuggest(word, ...) abort
  let max = get(a:, 1, 25)
  return [a:word] + spellsuggest(a:word, max)
endfunction

function! s:_make_fuzzy_spell(word) abort
  return printf('\m\(%s\)', join(s:_spellsuggest(a:word), '\|'))
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
