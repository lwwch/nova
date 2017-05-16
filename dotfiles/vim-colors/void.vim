"
"   Vim "monochrome" adapted to "void"
"   monochrome maintainer: Xavier Noria <fxn@hashref.com> (MIT License)
"
"   void theme released under the MIT License
"   Copyright (c) 2017 Myles Hathcock
"

set background=dark

hi clear
if exists('syntax_on')
   syntax reset
endif

let g:colors_name = 'void'

hi Normal guifg=LightGray ctermfg=255 guibg=Black ctermbg=16 gui=NONE cterm=NONE term=NONE
hi Cursor guifg=Black ctermfg=16 guibg=LightGray ctermbg=255 gui=NONE cterm=NONE term=NONE
hi CursorLine guifg=LightGray ctermfg=255 guibg=#202020 ctermbg=234 gui=NONE cterm=NONE term=NONE
hi CursorLineNr guifg=White ctermfg=15 guibg=Black ctermbg=16 gui=bold cterm=bold term=bold
hi ColorColumn guifg=LightGray ctermfg=255 guibg=#202020 ctermbg=234 gui=NONE cterm=NONE term=NONE
hi FoldColumn guifg=DarkGray ctermfg=248 guibg=Black ctermbg=16 gui=NONE cterm=NONE term=NONE
hi Folded guifg=LightGray ctermfg=255 guibg=Black ctermbg=16 gui=NONE cterm=NONE term=NONE
hi LineNr guifg=DarkGray ctermfg=248 guibg=Black ctermbg=16 gui=NONE cterm=NONE term=NONE
hi Statement guifg=White ctermfg=15 guibg=Black ctermbg=16 gui=bold cterm=bold term=bold
hi PreProc guifg=White ctermfg=15 guibg=Black ctermbg=16 gui=bold cterm=bold term=bold
hi String guifg=#778899 ctermfg=243 guibg=Black ctermbg=16 gui=NONE cterm=NONE term=NONE
hi Comment guifg=#737373 ctermfg=243 guibg=Black ctermbg=16 gui=NONE cterm=NONE term=NONE
hi Constant guifg=LightGray ctermfg=255 guibg=Black ctermbg=16 gui=NONE cterm=NONE term=NONE
hi Type guifg=White ctermfg=15 guibg=Black ctermbg=16 gui=bold cterm=bold term=bold
hi Function guifg=White ctermfg=15 guibg=Black ctermbg=16 gui=NONE cterm=NONE term=NONE
hi Identifier guifg=LightGray ctermfg=255 guibg=Black ctermbg=16 gui=NONE cterm=NONE term=NONE
hi Special guifg=LightGray ctermfg=255 guibg=Black ctermbg=16 gui=NONE cterm=NONE term=NONE
hi MatchParen guifg=Black ctermfg=16 guibg=LightGray ctermbg=255 gui=NONE cterm=NONE term=NONE
hi Search guifg=White ctermfg=15 guibg=#778899 ctermbg=67 gui=NONE cterm=NONE term=NONE
hi Visual guifg=White ctermfg=15 guibg=#778899 ctermbg=67 gui=NONE cterm=NONE term=NONE
hi NonText guifg=DarkGray ctermfg=248 guibg=Black ctermbg=16 gui=NONE cterm=NONE term=NONE
hi Directory guifg=White ctermfg=15 guibg=Black ctermbg=16 gui=bold cterm=bold term=bold
hi Title guifg=White ctermfg=15 guibg=Black ctermbg=16 gui=bold cterm=bold term=bold
hi Todo guifg=Black ctermfg=16 guibg=Yellow ctermbg=226 gui=bold cterm=bold term=bold
hi Pmenu guifg=White ctermfg=15 guibg=#778899 ctermbg=67 gui=NONE cterm=NONE term=NONE
hi PmenuSel guifg=#778899 ctermfg=67 guibg=White ctermbg=15 gui=NONE cterm=NONE term=NONE

hi vimOption guifg=LightGray ctermfg=255 guibg=Black ctermbg=16 gui=NONE cterm=NONE term=NONE
hi vimGroup guifg=LightGray ctermfg=255 guibg=Black ctermbg=16 gui=NONE cterm=NONE term=NONE
hi vimHiClear guifg=LightGray ctermfg=255 guibg=Black ctermbg=16 gui=NONE cterm=NONE term=NONE
hi vimHiGroup guifg=LightGray ctermfg=255 guibg=Black ctermbg=16 gui=NONE cterm=NONE term=NONE
hi vimHiAttrib guifg=LightGray ctermfg=255 guibg=Black ctermbg=16 gui=NONE cterm=NONE term=NONE
hi vimHiGui guifg=LightGray ctermfg=255 guibg=Black ctermbg=16 gui=NONE cterm=NONE term=NONE
hi vimHiGuiFgBg guifg=LightGray ctermfg=255 guibg=Black ctermbg=16 gui=NONE cterm=NONE term=NONE
hi vimHiCTerm guifg=LightGray ctermfg=255 guibg=Black ctermbg=16 gui=NONE cterm=NONE term=NONE
hi vimHiCTermFgBg guifg=LightGray ctermfg=255 guibg=Black ctermbg=16 gui=NONE cterm=NONE term=NONE
hi vimSynType guifg=LightGray ctermfg=255 guibg=Black ctermbg=16 gui=NONE cterm=NONE term=NONE
hi vimCommentTitle guifg=#737373 ctermfg=243 guibg=Black ctermbg=16 gui=NONE cterm=NONE term=NONE
