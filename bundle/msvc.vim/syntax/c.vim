" Vim syntax file
" Language:	C
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change:	2012 May 03

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" A bunch of useful C keywords
syn keyword	cStatement	goto break return continue asm
syn keyword	cLabel		case default
syn keyword	cConditional	if else switch
syn keyword	cRepeat		while for do

syn keyword	cTodo		contained TODO FIXME XXX

" It's easy to accidentally add a space after a backslash that was intended
" for line continuation.  Some compilers allow it, which makes it
" unpredicatable and should be avoided.
syn match	cBadContinuation contained "\\\s\+$"

" cCommentGroup allows adding matches for special things in comments
syn cluster	cCommentGroup	contains=cTodo,cBadContinuation

" String and Character constants
" Highlight special characters (those which have a backslash) differently
syn match	cSpecial	display contained "\\\(x\x\+\|\o\{1,3}\|.\|$\)"
if !exists("c_no_utf")
  syn match	cSpecial	display contained "\\\(u\x\{4}\|U\x\{8}\)"
endif
if exists("c_no_cformat")
  syn region	cString		start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=cSpecial,@Spell extend
  " cCppString: same as cString, but ends at end of line
  syn region	cCppString	start=+L\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end='$' contains=cSpecial,@Spell
else
  if !exists("c_no_c99") " ISO C99
    syn match	cFormat		display "%\(\d\+\$\)\=[-+' #0*]*\(\d*\|\*\|\*\d\+\$\)\(\.\(\d*\|\*\|\*\d\+\$\)\)\=\([hlLjzt]\|ll\|hh\)\=\([aAbdiuoxXDOUfFeEgGcCsSpn]\|\[\^\=.[^]]*\]\)" contained
  else
    syn match	cFormat		display "%\(\d\+\$\)\=[-+' #0*]*\(\d*\|\*\|\*\d\+\$\)\(\.\(\d*\|\*\|\*\d\+\$\)\)\=\([hlL]\|ll\)\=\([bdiuoxXDOUfeEgGcCsSpn]\|\[\^\=.[^]]*\]\)" contained
  endif
  syn match	cFormat		display "%%" contained
  syn region	cString		start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=cSpecial,cFormat,@Spell extend
  " cCppString: same as cString, but ends at end of line
  syn region	cCppString	start=+L\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end='$' contains=cSpecial,cFormat,@Spell
endif

syn match	cCharacter	"L\='[^\\]'"
syn match	cCharacter	"L'[^']*'" contains=cSpecial
if exists("c_gnu")
  syn match	cSpecialError	"L\='\\[^'\"?\\abefnrtv]'"
  syn match	cSpecialCharacter "L\='\\['\"?\\abefnrtv]'"
else
  syn match	cSpecialError	"L\='\\[^'\"?\\abfnrtv]'"
  syn match	cSpecialCharacter "L\='\\['\"?\\abfnrtv]'"
endif
syn match	cSpecialCharacter display "L\='\\\o\{1,3}'"
syn match	cSpecialCharacter display "'\\x\x\{1,2}'"
syn match	cSpecialCharacter display "L'\\x\x\+'"

if !exists("c_no_c11") " ISO C11
  if exists("c_no_cformat")
    syn region	cString		start=+\%(U\|u8\=\)"+ skip=+\\\\\|\\"+ end=+"+ contains=cSpecial,@Spell extend
  else
    syn region	cString		start=+\%(U\|u8\=\)"+ skip=+\\\\\|\\"+ end=+"+ contains=cSpecial,cFormat,@Spell extend
  endif
  syn match	cCharacter	"[Uu]'[^\\]'"
  syn match	cCharacter	"[Uu]'[^']*'" contains=cSpecial
  if exists("c_gnu")
    syn match	cSpecialError	"[Uu]'\\[^'\"?\\abefnrtv]'"
    syn match	cSpecialCharacter "[Uu]'\\['\"?\\abefnrtv]'"
  else
    syn match	cSpecialError	"[Uu]'\\[^'\"?\\abfnrtv]'"
    syn match	cSpecialCharacter "[Uu]'\\['\"?\\abfnrtv]'"
  endif
  syn match	cSpecialCharacter display "[Uu]'\\\o\{1,3}'"
  syn match	cSpecialCharacter display "[Uu]'\\x\x\+'"
endif

"when wanted, highlight trailing white space
if exists("c_space_errors")
  if !exists("c_no_trail_space_error")
    syn match	cSpaceError	display excludenl "\s\+$"
  endif
  if !exists("c_no_tab_space_error")
    syn match	cSpaceError	display " \+\t"me=e-1
  endif
endif

" This should be before cErrInParen to avoid problems with #define ({ xxx })
if exists("c_curly_error")
  syntax match cCurlyError "}"
  syntax region	cBlock		start="{" end="}" contains=ALLBUT,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cCppParen,cErrInBracket,cCppBracket,cCppString,@Spell fold
else
  syntax region	cBlock		start="{" end="}" transparent fold
endif

