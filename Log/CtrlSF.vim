
Arguments                                                  *ctrlsf-arguments*

'-after', '-A'                              *ctrlsf_args_A*  *ctrlsf_args_after*

Defines how many lines after the matching line will be printed. '-A' is an
alias for '-after'.
>
:CtrlSF -A 10 foo
<
'-before', '-B'                             *ctrlsf_args_B* *ctrlsf_args_before*

Defines how many lines before the matching line will be printed. '-B' is an
alias for '-before'.
>
:CtrlSF -B 5 foo
<
'-context', '-C'                           *ctrlsf_args_C* *ctrlsf_args_context*

Defines how many lines around the matching line will be printed. '-C' is an
alias for '-context'.
>
:CtrlSF -C 0 foo
<
'-filetype'                                             *ctrlsf_args_filetype*

Defines which type of files should the search be restricted to. view
`ack --help=typs` for all available types.
>
:CtrlSF -filetype vim foo
<
'-filematch', '-G'                       *ctrlsf_args_G* *ctrlsf_args_filematch*

Defines a pattern that only files whose name is matching will be searched.
>
:Ctrlsf -filematch .*\.wrproject foo
<
'-ignorecase', '-I'                     *ctrlsf_args_I* *ctrlsf_args_ignorecase*

Make this search be case-insensitive.
>
:CtrlSF -I foo
<
'-ignoredir'                                           *ctrlsf_args_ignoredir*

Defines pattern of directories that should be ignored. The behavior of this
option depends on what backend you are using. The actual option used
here is '--ignore' for ag and '--ignore-dir' for ack.
>
:CtrlSF -ignoredir "bower_components" 'console.log'
<
'-literal', '-L'                           *ctrlsf_args_L* *ctrlsf_args_literal*

Use pattern as literal string.
>
:CtrlSF -L foo.*
<
'-matchcase', '-S'                       *ctrlsf_args_S* *ctrlsf_args_matchcase*

Make this search be case-sensitive.
>
:CtrlSF -S Foo
<
'-regex', '-R'                               *ctrlsf_args_R* *ctrlsf_args_regex*

Use pattern as regular expression.
>
:CtrlSF -R foo.*
<
'-smartcase'                                           *ctrlsf_args_smartcase*

Make this search be smart-cased.
>
:CtrlSF -smartcase Foo
<
2.3 Examples                                                   *ctrlsf-examples*

1. Search in a specific sub-directory
>
:CtrlSF {pattern} /path/to/dir
<
2. Search case-insensitively
>
:CtrlSF -I {pattern}
<
3. Search with regular expression
>
:CtrlSF -R {regex}
<
4. Show result with specific context setting
>
:CtrlSF -A 3 -B 1 {pattern}
<
5. Search in files with specific extension
>
:CtrlSF -G .*\.cpp {pattern}
<
================================================================================
3. Commands                                                    *ctrlsf-commands*

:CtrlSF [arguments] {pattern} [path] ...                               *:CtrlSF*

Search {pattern}. Default is search by literal. Show result in a new CtrlSF
window if there is no existing one, otherwise reuse that one.

[arguments] are all valid CtrlSF arguments, see |ctrlsf-arguments| for what
    they are.

    [path] is one or more directories/files where CtrlSF will search. If nothing
    is given, the default directory is used, which is specified by
    |g:ctrlsf_default_root|.

    :CtrlSFQuickfix [arguments] {pattern} [path] ...               *:CtrlSFQuickfix*

    Similar to |:CtrlSF|. Search {pattern}. Default is search by literal. Show
    result in a quickfix window if there is no existing one, otherwise reuse
    that one.

    :CtrlSFOpen                                                        *:CtrlSFOpen*

    If CtrlSF window is closed (by <q> or |:CtrlSFClose|), reopen it. If the
    window is already on display, then focus it.

    :CtrlSFUpdate                                                    *:CtrlSFUpdate*

    Update CtrlSF result by invoking a new search with same arguments and pattern
    of last one.

    :CtrlSFClose                                                      *:CtrlSFClose*

    Close an existing CtrlSF window. If there is no active CtrlSF window, do
    nothing.

    :CtrlSFClearHL                                                  *:CtrlSFClearHL*

    If you have turned on |g:ctrlsf_selected_line_hl|, use this command to clear
    highlighting on the selected line.

    :CtrlSFToggle                                                    *:CtrlSFToggle*

    Open the CtrlSF window if it is closed, or vice versa.

    :CtrlSFToggleMap                                              *:CtrlSFToggleMap*

    Toggle CtrlSF's default key mapping. This command can be used in CtrlSF
    window only.