"catch errors caused by wrong parenthesis and brackets
" also accept <% for {, %> for }, <: for [ and :> for ] (C99)
" But avoid matching <::.
syn cluster	cParenGroup	contains=cParenError,cIncluded,cSpecial,cCommentSkip,cCommentString,cComment2String,@cCommentGroup,cCommentStartError,cUserCont,cUserLabel,cBitField,cOctalZero,@cCppOutInGroup,cFormat,cNumber,cFloat,cOctal,cOctalError,cNumbersCom
if exists("c_no_curly_error")
  syn region	cParen		transparent start='(' end=')' end='}'me=s-1 contains=ALLBUT,cBlock,@cParenGroup,cCppParen,cCppString,@Spell
  " cCppParen: same as cParen but ends at end-of-line; used in cDefine
  syn region	cCppParen	transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@cParenGroup,cParen,cString,@Spell
  syn match	cParenError	display ")"
  syn match	cErrInParen	display contained "^[{}]\|^<%\|^%>"
elseif exists("c_no_bracket_error")
  syn region	cParen		transparent start='(' end=')' end='}'me=s-1 contains=ALLBUT,cBlock,@cParenGroup,cCppParen,cCppString,@Spell
  " cCppParen: same as cParen but ends at end-of-line; used in cDefine
  syn region	cCppParen	transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@cParenGroup,cParen,cString,@Spell
  syn match	cParenError	display ")"
  syn match	cErrInParen	display contained "[{}]\|<%\|%>"
else
  syn region	cParen		transparent start='(' end=')' end='}'me=s-1 contains=ALLBUT,cBlock,@cParenGroup,cCppParen,cErrInBracket,cCppBracket,cCppString,@Spell
  " cCppParen: same as cParen but ends at end-of-line; used in cDefine
  syn region	cCppParen	transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@cParenGroup,cErrInBracket,cParen,cBracket,cString,@Spell
  syn match	cParenError	display "[\])]"
  syn match	cErrInParen	display contained "[\]{}]\|<%\|%>"
  syn region	cBracket	transparent start='\[\|<::\@!' end=']\|:>' end='}'me=s-1 contains=ALLBUT,cBlock,@cParenGroup,cErrInParen,cCppParen,cCppBracket,cCppString,@Spell
  " cCppBracket: same as cParen but ends at end-of-line; used in cDefine
  syn region	cCppBracket	transparent start='\[\|<::\@!' skip='\\$' excludenl end=']\|:>' end='$' contained contains=ALLBUT,@cParenGroup,cErrInParen,cParen,cBracket,cString,@Spell
  syn match	cErrInBracket	display contained "[);{}]\|<%\|%>"
endif

syntax region	cBadBlock	keepend start="{" end="}" contained containedin=cParen,cBracket,cBadBlock transparent fold

"integer number, or floating point number without a dot and with "f".
syn case ignore
syn match	cNumbers	display transparent "\<\d\|\.\d" contains=cNumber,cFloat,cOctalError,cOctal
" Same, but without octal error (for comments)
syn match	cNumbersCom	display contained transparent "\<\d\|\.\d" contains=cNumber,cFloat,cOctal
syn match	cNumber		display contained "\d\+\(u\=l\{0,2}\|ll\=u\)\>"
"hex number
syn match	cNumber		display contained "0x\x\+\(u\=l\{0,2}\|ll\=u\)\>"
" Flag the first zero of an octal number as something special
syn match	cOctal		display contained "0\o\+\(u\=l\{0,2}\|ll\=u\)\>" contains=cOctalZero
syn match	cOctalZero	display contained "\<0"
syn match	cFloat		display contained "\d\+f"
"floating point number, with dot, optional exponent
syn match	cFloat		display contained "\d\+\.\d*\(e[-+]\=\d\+\)\=[fl]\="
"floating point number, starting with a dot, optional exponent
syn match	cFloat		display contained "\.\d\+\(e[-+]\=\d\+\)\=[fl]\=\>"
"floating point number, without dot, with exponent
syn match	cFloat		display contained "\d\+e[-+]\=\d\+[fl]\=\>"
if !exists("c_no_c99")
  "hexadecimal floating point number, optional leading digits, with dot, with exponent
  syn match	cFloat		display contained "0x\x*\.\x\+p[-+]\=\d\+[fl]\=\>"
  "hexadecimal floating point number, with leading digits, optional dot, with exponent
  syn match	cFloat		display contained "0x\x\+\.\=p[-+]\=\d\+[fl]\=\>"
endif

" flag an octal number with wrong digits
syn match	cOctalError	display contained "0\o*[89]\d*"
syn case match

if exists("c_comment_strings")
  " A comment can contain cString, cCharacter and cNumber.
  " But a "*/" inside a cString in a cComment DOES end the comment!  So we
  " need to use a special type of cString: cCommentString, which also ends on
  " "*/", and sees a "*" at the start of the line as comment again.
  " Unfortunately this doesn't very well work for // type of comments :-(
  syntax match	cCommentSkip	contained "^\s*\*\($\|\s\+\)"
  syntax region cCommentString	contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end=+\*/+me=s-1 contains=cSpecial,cCommentSkip
  syntax region cComment2String	contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end="$" contains=cSpecial
  syntax region  cCommentL	start="//" skip="\\$" end="$" keepend contains=@cCommentGroup,cComment2String,cCharacter,cNumbersCom,cSpaceError,@Spell
  if exists("c_no_comment_fold")
    " Use "extend" here to have preprocessor lines not terminate halfway a
    " comment.
    syntax region cComment	matchgroup=cCommentStart start="/\*" end="\*/" contains=@cCommentGroup,cCommentStartError,cCommentString,cCharacter,cNumbersCom,cSpaceError,@Spell extend
  else
    syntax region cComment	matchgroup=cCommentStart start="/\*" end="\*/" contains=@cCommentGroup,cCommentStartError,cCommentString,cCharacter,cNumbersCom,cSpaceError,@Spell fold extend
  endif
else
  syn region	cCommentL	start="//" skip="\\$" end="$" keepend contains=@cCommentGroup,cSpaceError,@Spell
  if exists("c_no_comment_fold")
    syn region	cComment	matchgroup=cCommentStart start="/\*" end="\*/" contains=@cCommentGroup,cCommentStartError,cSpaceError,@Spell extend
  else
    syn region	cComment	matchgroup=cCommentStart start="/\*" end="\*/" contains=@cCommentGroup,cCommentStartError,cSpaceError,@Spell fold extend
  endif
endif
" keep a // comment separately, it terminates a preproc. conditional
syntax match	cCommentError	display "\*/"
syntax match	cCommentStartError display "/\*"me=e-1 contained

syn keyword	cOperator	sizeof
if exists("c_gnu")
  syn keyword	cStatement	__asm__
  syn keyword	cOperator	typeof __real__ __imag__
endif
syn keyword	cType		int long short char void
syn keyword	cType		signed unsigned float double
if !exists("c_no_ansi") || exists("c_ansi_typedefs")
  syn keyword   cType		size_t ssize_t off_t wchar_t ptrdiff_t sig_atomic_t fpos_t
  syn keyword   cType		clock_t time_t va_list jmp_buf FILE DIR div_t ldiv_t
  syn keyword   cType		mbstate_t wctrans_t wint_t wctype_t
endif
if !exists("c_no_c99") " ISO C99
  syn keyword	cType		_Bool bool _Complex complex _Imaginary imaginary
  syn keyword	cType		int8_t int16_t int32_t int64_t
  syn keyword	cType		uint8_t uint16_t uint32_t uint64_t
  syn keyword	cType		int_least8_t int_least16_t int_least32_t int_least64_t
  syn keyword	cType		uint_least8_t uint_least16_t uint_least32_t uint_least64_t
  syn keyword	cType		int_fast8_t int_fast16_t int_fast32_t int_fast64_t
  syn keyword	cType		uint_fast8_t uint_fast16_t uint_fast32_t uint_fast64_t
  syn keyword	cType		intptr_t uintptr_t
  syn keyword	cType		intmax_t uintmax_t
endif
if exists("c_gnu")
  syn keyword	cType		__label__ __complex__ __volatile__
endif

syn keyword	cStructure	struct union enum typedef
syn keyword	cStorageClass	static register auto volatile extern const

if !exists("c_gnu")
  " VS 2012 SAL annotations
  " See: http://msdn.microsoft.com/en-us/library/ms182032.aspx
  syn keyword     cStorageClass   _In_ _Inout_ _Out_ _Outptr_ _In_count_
  syn keyword     cStorageClass   _In_z_ _Inout_z_ _In_reads_ _In_reads_bytes_ _In_reads_z_
  syn keyword     cStorageClass   _In_reads_or_z_ _Out_writes_ _Out_writes_bytes_ _Out_writes_z_
  syn keyword     cStorageClass   _Inout_updates_ _Inout_updates_bytes_ _Inout_updates_z_
  syn keyword     cStorageClass   _Out_writes_to_ _Out_writes_bytes_to_ _Out_writes_all_
  syn keyword     cStorageClass   _Out_writes_bytes_all_ _Inout_updates_to_
  syn keyword     cStorageClass   _Inout_updates_bytes_to_ _Inout_updates_all_
  syn keyword     cStorageClass   _Inout_updates_bytes_all_ _In_reads_to_ptr_ _In_reads_to_ptr_z_
  syn keyword     cStorageClass   _Out_writes_to_ptr_ _Out_writes_to_ptr_z_

  syn keyword     cStorageClass   _In_opt_ _Inout_opt_ _Out_opt_ _In_opt_z_ _Inout_opt_z_
  syn keyword     cStorageClass   _In_reads_opt_ _In_reads_bytes_opt_ _In_reads_opt_z_
  syn keyword     cStorageClass   _Out_writes_opt_ _Out_writes_opt_z_ _Inout_updates_opt_
  syn keyword     cStorageClass   _Inout_updates_bytes_opt_ _Inout_updates_opt_z_
  syn keyword     cStorageClass   _Out_writes_to_opt_ _Out_writes_bytes_to_opt_ _Out_writes_all_opt_
  syn keyword     cStorageClass   _Out_writes_bytes_all_opt_ _Inout_updates_to_opt_
  syn keyword     cStorageClass   _Inout_updates_bytes_to_opt_ _Inout_updates_all_opt_
  syn keyword     cStorageClass   _Inout_updates_bytes_all_opt_ _In_reads_to_ptr_opt_
  syn keyword     cStorageClass   _In_reads_to_ptr_opt_z_ _Out_writes_to_ptr_opt_
  syn keyword     cStorageClass   _Out_writes_to_ptr_opt_z_

  syn keyword     cStorageClass   _Outptr_ _Outptr_opt_ _Outptr_result_maybenull_
  syn keyword     cStorageClass   _Outptr_opt_result_maybenull_

  syn keyword     cStorageClass   _Outptr_result_z_ _Outptr_opt_result_z_
  syn keyword     cStorageClass   _Outptr_result_maybenull_z_ _Ouptr_opt_result_maybenull_z_
  syn keyword     cStorageClass   _COM_Outptr_ _COM_Outptr_opt_ _COM_Outptr_result_maybenull_
  syn keyword     cStorageClass   _COM_Outptr_opt_result_maybenull_
  syn keyword     cStorageClass   _Outptr_result_buffer_ _Outptr_result_bytebuffer_
  syn keyword     cStorageClass   _Outptr_opt_result_buffer_ _Outptr_opt_result_bytebuffer_
  syn keyword     cStorageClass   _Outptr_result_buffer_to_ _Outptr_result_bytebuffer_to_
  syn keyword     cStorageClass   _Outptr_opt_result_buffer_to_ _Outptr_opt_result_bytebuffer_to_
  syn keyword     cOperator       _Result_nullonfailure_ _Result_zeroonfailure_
  syn keyword     cStorageClass   _Outptr_result_nullonfailure_ _Outptr_opt_result_nullonfailure_
  syn keyword     cStorageClass   _Outref_result_nullonfailure_

  syn keyword     cStorageClass   _Outref_ _Outref_result_maybenull_ _Outref_result_buffer_
  syn keyword     cStorageClass   _Outref_result_bytebuffer_ _Outref_result_buffer_to_
  syn keyword     cStorageClass   _Outref_result_bytebuffer_to_ _Outref_result_buffer_all_
  syn keyword     cStorageClass   _Outref_result_bytebuffer_all_ _Outref_result_buffer_maybenull_
  syn keyword     cStorageClass   _Outref_result_bytebuffer_maybenull_ _Outref_result_buffer_to_maybenull_
  syn keyword     cStorageClass   _Outref_result_bytebuffer_to_maybenull_ _Outref_result_buffer_all_maybenull_
  syn keyword     cStorageClass   _Outref_result_bytebuffer_all_maybenull_

  syn keyword     cStorageClass   _Ret_z_ _Ret_writes_ _Ret_writes_bytes_ _Ret_writes_z_
  syn keyword     cStorageClass   _Ret_writes_to_ _Ret_writes_maybenull_ _Ret_writes_to_maybenull_
  syn keyword     cStorageClass   _Ret_writes_maybenull_z_ _Ret_maybenull_ _Ret_maybenull_z_
  syn keyword     cStorageClass   _Ret_null_ _Ret_notnull_ _Ret_writes_bytes_to_
  syn keyword     cStorageClass   _Ret_writes_bytes_maybenull_ _Ret_writes_bytes_to_maybenull_

  syn keyword     cOperator       _In_range_ _Out_range_ _Ret_range_ _Deref_in_range_
  syn keyword     cOperator       _Deref_out_range_ _Deref_inout_range_ _Field_range_
  syn keyword     cOperator       _Pre_equal_to_ _Post_equal_to_ _Struct_size_bytes_ _Satisfies_

  " Function annotations
  syn keyword     cStorageClass   _Called_from_function_class_ _Check_return_ _Function_class_
  syn keyword     cStorageClass   _Raises_SEH_exception_ _Maybe_raises_SEH_exception_
  syn keyword     cStorageClass   _Must_inspect_result_ _Use_decl_annotations_

  " Success/failure annotations
  syn keyword     cOperator       _Always_ _On_failure_ _Return_type_success_ _Success_

  " Struct and class annotations
  syn keyword     cOperator       _Field_range_ _Field_size_ _Field_size_opt_ _Field_size_bytes_
  syn keyword     cOperator       _Field_size_bytes_opt_ _Field_size_part_ _Field_size_part_opt_
  syn keyword     cOperator       _Field_size_bytes_part_ _Field_size_bytes_part_opt_
  syn keyword     cOperator       _Field_size_full_ _Field_size_full_opt_ _Field_size_bytes_full_
  syn keyword     cOperator       _Field_size_bytes_full_opt_ _Struct_size_bytes_

  " Concurrency SAL annotations
  " See: http://msdn.microsoft.comi/en-us/library/hh916381.aspx
  syn keyword     cStorageClass   _Acquires_exclusive_lock_ _Acquires_lock_

  syn keyword     cStorageClass   _Acquires_nonreentrant_lock_ _Acquries_shared_lock_
  syn keyword     cStorageClass   _Creates_lock_level_ _Has_lock_kind_
  syn keyword     cType           _Lock_kind_mutex_ _Lock_kind_event_ _Lock_kind_semaphore_
  syn keyword     cType           _Lock_kind_spin_lock_ _Lock_kind_critical_section_
  syn keyword     cStorageClass   _Has_lock_level_ _Lock_level_order_
  syn keyword     cStorageClass   _Post_same_lock_ _Releases_exclusive_lock_
  syn keyword     cStorageClass   _Releases_lock_ _Releases_nonreentrant_lock_
  syn keyword     cStorageClass   _Releases_shared_lock_ _Requires_lock_held_
  syn keyword     cStorageClass   _Requires_lock_not_held_ _Requires_no_locks_held_
  syn keyword     cStorageClass   _Requires_shared_lock_held_ _Requires_exclusive_lock_held_
  syn keyword     cType           _Global_cancel_spin_lock_ _Global_critical_region_
  syn keyword     cType           _Global_interlock_ _Global_priority_region_
  syn keyword     cStorageClass   _Guarded_by_ _Interlocked_ _Interlocked_operand_
  syn keyword     cStorageClass   _Write_guarded_by_

  " Structural annotations
  syn keyword     cStatement      _At_ _At_buffer_ _Group_ _When_

  " Intrinsic functions
  syn keyword     cStatement      _Curr_
  syn keyword     CStorageClass   _Inexpressible_
  syn keyword     cOperator       _Old_ _Param_
  syn keyword     cOperator       _Nullterm_length_ _String_length_

  " SAL2 annotations for drivers
  " See: http://msdn.microsoft.com/en-us/library/windows/hardware/hh454237(v=vs.85).aspx
  syn keyword     cStorageClass   _IRQL_requires_max_ _IRQL_requires_min_ _IRQL_requires_
  syn keyword     cStorageClass   _IRQL_raises_ _IRQL_saves_ _IRQL_restores_ _IRQL_saves_global_
  syn keyword     cStorageClass   _IRQL_restores_global_ _IRQL_always_function_min_
  syn keyword     cStorageClass   _IRQL_always_function_max_ _IRQL_requires_same_
  syn keyword     cStorageClass   _IRQL_uses_cancel_ _IRQL_is_cancel_
  syn keyword     cOperator       _Kernel_float_saved_ _Kernel_float_restored_ _Kernel_float_used_
  syn keyword     cStorageClass   _Kernel_clear_do_init_
  syn keyword     cStorageClass   _Kernel_IoGetDmaAdapter_

  " VS 2005 CRT SAL annotations
  " See: http://msdn.microsoft.com/en-us/library/ms235402(v=vs.80).aspx
  " TODO Add support for _z and _nz annotations
  syn keyword     cStorageClass   FASTCALL __fastcall
  syn keyword     cStorageClass   __in __out __inout __in_opt __out_opt __inout_opt
  syn keyword     cStorageClass   __in_bcount __in_ecount
  syn keyword     cStorageClass   __inout_bcount __inout_ecount __inout_bcount_full
  syn keyword     cStorageClass   __inout_bcount_part __inout_ecount_full __inout_ecount_part
  syn keyword     cStorageClass   __in_bcount_opt
  syn keyword     cStorageClass   __out_bcount __out_ecount __out_bcount_full __out_bcount_part
  syn keyword     cStorageClass   __out_ecount_full __out_ecount_part __out_bcount_opt
  syn keyword     cStorageClass   __success __nullterminated __nullnullterminated __reserved
  syn keyword     cStorageClass   __checkReturn __typefix __override __callback __format_string
  syn keyword     cStorageClass   __blocksOn __fallthrough

  " MS types
  syn keyword     cType           NTSTATUS HRESULT
  syn keyword     cType           BOOLEAN PBOOLEAN BOOL PBOOL
  syn keyword     cType           PLONG PULONG LONG ULONG LONGLONG ULONGLONG SHORT USHORT PUSHORT
  syn keyword     cType           PLONGLONG PULONGLONG PSHORT ULONG64 LONG64 PULONG64 PLONG64
  syn keyword     cType           ULONG_PTR CHAR PCHAR UCHAR PUCHAR WCHAR PWCHAR
  syn keyword     cType           LARGE_INTEGER PLARGE_INTEGER UNICODE_STRING PUNICODE_STRING
  syn keyword     cType           VOID PVOID
  " GUIDs too because everyone loves GUIDs.
  syn keyword     cType           GUID PGUID 

  " Microsoft specific types
  " http://msdn.microsoft.com/en-us/library/cc953fe1(v=vs.80).aspx
  syn keyword     cType           __int __int8 __int16 __int32 __int64
  syn keyword     ctype           __wchar_t
  syn keyword     cType           __m64 __m128 __m128d __m128i __ptr32 __ptr64

  syn keyword     cConstant       TRUE FALSE

  " Microsoft-specific numerical limits
  " http://msdn.microsoft.com/en-us/library/296az74e.aspx
  syn keyword     cConstant       _I64_MIN _I64_MAX _UI64_MAX
  syn keyword     cConstant       FLT_DIG DBL_DIG LDBL_DIG
  syn keyword     cConstant       FLT_EPSILON DBL_EPSILON LDBL_EPSILON FLT_GUARD
  syn keyword     cConstant       FLT_MANT_DIG DBL_MANT_DIG LDBL_MANT_DIG
  syn keyword     cConstant       FLT_MAX DBL_MAX LDBL_MAX
  syn keyword     cConstant       FLT_MAX_10_EXP DBL_MAX_10_EXP LDBL_MAX_10_EXP
  syn keyword     cConstant       FLT_MAX_EXP DBL_MAX_EXP LDBL_MAX_EXP
  syn keyword     cConstant       FLT_MIN DBL_MIN LDBL_MIN
  syn keyword     cConstant       FLT_MIN_10_EXP DBL_MIN_10_EXP LDBL_MIN_10_EXP
  syn keyword     cConstant       FLT_MIN_EXP DBL_MIN_EXP LDBL_MIN_EXP
  syn keyword     cConstant       FLT_NORMALIZE FLT_RADIX _DBL_RADIX _LDBL_RADIX
  syn keyword     cConstant       FLT_ROUNDS _DBL_ROUNDS _LDBL_ROUNDS
endif
if exists("c_gnu")
  syn keyword	cStorageClass	inline __attribute__
endif
if !exists("c_no_c99")
  syn keyword	cStorageClass	inline restrict
endif
if !exists("c_no_c11")
  syn keyword	cStorageClass	_Alignas alignas
  syn keyword	cOperator	_Alignof alignof
  syn keyword	cStorageClass	_Atomic
  syn keyword	cOperator	_Generic
  syn keyword	cStorageClass	_Noreturn noreturn
  syn keyword	cOperator	_Static_assert static_assert
  syn keyword	cStorageClass	_Thread_local thread_local
  syn keyword   cType		char16_t char32_t
endif

if !exists("c_no_ansi") || exists("c_ansi_constants") || exists("c_gnu")
  if exists("c_gnu")
    syn keyword cConstant __GNUC__ __FUNCTION__ __PRETTY_FUNCTION__ __func__
  endif
  syn keyword cConstant __LINE__ __FILE__ __DATE__ __TIME__ __STDC__
  syn keyword cConstant __STDC_VERSION__
  syn keyword cConstant CHAR_BIT MB_LEN_MAX MB_CUR_MAX
  syn keyword cConstant UCHAR_MAX UINT_MAX ULONG_MAX USHRT_MAX
  syn keyword cConstant CHAR_MIN INT_MIN LONG_MIN SHRT_MIN
  syn keyword cConstant CHAR_MAX INT_MAX LONG_MAX SHRT_MAX
  syn keyword cConstant SCHAR_MIN SINT_MIN SLONG_MIN SSHRT_MIN
  syn keyword cConstant SCHAR_MAX SINT_MAX SLONG_MAX SSHRT_MAX
  if !exists("c_no_c99")
    syn keyword cConstant __func__
    syn keyword cConstant LLONG_MIN LLONG_MAX ULLONG_MAX
    syn keyword cConstant INT8_MIN INT16_MIN INT32_MIN INT64_MIN
    syn keyword cConstant INT8_MAX INT16_MAX INT32_MAX INT64_MAX
    syn keyword cConstant UINT8_MAX UINT16_MAX UINT32_MAX UINT64_MAX
    syn keyword cConstant INT_LEAST8_MIN INT_LEAST16_MIN INT_LEAST32_MIN INT_LEAST64_MIN
    syn keyword cConstant INT_LEAST8_MAX INT_LEAST16_MAX INT_LEAST32_MAX INT_LEAST64_MAX
    syn keyword cConstant UINT_LEAST8_MAX UINT_LEAST16_MAX UINT_LEAST32_MAX UINT_LEAST64_MAX
    syn keyword cConstant INT_FAST8_MIN INT_FAST16_MIN INT_FAST32_MIN INT_FAST64_MIN
    syn keyword cConstant INT_FAST8_MAX INT_FAST16_MAX INT_FAST32_MAX INT_FAST64_MAX
    syn keyword cConstant UINT_FAST8_MAX UINT_FAST16_MAX UINT_FAST32_MAX UINT_FAST64_MAX
    syn keyword cConstant INTPTR_MIN INTPTR_MAX UINTPTR_MAX
    syn keyword cConstant INTMAX_MIN INTMAX_MAX UINTMAX_MAX
    syn keyword cConstant PTRDIFF_MIN PTRDIFF_MAX SIG_ATOMIC_MIN SIG_ATOMIC_MAX
    syn keyword cConstant SIZE_MAX WCHAR_MIN WCHAR_MAX WINT_MIN WINT_MAX
  endif
  syn keyword cConstant FLT_RADIX FLT_ROUNDS
  syn keyword cConstant FLT_DIG FLT_MANT_DIG FLT_EPSILON
  syn keyword cConstant DBL_DIG DBL_MANT_DIG DBL_EPSILON
  syn keyword cConstant LDBL_DIG LDBL_MANT_DIG LDBL_EPSILON
  syn keyword cConstant FLT_MIN FLT_MAX FLT_MIN_EXP FLT_MAX_EXP
  syn keyword cConstant FLT_MIN_10_EXP FLT_MAX_10_EXP
  syn keyword cConstant DBL_MIN DBL_MAX DBL_MIN_EXP DBL_MAX_EXP
  syn keyword cConstant DBL_MIN_10_EXP DBL_MAX_10_EXP
  syn keyword cConstant LDBL_MIN LDBL_MAX LDBL_MIN_EXP LDBL_MAX_EXP
  syn keyword cConstant LDBL_MIN_10_EXP LDBL_MAX_10_EXP
  syn keyword cConstant HUGE_VAL CLOCKS_PER_SEC NULL
  syn keyword cConstant LC_ALL LC_COLLATE LC_CTYPE LC_MONETARY
  syn keyword cConstant LC_NUMERIC LC_TIME
  syn keyword cConstant SIG_DFL SIG_ERR SIG_IGN
  syn keyword cConstant SIGABRT SIGFPE SIGILL SIGHUP SIGINT SIGSEGV SIGTERM
  " Add POSIX signals as well...
  syn keyword cConstant SIGABRT SIGALRM SIGCHLD SIGCONT SIGFPE SIGHUP
  syn keyword cConstant SIGILL SIGINT SIGKILL SIGPIPE SIGQUIT SIGSEGV
  syn keyword cConstant SIGSTOP SIGTERM SIGTRAP SIGTSTP SIGTTIN SIGTTOU
  syn keyword cConstant SIGUSR1 SIGUSR2
  syn keyword cConstant _IOFBF _IOLBF _IONBF BUFSIZ EOF WEOF
  syn keyword cConstant FOPEN_MAX FILENAME_MAX L_tmpnam
  syn keyword cConstant SEEK_CUR SEEK_END SEEK_SET
  syn keyword cConstant TMP_MAX stderr stdin stdout
  syn keyword cConstant EXIT_FAILURE EXIT_SUCCESS RAND_MAX
  " Add POSIX errors as well
  syn keyword cConstant E2BIG EACCES EAGAIN EBADF EBADMSG EBUSY
  syn keyword cConstant ECANCELED ECHILD EDEADLK EDOM EEXIST EFAULT
  syn keyword cConstant EFBIG EILSEQ EINPROGRESS EINTR EINVAL EIO EISDIR
  syn keyword cConstant EMFILE EMLINK EMSGSIZE ENAMETOOLONG ENFILE ENODEV
  syn keyword cConstant ENOENT ENOEXEC ENOLCK ENOMEM ENOSPC ENOSYS
  syn keyword cConstant ENOTDIR ENOTEMPTY ENOTSUP ENOTTY ENXIO EPERM
  syn keyword cConstant EPIPE ERANGE EROFS ESPIPE ESRCH ETIMEDOUT EXDEV
  " math.h
  syn keyword cConstant M_E M_LOG2E M_LOG10E M_LN2 M_LN10 M_PI M_PI_2 M_PI_4
  syn keyword cConstant M_1_PI M_2_PI M_2_SQRTPI M_SQRT2 M_SQRT1_2
endif
if !exists("c_no_c99") " ISO C99
  syn keyword cConstant true false
endif

" Accept %: for # (C99)
syn region	cPreCondit	start="^\s*\(%:\|#\)\s*\(if\|ifdef\|ifndef\|elif\)\>" skip="\\$" end="$" keepend contains=cComment,cCommentL,cCppString,cCharacter,cCppParen,cParenError,cNumbers,cCommentError,cSpaceError
syn match	cPreConditMatch	display "^\s*\(%:\|#\)\s*\(else\|endif\)\>"
if !exists("c_no_if0")
  syn cluster	cCppOutInGroup	contains=cCppInIf,cCppInElse,cCppInElse2,cCppOutIf,cCppOutIf2,cCppOutElse,cCppInSkip,cCppOutSkip
  syn region	cCppOutWrapper	start="^\s*\(%:\|#\)\s*if\s\+0\+\s*\($\|//\|/\*\|&\)" end=".\@=\|$" contains=cCppOutIf,cCppOutElse fold
  syn region	cCppOutIf	contained start="0\+" matchgroup=cCppOutWrapper end="^\s*\(%:\|#\)\s*endif\>" contains=cCppOutIf2,cCppOutElse
  if !exists("c_no_if0_fold")
    syn region	cCppOutIf2	contained matchgroup=cCppOutWrapper start="0\+" end="^\s*\(%:\|#\)\s*\(else\>\|elif\s\+\(0\+\s*\($\|//\|/\*\|&\)\)\@!\|endif\>\)"me=s-1 contains=cSpaceError,cCppOutSkip fold
  else
    syn region	cCppOutIf2	contained matchgroup=cCppOutWrapper start="0\+" end="^\s*\(%:\|#\)\s*\(else\>\|elif\s\+\(0\+\s*\($\|//\|/\*\|&\)\)\@!\|endif\>\)"me=s-1 contains=cSpaceError,cCppOutSkip
  endif
  syn region	cCppOutElse	contained matchgroup=cCppOutWrapper start="^\s*\(%:\|#\)\s*\(else\|elif\)" end="^\s*\(%:\|#\)\s*endif\>"me=s-1 contains=TOP,cPreCondit
  syn region	cCppInWrapper	start="^\s*\(%:\|#\)\s*if\s\+0*[1-9]\d*\s*\($\|//\|/\*\||\)" end=".\@=\|$" contains=cCppInIf,cCppInElse fold
  syn region	cCppInIf	contained matchgroup=cCppInWrapper start="\d\+" end="^\s*\(%:\|#\)\s*endif\>" contains=TOP,cPreCondit
  if !exists("c_no_if0_fold")
    syn region	cCppInElse	contained start="^\s*\(%:\|#\)\s*\(else\>\|elif\s\+\(0*[1-9]\d*\s*\($\|//\|/\*\||\)\)\@!\)" end=".\@=\|$" containedin=cCppInIf contains=cCppInElse2 fold
  else
    syn region	cCppInElse	contained start="^\s*\(%:\|#\)\s*\(else\>\|elif\s\+\(0*[1-9]\d*\s*\($\|//\|/\*\||\)\)\@!\)" end=".\@=\|$" containedin=cCppInIf contains=cCppInElse2
  endif
  syn region	cCppInElse2	contained matchgroup=cCppInWrapper start="^\s*\(%:\|#\)\s*\(else\|elif\)\([^/]\|/[^/*]\)*" end="^\s*\(%:\|#\)\s*endif\>"me=s-1 contains=cSpaceError,cCppOutSkip
  syn region	cCppOutSkip	contained start="^\s*\(%:\|#\)\s*\(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" contains=cSpaceError,cCppOutSkip
  syn region	cCppInSkip	contained matchgroup=cCppInWrapper start="^\s*\(%:\|#\)\s*\(if\s\+\(\d\+\s*\($\|//\|/\*\||\|&\)\)\@!\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" containedin=cCppOutElse,cCppInIf,cCppInSkip contains=TOP,cPreProc
endif
syn region	cIncluded	display contained start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match	cIncluded	display contained "<[^>]*>"
syn match	cInclude	display "^\s*\(%:\|#\)\s*include\>\s*["<]" contains=cIncluded
"syn match cLineSkip	"\\$"
syn cluster	cPreProcGroup	contains=cPreCondit,cIncluded,cInclude,cDefine,cErrInParen,cErrInBracket,cUserLabel,cSpecial,cOctalZero,cCppOutWrapper,cCppInWrapper,@cCppOutInGroup,cFormat,cNumber,cFloat,cOctal,cOctalError,cNumbersCom,cString,cCommentSkip,cCommentString,cComment2String,@cCommentGroup,cCommentStartError,cParen,cBracket,cMulti,cBadBlock
syn region	cDefine		start="^\s*\(%:\|#\)\s*\(define\|undef\)\>" skip="\\$" end="$" keepend contains=ALLBUT,@cPreProcGroup,@Spell
syn region	cPreProc	start="^\s*\(%:\|#\)\s*\(pragma\>\|line\>\|warning\>\|warn\>\|error\>\)" skip="\\$" end="$" keepend contains=ALLBUT,@cPreProcGroup,@Spell

" Highlight User Labels
syn cluster	cMultiGroup	contains=cIncluded,cSpecial,cCommentSkip,cCommentString,cComment2String,@cCommentGroup,cCommentStartError,cUserCont,cUserLabel,cBitField,cOctalZero,cCppOutWrapper,cCppInWrapper,@cCppOutInGroup,cFormat,cNumber,cFloat,cOctal,cOctalError,cNumbersCom,cCppParen,cCppBracket,cCppString
syn region	cMulti		transparent start='?' skip='::' end=':' contains=ALLBUT,@cMultiGroup,@Spell
" Avoid matching foo::bar() in C++ by requiring that the next char is not ':'
syn cluster	cLabelGroup	contains=cUserLabel
syn match	cUserCont	display "^\s*\I\i*\s*:$" contains=@cLabelGroup
syn match	cUserCont	display ";\s*\I\i*\s*:$" contains=@cLabelGroup
syn match	cUserCont	display "^\s*\I\i*\s*:[^:]"me=e-1 contains=@cLabelGroup
syn match	cUserCont	display ";\s*\I\i*\s*:[^:]"me=e-1 contains=@cLabelGroup

syn match	cUserLabel	display "\I\i*" contained

" Avoid recognizing most bitfields as labels
syn match	cBitField	display "^\s*\I\i*\s*:\s*[1-9]"me=e-1 contains=cType
syn match	cBitField	display ";\s*\I\i*\s*:\s*[1-9]"me=e-1 contains=cType

if exists("c_minlines")
  let b:c_minlines = c_minlines
else
  if !exists("c_no_if0")
    let b:c_minlines = 50	" #if 0 constructs can be long
  else
    let b:c_minlines = 15	" mostly for () constructs
  endif
endif
if exists("c_curly_error")
  syn sync fromstart
else
  exec "syn sync ccomment cComment minlines=" . b:c_minlines
endif

" Define the default highlighting.
" Only used when an item doesn't have highlighting yet
hi def link cFormat		cSpecial
hi def link cCppString		cString
hi def link cCommentL		cComment
hi def link cCommentStart	cComment
hi def link cLabel		Label
hi def link cUserLabel		Label
hi def link cConditional	Conditional
hi def link cRepeat		Repeat
hi def link cCharacter		Character
hi def link cSpecialCharacter	cSpecial
hi def link cNumber		Number
hi def link cOctal		Number
hi def link cOctalZero		PreProc	 " link this to Error if you want
hi def link cFloat		Float
hi def link cOctalError		cError
hi def link cParenError		cError
hi def link cErrInParen		cError
hi def link cErrInBracket	cError
hi def link cCommentError	cError
hi def link cCommentStartError	cError
hi def link cSpaceError		cError
hi def link cSpecialError	cError
hi def link cCurlyError		cError
hi def link cOperator		Operator
hi def link cStructure		Structure
hi def link cStorageClass	StorageClass
hi def link cInclude		Include
hi def link cPreProc		PreProc
hi def link cDefine		Macro
hi def link cIncluded		cString
hi def link cError		Error
hi def link cStatement		Statement
hi def link cCppInWrapper	cCppOutWrapper
hi def link cCppOutWrapper	cPreCondit
hi def link cPreConditMatch	cPreCondit
hi def link cPreCondit		PreCondit
hi def link cType		Type
hi def link cConstant		Constant
hi def link cCommentString	cString
hi def link cComment2String	cString
hi def link cCommentSkip	cComment
hi def link cString		String
hi def link cComment		Comment
hi def link cSpecial		SpecialChar
hi def link cTodo		Todo
hi def link cBadContinuation	Error
hi def link cCppOutSkip		cCppOutIf2
hi def link cCppInElse2		cCppOutIf2
hi def link cCppOutIf2		cCppOut2  " Old syntax group for #if 0 body
hi def link cCppOut2		cCppOut  " Old syntax group for #if of #if 0
hi def link cCppOut		Comment

let b:current_syntax = "c"

let &cpo = s:cpo_save
unlet s:cpo_save
" vim: ts=8
