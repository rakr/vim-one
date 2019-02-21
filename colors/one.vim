" Name:    one vim colorscheme
" Author:  Ramzi Akremi
" License: MIT
" Version: 1.1.1-pre

" Global setup =============================================================={{{

if exists("*<SID>X")
  delf <SID>X
  delf <SID>rgb
  delf <SID>color
  delf <SID>rgb_color
  delf <SID>rgb_level
  delf <SID>rgb_number
  delf <SID>grey_color
  delf <SID>grey_level
  delf <SID>grey_number
endif

hi clear
syntax reset
if exists('g:colors_name')
  unlet g:colors_name
endif
let g:colors_name = 'one'

if !exists('g:one_allow_italics')
  let g:one_allow_italics = 0
endif

let s:italic = ''
if g:one_allow_italics == 1
  let s:italic = 'italic'
endif

if has('gui_running') || has('termguicolors') || &t_Co == 88 || &t_Co == 256
  " functions
  " returns an approximate grey index for the given grey level

  " Utility functions -------------------------------------------------------{{{
  fun <SID>grey_number(x)
    if &t_Co == 88
      if a:x < 23
        return 0
      elseif a:x < 69
        return 1
      elseif a:x < 103
        return 2
      elseif a:x < 127
        return 3
      elseif a:x < 150
        return 4
      elseif a:x < 173
        return 5
      elseif a:x < 196
        return 6
      elseif a:x < 219
        return 7
      elseif a:x < 243
        return 8
      else
        return 9
      endif
    else
      if a:x < 14
        return 0
      else
        let l:n = (a:x - 8) / 10
        let l:m = (a:x - 8) % 10
        if l:m < 5
          return l:n
        else
          return l:n + 1
        endif
      endif
    endif
  endfun

  " returns the actual grey level represented by the grey index
  fun <SID>grey_level(n)
    if &t_Co == 88
      if a:n == 0
        return 0
      elseif a:n == 1
        return 46
      elseif a:n == 2
        return 92
      elseif a:n == 3
        return 115
      elseif a:n == 4
        return 139
      elseif a:n == 5
        return 162
      elseif a:n == 6
        return 185
      elseif a:n == 7
        return 208
      elseif a:n == 8
        return 231
      else
        return 255
      endif
    else
      if a:n == 0
        return 0
      else
        return 8 + (a:n * 10)
      endif
    endif
  endfun

  " returns the palette index for the given grey index
  fun <SID>grey_color(n)
    if &t_Co == 88
      if a:n == 0
        return 16
      elseif a:n == 9
        return 79
      else
        return 79 + a:n
      endif
    else
      if a:n == 0
        return 16
      elseif a:n == 25
        return 231
      else
        return 231 + a:n
      endif
    endif
  endfun

  " returns an approximate color index for the given color level
  fun <SID>rgb_number(x)
    if &t_Co == 88
      if a:x < 69
        return 0
      elseif a:x < 172
        return 1
      elseif a:x < 230
        return 2
      else
        return 3
      endif
    else
      if a:x < 75
        return 0
      else
        let l:n = (a:x - 55) / 40
        let l:m = (a:x - 55) % 40
        if l:m < 20
          return l:n
        else
          return l:n + 1
        endif
      endif
    endif
  endfun

  " returns the actual color level for the given color index
  fun <SID>rgb_level(n)
    if &t_Co == 88
      if a:n == 0
        return 0
      elseif a:n == 1
        return 139
      elseif a:n == 2
        return 205
      else
        return 255
      endif
    else
      if a:n == 0
        return 0
      else
        return 55 + (a:n * 40)
      endif
    endif
  endfun

  " returns the palette index for the given R/G/B color indices
  fun <SID>rgb_color(x, y, z)
    if &t_Co == 88
      return 16 + (a:x * 16) + (a:y * 4) + a:z
    else
      return 16 + (a:x * 36) + (a:y * 6) + a:z
    endif
  endfun

  " returns the palette index to approximate the given R/G/B color levels
  fun <SID>color(r, g, b)
    " get the closest grey
    let l:gx = <SID>grey_number(a:r)
    let l:gy = <SID>grey_number(a:g)
    let l:gz = <SID>grey_number(a:b)

    " get the closest color
    let l:x = <SID>rgb_number(a:r)
    let l:y = <SID>rgb_number(a:g)
    let l:z = <SID>rgb_number(a:b)

    if l:gx == l:gy && l:gy == l:gz
      " there are two possibilities
      let l:dgr = <SID>grey_level(l:gx) - a:r
      let l:dgg = <SID>grey_level(l:gy) - a:g
      let l:dgb = <SID>grey_level(l:gz) - a:b
      let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
      let l:dr = <SID>rgb_level(l:gx) - a:r
      let l:dg = <SID>rgb_level(l:gy) - a:g
      let l:db = <SID>rgb_level(l:gz) - a:b
      let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
      if l:dgrey < l:drgb
        " use the grey
        return <SID>grey_color(l:gx)
      else
        " use the color
        return <SID>rgb_color(l:x, l:y, l:z)
      endif
    else
      " only one possibility
      return <SID>rgb_color(l:x, l:y, l:z)
    endif
  endfun

  " returns the palette index to approximate the 'rrggbb' hex string
  fun <SID>rgb(rgb)
    let l:r = ('0x' . strpart(a:rgb, 0, 2)) + 0
    let l:g = ('0x' . strpart(a:rgb, 2, 2)) + 0
    let l:b = ('0x' . strpart(a:rgb, 4, 2)) + 0

    return <SID>color(l:r, l:g, l:b)
  endfun

  " sets the highlighting for the given group
  fun <sid>X(group, fg, bg, attr)
    let l:attr = a:attr
    if g:one_allow_italics == 0 && l:attr ==? 'italic'
      let l:attr= 'none'
    endif

    let l:bg = ""
    let l:fg = ""
    let l:decoration = ""

    if a:bg != ''
      let l:bg = " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
    endif

    if a:fg != ''
      let l:fg = " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
    endif

    if a:attr != ''
      let l:decoration = " gui=" . l:attr . " cterm=" . l:attr
    endif

    let l:exec = l:fg . l:bg . l:decoration

    if l:exec != ''
      exec "hi " . a:group . l:exec
    endif

  endfun

  " Highlight function
  function! <sid>hi(group, fg, bg, attr, attrsp)
    " fg, bg, attr, attrsp
    if !empty(a:fg)
      exec "hi " . a:group . " guifg=" .  a:fg[0]
      exec "hi " . a:group . " ctermfg=" . a:fg[1]
    endif
    if !empty(a:bg)
      exec "hi " . a:group . " guibg=" .  a:bg[0]
      exec "hi " . a:group . " ctermbg=" . a:bg[1]
    endif
    if a:attr != ""
      exec "hi " . a:group . " gui=" .   a:attr
      exec "hi " . a:group . " cterm=" . a:attr
    endif
    if !empty(a:attrsp)
      exec "hi " . a:group . " guisp=" . a:attrsp[0]
    endif
  endfunction

  " }}}


  " Color definition --------------------------------------------------------{{{
  let s:dark = 0
  if &background ==# 'dark'
    let s:dark = 1
    let s:mono_1 = ['#abb2bf', '145']
    let s:mono_2 = ['#828997', '102']
    let s:mono_3 = ['#5c6370', '59']
    let s:mono_4 = ['#4b5263', '59']

    let s:hue_1  = ['#56b6c2', '73'] " cyan
    let s:hue_2  = ['#61afef', '75'] " blue
    let s:hue_3  = ['#c678dd', '176'] " purple
    let s:hue_4  = ['#98c379', '114'] " green

    let s:hue_5   = ['#e06c75', '168'] " red 1
    let s:hue_5_2 = ['#be5046', '130'] " red 2

    let s:hue_6   = ['#d19a66', '173'] " orange 1
    let s:hue_6_2 = ['#e5c07b', '180'] " orange 2

    let s:syntax_bg     = ['#282c34', '16']
    let s:syntax_gutter = ['#636d83', '60']
    let s:syntax_cursor = ['#2c323c', '16']

    let s:syntax_accent = ['#528bff', '69']

    let s:vertsplit    = ['#181a1f', '233']
    let s:special_grey = ['#3b4048', '16']
    let s:visual_grey  = ['#3e4452', '17']
    let s:pmenu        = ['#333841', '16']
  else
    let s:mono_1 = ['#494b53', '23']
    let s:mono_2 = ['#696c77', '60']
    let s:mono_3 = ['#a0a1a7', '145']
    let s:mono_4 = ['#c2c2c3', '250']

    let s:hue_1  = ['#0184bc', '31'] " cyan
    let s:hue_2  = ['#4078f2', '33'] " blue
    let s:hue_3  = ['#a626a4', '127'] " purple
    let s:hue_4  = ['#50a14f', '71'] " green

    let s:hue_5   = ['#e45649', '166'] " red 1
    let s:hue_5_2 = ['#ca1243', '160'] " red 2

    let s:hue_6   = ['#986801', '94'] " orange 1
    let s:hue_6_2 = ['#c18401', '136'] " orange 2

    let s:syntax_bg     = ['#fafafa', '255']
    let s:syntax_gutter = ['#9e9e9e', '247']
    let s:syntax_cursor = ['#f0f0f0', '254']

    let s:syntax_accent = ['#526fff', '63']
    let s:syntax_accent_2 = ['#0083be', '31']

    let s:vertsplit    = ['#e7e9e1', '188']
    let s:special_grey = ['#d3d3d3', '251']
    let s:visual_grey  = ['#d0d0d0', '251']
    let s:pmenu        = ['#dfdfdf', '253']
  endif

  let s:syntax_fg = s:mono_1
  let s:syntax_fold_bg = s:mono_3

  " }}}

  " Vim editor color --------------------------------------------------------{{{
  call <sid>hi('Normal',       s:syntax_fg,     s:syntax_bg,      '', '')
  call <sid>hi('bold',         '',              '',               'bold', '')
  call <sid>hi('ColorColumn',  '',              s:syntax_cursor,  '', '')
  call <sid>hi('Conceal',      s:mono_4,        s:syntax_bg,      '', '')
  call <sid>hi('Cursor',       '',              s:syntax_accent,  '', '')
  call <sid>hi('CursorIM',     '',              '',               '', '')
  call <sid>hi('CursorColumn', '',              s:syntax_cursor,  '', '')
  call <sid>hi('CursorLine',   '',              s:syntax_cursor,  'none', '')
  call <sid>hi('Directory',    s:hue_2,         '',               '', '')
  call <sid>hi('ErrorMsg',     s:hue_5,         s:syntax_bg,      'none', '')
  call <sid>hi('VertSplit',    s:vertsplit,     '',               'none', '')
  call <sid>hi('Folded',       s:syntax_bg,     s:syntax_fold_bg, 'none', '')
  call <sid>hi('FoldColumn',   s:mono_3,        s:syntax_cursor,  '', '')
  call <sid>hi('IncSearch',    s:hue_6,         '',               '', '')
  call <sid>hi('LineNr',       s:mono_4,        '',               '', '')
  call <sid>hi('CursorLineNr', s:syntax_fg,     s:syntax_cursor,  'none', '')
  call <sid>hi('MatchParen',   s:hue_5,         s:syntax_cursor,  'underline,bold', '')
  call <sid>hi('Italic',       '',              '',               s:italic, '')
  call <sid>hi('ModeMsg',      s:syntax_fg,     '',               '', '')
  call <sid>hi('MoreMsg',      s:syntax_fg,     '',               '', '')
  call <sid>hi('NonText',      s:mono_3,        '',               'none', '')
  call <sid>hi('PMenu',        '',              s:pmenu,          '', '')
  call <sid>hi('PMenuSel',     '',              s:mono_4,         '', '')
  call <sid>hi('PMenuSbar',    '',              s:syntax_bg,      '', '')
  call <sid>hi('PMenuThumb',   '',              s:mono_1,         '', '')
  call <sid>hi('Question',     s:hue_2,         '',               '', '')
  call <sid>hi('Search',       s:syntax_bg,     s:hue_6_2,        '', '')
  call <sid>hi('SpecialKey',   s:special_grey,  '',               'none', '')
  call <sid>hi('Whitespace',   s:special_grey,  '',               'none', '')
  call <sid>hi('StatusLine',   s:syntax_fg,     s:syntax_cursor,  'none', '')
  call <sid>hi('StatusLineNC', s:mono_3,        '',               '', '')
  call <sid>hi('TabLine',      s:mono_1,        s:syntax_bg,      '', '')
  call <sid>hi('TabLineFill',  s:mono_3,        s:visual_grey,    'none', '')
  call <sid>hi('TabLineSel',   s:syntax_bg,     s:hue_2,          '', '')
  call <sid>hi('Title',        s:syntax_fg,     '',               'bold', '')
  call <sid>hi('Visual',       '',              s:visual_grey,    '', '')
  call <sid>hi('VisualNOS',    '',              s:visual_grey,    '', '')
  call <sid>hi('WarningMsg',   s:hue_5,         '',               '', '')
  call <sid>hi('TooLong',      s:hue_5,         '',               '', '')
  call <sid>hi('WildMenu',     s:syntax_fg,     s:mono_3,         '', '')
  call <sid>hi('SignColumn',   '',              s:syntax_bg,      '', '')
  call <sid>hi('Special',      s:hue_2,         '',               '', '')
  " }}}

  " Vim Help highlighting ---------------------------------------------------{{{
  call <sid>hi('helpCommand',      s:hue_6_2, '', '', '')
  call <sid>hi('helpExample',      s:hue_6_2, '', '', '')
  call <sid>hi('helpHeader',       s:mono_1,  '', 'bold', '')
  call <sid>hi('helpSectionDelim', s:mono_3,  '', '', '')
  " }}}

  " Standard syntax highlighting --------------------------------------------{{{
  call <sid>hi('Comment',        s:mono_3,        '',          s:italic, '')
  call <sid>hi('Constant',       s:hue_4,         '',          '', '')
  call <sid>hi('String',         s:hue_4,         '',          '', '')
  call <sid>hi('Character',      s:hue_4,         '',          '', '')
  call <sid>hi('Number',         s:hue_6,         '',          '', '')
  call <sid>hi('Boolean',        s:hue_6,         '',          '', '')
  call <sid>hi('Float',          s:hue_6,         '',          '', '')
  call <sid>hi('Identifier',     s:hue_5,         '',          'none', '')
  call <sid>hi('Function',       s:hue_2,         '',          '', '')
  call <sid>hi('Statement',      s:hue_3,         '',          'none', '')
  call <sid>hi('Conditional',    s:hue_3,         '',          '', '')
  call <sid>hi('Repeat',         s:hue_3,         '',          '', '')
  call <sid>hi('Label',          s:hue_3,         '',          '', '')
  call <sid>hi('Operator',       s:syntax_accent, '',          'none', '')
  call <sid>hi('Keyword',        s:hue_5,         '',          '', '')
  call <sid>hi('Exception',      s:hue_3,         '',          '', '')
  call <sid>hi('PreProc',        s:hue_6_2,       '',          '', '')
  call <sid>hi('Include',        s:hue_2,         '',          '', '')
  call <sid>hi('Define',         s:hue_3,         '',          'none', '')
  call <sid>hi('Macro',          s:hue_3,         '',          '', '')
  call <sid>hi('PreCondit',      s:hue_6_2,       '',          '', '')
  call <sid>hi('Type',           s:hue_6_2,       '',          'none', '')
  call <sid>hi('StorageClass',   s:hue_6_2,       '',          '', '')
  call <sid>hi('Structure',      s:hue_6_2,       '',          '', '')
  call <sid>hi('Typedef',        s:hue_6_2,       '',          '', '')
  call <sid>hi('Special',        s:hue_2,         '',          '', '')
  call <sid>hi('SpecialChar',    '',              '',          '', '')
  call <sid>hi('Tag',            '',              '',          '', '')
  call <sid>hi('Delimiter',      '',              '',          '', '')
  call <sid>hi('SpecialComment', '',              '',          '', '')
  call <sid>hi('Debug',          '',              '',          '', '')
  call <sid>hi('Underlined',     '',              '',          'underline', '')
  call <sid>hi('Ignore',         '',              '',          '', '')
  call <sid>hi('Error',          s:hue_5,         s:syntax_bg, 'bold', '')
  call <sid>hi('Todo',           s:hue_3,         s:syntax_bg, '', '')
  " }}}

  " Diff highlighting -------------------------------------------------------{{{
  call <sid>hi('DiffAdd',     s:hue_4, s:visual_grey, '', '')
  call <sid>hi('DiffChange',  s:hue_6, s:visual_grey, '', '')
  call <sid>hi('DiffDelete',  s:hue_5, s:visual_grey, '', '')
  call <sid>hi('DiffText',    s:hue_2, s:visual_grey, '', '')
  call <sid>hi('DiffAdded',   s:hue_4, s:visual_grey, '', '')
  call <sid>hi('DiffFile',    s:hue_5, s:visual_grey, '', '')
  call <sid>hi('DiffNewFile', s:hue_4, s:visual_grey, '', '')
  call <sid>hi('DiffLine',    s:hue_2, s:visual_grey, '', '')
  call <sid>hi('DiffRemoved', s:hue_5, s:visual_grey, '', '')
  " }}}

  " Asciidoc highlighting ---------------------------------------------------{{{
  call <sid>hi('asciidocListingBlock',   s:mono_2,  '', '', '')
  " }}}

  " C/C++ highlighting ------------------------------------------------------{{{
  call <sid>hi('cInclude',           s:hue_3,  '', '', '')
  call <sid>hi('cPreCondit',         s:hue_3,  '', '', '')
  call <sid>hi('cPreConditMatch',    s:hue_3,  '', '', '')

  call <sid>hi('cType',              s:hue_3,  '', '', '')
  call <sid>hi('cStorageClass',      s:hue_3,  '', '', '')
  call <sid>hi('cStructure',         s:hue_3,  '', '', '')
  call <sid>hi('cOperator',          s:hue_3,  '', '', '')
  call <sid>hi('cStatement',         s:hue_3,  '', '', '')
  call <sid>hi('cTODO',              s:hue_3,  '', '', '')
  call <sid>hi('cConstant',          s:hue_6,  '', '', '')
  call <sid>hi('cSpecial',           s:hue_1,  '', '', '')
  call <sid>hi('cSpecialCharacter',  s:hue_1,  '', '', '')
  call <sid>hi('cString',            s:hue_4,  '', '', '')

  call <sid>hi('cppType',            s:hue_3,  '', '', '')
  call <sid>hi('cppStorageClass',    s:hue_3,  '', '', '')
  call <sid>hi('cppStructure',       s:hue_3,  '', '', '')
  call <sid>hi('cppModifier',        s:hue_3,  '', '', '')
  call <sid>hi('cppOperator',        s:hue_3,  '', '', '')
  call <sid>hi('cppAccess',          s:hue_3,  '', '', '')
  call <sid>hi('cppStatement',       s:hue_3,  '', '', '')
  call <sid>hi('cppConstant',        s:hue_5,  '', '', '')
  call <sid>hi('cCppString',         s:hue_4,  '', '', '')
  " }}}

  " Cucumber highlighting ---------------------------------------------------{{{
  call <sid>hi('cucumberGiven',           s:hue_2,  '', '', '')
  call <sid>hi('cucumberWhen',            s:hue_2,  '', '', '')
  call <sid>hi('cucumberWhenAnd',         s:hue_2,  '', '', '')
  call <sid>hi('cucumberThen',            s:hue_2,  '', '', '')
  call <sid>hi('cucumberThenAnd',         s:hue_2,  '', '', '')
  call <sid>hi('cucumberUnparsed',        s:hue_6,  '', '', '')
  call <sid>hi('cucumberFeature',         s:hue_5,  '', 'bold', '')
  call <sid>hi('cucumberBackground',      s:hue_3,  '', 'bold', '')
  call <sid>hi('cucumberScenario',        s:hue_3,  '', 'bold', '')
  call <sid>hi('cucumberScenarioOutline', s:hue_3,  '', 'bold', '')
  call <sid>hi('cucumberTags',            s:mono_3, '', 'bold', '')
  call <sid>hi('cucumberDelimiter',       s:mono_3, '', 'bold', '')
  " }}}

  " CSS/Sass highlighting ---------------------------------------------------{{{
  call <sid>hi('cssAttrComma',         s:hue_3,  '', '', '')
  call <sid>hi('cssAttributeSelector', s:hue_4,  '', '', '')
  call <sid>hi('cssBraces',            s:mono_2, '', '', '')
  call <sid>hi('cssClassName',         s:hue_6,  '', '', '')
  call <sid>hi('cssClassNameDot',      s:hue_6,  '', '', '')
  call <sid>hi('cssDefinition',        s:hue_3,  '', '', '')
  call <sid>hi('cssFontAttr',          s:hue_6,  '', '', '')
  call <sid>hi('cssFontDescriptor',    s:hue_3,  '', '', '')
  call <sid>hi('cssFunctionName',      s:hue_2,  '', '', '')
  call <sid>hi('cssIdentifier',        s:hue_2,  '', '', '')
  call <sid>hi('cssImportant',         s:hue_3,  '', '', '')
  call <sid>hi('cssInclude',           s:mono_1, '', '', '')
  call <sid>hi('cssIncludeKeyword',    s:hue_3,  '', '', '')
  call <sid>hi('cssMediaType',         s:hue_6,  '', '', '')
  call <sid>hi('cssProp',              s:hue_1,  '', '', '')
  call <sid>hi('cssPseudoClassId',     s:hue_6,  '', '', '')
  call <sid>hi('cssSelectorOp',        s:hue_3,  '', '', '')
  call <sid>hi('cssSelectorOp2',       s:hue_3,  '', '', '')
  call <sid>hi('cssStringQ',           s:hue_4,  '', '', '')
  call <sid>hi('cssStringQQ',          s:hue_4,  '', '', '')
  call <sid>hi('cssTagName',           s:hue_5,  '', '', '')
  call <sid>hi('cssAttr',              s:hue_6,  '', '', '')

  call <sid>hi('sassAmpersand',      s:hue_5,   '', '', '')
  call <sid>hi('sassClass',          s:hue_6_2, '', '', '')
  call <sid>hi('sassControl',        s:hue_3,   '', '', '')
  call <sid>hi('sassExtend',         s:hue_3,   '', '', '')
  call <sid>hi('sassFor',            s:mono_1,  '', '', '')
  call <sid>hi('sassProperty',       s:hue_1,   '', '', '')
  call <sid>hi('sassFunction',       s:hue_1,   '', '', '')
  call <sid>hi('sassId',             s:hue_2,   '', '', '')
  call <sid>hi('sassInclude',        s:hue_3,   '', '', '')
  call <sid>hi('sassMedia',          s:hue_3,   '', '', '')
  call <sid>hi('sassMediaOperators', s:mono_1,  '', '', '')
  call <sid>hi('sassMixin',          s:hue_3,   '', '', '')
  call <sid>hi('sassMixinName',      s:hue_2,   '', '', '')
  call <sid>hi('sassMixing',         s:hue_3,   '', '', '')

  call <sid>hi('scssSelectorName',   s:hue_6_2, '', '', '')
  " }}}

  " Elixir highlighting------------------------------------------------------{{{
  hi link elixirModuleDefine Define
  call <sid>hi('elixirAlias',             s:hue_6_2, '', '', '')
  call <sid>hi('elixirAtom',              s:hue_1,   '', '', '')
  call <sid>hi('elixirBlockDefinition',   s:hue_3,   '', '', '')
  call <sid>hi('elixirModuleDeclaration', s:hue_6,   '', '', '')
  call <sid>hi('elixirInclude',           s:hue_5,   '', '', '')
  call <sid>hi('elixirOperator',          s:hue_6,   '', '', '')
  " }}}

  " Git and git related plugins highlighting --------------------------------{{{
  call <sid>hi('gitcommitComment',       s:mono_3,  '', '', '')
  call <sid>hi('gitcommitUnmerged',      s:hue_4,   '', '', '')
  call <sid>hi('gitcommitOnBranch',      '',        '', '', '')
  call <sid>hi('gitcommitBranch',        s:hue_3,   '', '', '')
  call <sid>hi('gitcommitDiscardedType', s:hue_5,   '', '', '')
  call <sid>hi('gitcommitSelectedType',  s:hue_4,   '', '', '')
  call <sid>hi('gitcommitHeader',        '',        '', '', '')
  call <sid>hi('gitcommitUntrackedFile', s:hue_1,   '', '', '')
  call <sid>hi('gitcommitDiscardedFile', s:hue_5,   '', '', '')
  call <sid>hi('gitcommitSelectedFile',  s:hue_4,   '', '', '')
  call <sid>hi('gitcommitUnmergedFile',  s:hue_6_2, '', '', '')
  call <sid>hi('gitcommitFile',          '',        '', '', '')
  hi link gitcommitNoBranch       gitcommitBranch
  hi link gitcommitUntracked      gitcommitComment
  hi link gitcommitDiscarded      gitcommitComment
  hi link gitcommitSelected       gitcommitComment
  hi link gitcommitDiscardedArrow gitcommitDiscardedFile
  hi link gitcommitSelectedArrow  gitcommitSelectedFile
  hi link gitcommitUnmergedArrow  gitcommitUnmergedFile

  call <sid>hi('SignifySignAdd',    s:hue_4,   '', '', '')
  call <sid>hi('SignifySignChange', s:hue_6_2, '', '', '')
  call <sid>hi('SignifySignDelete', s:hue_5,   '', '', '')
  hi link GitGutterAdd    SignifySignAdd
  hi link GitGutterChange SignifySignChange
  hi link GitGutterDelete SignifySignDelete
  call <sid>hi('diffAdded',         s:hue_4,   '', '', '')
  call <sid>hi('diffRemoved',       s:hue_5,   '', '', '')
  " }}}

  " Go highlighting ---------------------------------------------------------{{{
  call <sid>hi('goDeclaration',         s:hue_3, '', '', '')
  call <sid>hi('goField',               s:hue_5, '', '', '')
  call <sid>hi('goMethod',              s:hue_1, '', '', '')
  call <sid>hi('goType',                s:hue_3, '', '', '')
  call <sid>hi('goUnsignedInts',        s:hue_1, '', '', '')
  " }}}

  " Haskell highlighting ----------------------------------------------------{{{
  call <sid>hi('haskellDeclKeyword',    s:hue_2, '', '', '')
  call <sid>hi('haskellType',           s:hue_4, '', '', '')
  call <sid>hi('haskellWhere',          s:hue_5, '', '', '')
  call <sid>hi('haskellImportKeywords', s:hue_2, '', '', '')
  call <sid>hi('haskellOperators',      s:hue_5, '', '', '')
  call <sid>hi('haskellDelimiter',      s:hue_2, '', '', '')
  call <sid>hi('haskellIdentifier',     s:hue_6, '', '', '')
  call <sid>hi('haskellKeyword',        s:hue_5, '', '', '')
  call <sid>hi('haskellNumber',         s:hue_1, '', '', '')
  call <sid>hi('haskellString',         s:hue_1, '', '', '')
  "}}}

  " HTML highlighting -------------------------------------------------------{{{
  call <sid>hi('htmlArg',            s:hue_6,  '', '', '')
  call <sid>hi('htmlTagName',        s:hue_5,  '', '', '')
  call <sid>hi('htmlTagN',           s:hue_5,  '', '', '')
  call <sid>hi('htmlSpecialTagName', s:hue_5,  '', '', '')
  call <sid>hi('htmlTag',            s:mono_2, '', '', '')
  call <sid>hi('htmlEndTag',         s:mono_2, '', '', '')

  call <sid>hi('MatchTag', s:hue_5, s:syntax_cursor, 'underline,bold', '')
  " }}}

  " JavaScript highlighting -------------------------------------------------{{{
  call <sid>hi('coffeeString',           s:hue_4,   '', '', '')

  call <sid>hi('javaScriptBraces',       s:mono_2,  '', '', '')
  call <sid>hi('javaScriptFunction',     s:hue_3,   '', '', '')
  call <sid>hi('javaScriptIdentifier',   s:hue_3,   '', '', '')
  call <sid>hi('javaScriptNull',         s:hue_6,   '', '', '')
  call <sid>hi('javaScriptNumber',       s:hue_6,   '', '', '')
  call <sid>hi('javaScriptRequire',      s:hue_1,   '', '', '')
  call <sid>hi('javaScriptReserved',     s:hue_3,   '', '', '')
  " https://github.com/pangloss/vim-javascript
  call <sid>hi('jsArrowFunction',        s:hue_3,   '', '', '')
  call <sid>hi('jsBraces',               s:mono_2,  '', '', '')
  call <sid>hi('jsClassBraces',          s:mono_2,  '', '', '')
  call <sid>hi('jsClassKeywords',        s:hue_3,   '', '', '')
  call <sid>hi('jsDocParam',             s:hue_2,   '', '', '')
  call <sid>hi('jsDocTags',              s:hue_3,   '', '', '')
  call <sid>hi('jsFuncBraces',           s:mono_2,  '', '', '')
  call <sid>hi('jsFuncCall',             s:hue_2,   '', '', '')
  call <sid>hi('jsFuncParens',           s:mono_2,  '', '', '')
  call <sid>hi('jsFunction',             s:hue_3,   '', '', '')
  call <sid>hi('jsGlobalObjects',        s:hue_6_2, '', '', '')
  call <sid>hi('jsModuleWords',          s:hue_3,   '', '', '')
  call <sid>hi('jsModules',              s:hue_3,   '', '', '')
  call <sid>hi('jsNoise',                s:mono_2,  '', '', '')
  call <sid>hi('jsNull',                 s:hue_6,   '', '', '')
  call <sid>hi('jsOperator',             s:hue_3,   '', '', '')
  call <sid>hi('jsParens',               s:mono_2,  '', '', '')
  call <sid>hi('jsStorageClass',         s:hue_3,   '', '', '')
  call <sid>hi('jsTemplateBraces',       s:hue_5_2, '', '', '')
  call <sid>hi('jsTemplateVar',          s:hue_4,   '', '', '')
  call <sid>hi('jsThis',                 s:hue_5,   '', '', '')
  call <sid>hi('jsUndefined',            s:hue_6,   '', '', '')
  call <sid>hi('jsObjectValue',          s:hue_2,   '', '', '')
  call <sid>hi('jsObjectKey',            s:hue_1,   '', '', '')
  call <sid>hi('jsReturn',               s:hue_3,   '', '', '')
  " https://github.com/othree/yajs.vim
  call <sid>hi('javascriptArrowFunc',    s:hue_3,   '', '', '')
  call <sid>hi('javascriptClassExtends', s:hue_3,   '', '', '')
  call <sid>hi('javascriptClassKeyword', s:hue_3,   '', '', '')
  call <sid>hi('javascriptDocNotation',  s:hue_3,   '', '', '')
  call <sid>hi('javascriptDocParamName', s:hue_2,   '', '', '')
  call <sid>hi('javascriptDocTags',      s:hue_3,   '', '', '')
  call <sid>hi('javascriptEndColons',    s:mono_3,  '', '', '')
  call <sid>hi('javascriptExport',       s:hue_3,   '', '', '')
  call <sid>hi('javascriptFuncArg',      s:mono_1,  '', '', '')
  call <sid>hi('javascriptFuncKeyword',  s:hue_3,   '', '', '')
  call <sid>hi('javascriptIdentifier',   s:hue_5,   '', '', '')
  call <sid>hi('javascriptImport',       s:hue_3,   '', '', '')
  call <sid>hi('javascriptObjectLabel',  s:mono_1,  '', '', '')
  call <sid>hi('javascriptOpSymbol',     s:hue_1,   '', '', '')
  call <sid>hi('javascriptOpSymbols',    s:hue_1,   '', '', '')
  call <sid>hi('javascriptPropertyName', s:hue_4,   '', '', '')
  call <sid>hi('javascriptTemplateSB',   s:hue_5_2, '', '', '')
  call <sid>hi('javascriptVariable',     s:hue_3,   '', '', '')
  " }}}

  " JSON highlighting -------------------------------------------------------{{{
  call <sid>hi('jsonCommentError',         s:mono_1,  '', ''        , '')
  call <sid>hi('jsonKeyword',              s:hue_5,   '', ''        , '')
  call <sid>hi('jsonQuote',                s:mono_3,  '', ''        , '')
  call <sid>hi('jsonTrailingCommaError',   s:hue_5,   '', 'reverse' , '')
  call <sid>hi('jsonMissingCommaError',    s:hue_5,   '', 'reverse' , '')
  call <sid>hi('jsonNoQuotesError',        s:hue_5,   '', 'reverse' , '')
  call <sid>hi('jsonNumError',             s:hue_5,   '', 'reverse' , '')
  call <sid>hi('jsonString',               s:hue_4,   '', ''        , '')
  call <sid>hi('jsonBoolean',              s:hue_3,   '', ''        , '')
  call <sid>hi('jsonNumber',               s:hue_6,   '', ''        , '')
  call <sid>hi('jsonStringSQError',        s:hue_5,   '', 'reverse' , '')
  call <sid>hi('jsonSemicolonError',       s:hue_5,   '', 'reverse' , '')
  " }}}

  " Markdown highlighting ---------------------------------------------------{{{
  call <sid>hi('markdownUrl',              s:mono_3,  '', '', '')
  call <sid>hi('markdownBold',             s:hue_6,   '', 'bold', '')
  call <sid>hi('markdownItalic',           s:hue_6,   '', 'bold', '')
  call <sid>hi('markdownCode',             s:hue_4,   '', '', '')
  call <sid>hi('markdownCodeBlock',        s:hue_5,   '', '', '')
  call <sid>hi('markdownCodeDelimiter',    s:hue_4,   '', '', '')
  call <sid>hi('markdownHeadingDelimiter', s:hue_5_2, '', '', '')
  call <sid>hi('markdownH1',               s:hue_5,   '', '', '')
  call <sid>hi('markdownH2',               s:hue_5,   '', '', '')
  call <sid>hi('markdownH3',               s:hue_5,   '', '', '')
  call <sid>hi('markdownH3',               s:hue_5,   '', '', '')
  call <sid>hi('markdownH4',               s:hue_5,   '', '', '')
  call <sid>hi('markdownH5',               s:hue_5,   '', '', '')
  call <sid>hi('markdownH6',               s:hue_5,   '', '', '')
  call <sid>hi('markdownListMarker',       s:hue_5,   '', '', '')
  " }}}

  " PHP highlighting --------------------------------------------------------{{{
  call <sid>hi('phpClass',        s:hue_6_2, '', '', '')
  call <sid>hi('phpFunction',     s:hue_2,   '', '', '')
  call <sid>hi('phpFunctions',    s:hue_2,   '', '', '')
  call <sid>hi('phpInclude',      s:hue_3,   '', '', '')
  call <sid>hi('phpKeyword',      s:hue_3,   '', '', '')
  call <sid>hi('phpParent',       s:mono_3,  '', '', '')
  call <sid>hi('phpType',         s:hue_3,   '', '', '')
  call <sid>hi('phpSuperGlobals', s:hue_5,   '', '', '')
  " }}}

  " Pug (Formerly Jade) highlighting ----------------------------------------{{{
  call <sid>hi('pugAttributesDelimiter',   s:hue_6,    '', '', '')
  call <sid>hi('pugClass',                 s:hue_6,    '', '', '')
  call <sid>hi('pugDocType',               s:mono_3,   '', s:italic, '')
  call <sid>hi('pugTag',                   s:hue_5,    '', '', '')
  " }}}

  " PureScript highlighting -------------------------------------------------{{{
  call <sid>hi('purescriptKeyword',          s:hue_3,     '', '', '')
  call <sid>hi('purescriptModuleName',       s:syntax_fg, '', '', '')
  call <sid>hi('purescriptIdentifier',       s:syntax_fg, '', '', '')
  call <sid>hi('purescriptType',             s:hue_6_2,   '', '', '')
  call <sid>hi('purescriptTypeVar',          s:hue_5,     '', '', '')
  call <sid>hi('purescriptConstructor',      s:hue_5,     '', '', '')
  call <sid>hi('purescriptOperator',         s:syntax_fg, '', '', '')
  " }}}

  " Python highlighting -----------------------------------------------------{{{
  call <sid>hi('pythonImport',               s:hue_3,     '', '', '')
  call <sid>hi('pythonBuiltin',              s:hue_1,     '', '', '')
  call <sid>hi('pythonStatement',            s:hue_3,     '', '', '')
  call <sid>hi('pythonParam',                s:hue_6,     '', '', '')
  call <sid>hi('pythonEscape',               s:hue_5,     '', '', '')
  call <sid>hi('pythonSelf',                 s:mono_2,    '', s:italic, '')
  call <sid>hi('pythonClass',                s:hue_2,     '', '', '')
  call <sid>hi('pythonOperator',             s:hue_3,     '', '', '')
  call <sid>hi('pythonEscape',               s:hue_5,     '', '', '')
  call <sid>hi('pythonFunction',             s:hue_2,     '', '', '')
  call <sid>hi('pythonKeyword',              s:hue_2,     '', '', '')
  call <sid>hi('pythonModule',               s:hue_3,     '', '', '')
  call <sid>hi('pythonStringDelimiter',      s:hue_4,     '', '', '')
  call <sid>hi('pythonSymbol',               s:hue_1,     '', '', '')
  " }}}

  " Ruby highlighting -------------------------------------------------------{{{
  call <sid>hi('rubyBlock',                     s:hue_3,   '', '', '')
  call <sid>hi('rubyBlockParameter',            s:hue_5,   '', '', '')
  call <sid>hi('rubyBlockParameterList',        s:hue_5,   '', '', '')
  call <sid>hi('rubyCapitalizedMethod',         s:hue_3,   '', '', '')
  call <sid>hi('rubyClass',                     s:hue_3,   '', '', '')
  call <sid>hi('rubyConstant',                  s:hue_6_2, '', '', '')
  call <sid>hi('rubyControl',                   s:hue_3,   '', '', '')
  call <sid>hi('rubyDefine',                    s:hue_3,   '', '', '')
  call <sid>hi('rubyEscape',                    s:hue_5,   '', '', '')
  call <sid>hi('rubyFunction',                  s:hue_2,   '', '', '')
  call <sid>hi('rubyGlobalVariable',            s:hue_5,   '', '', '')
  call <sid>hi('rubyInclude',                   s:hue_2,   '', '', '')
  call <sid>hi('rubyIncluderubyGlobalVariable', s:hue_5,   '', '', '')
  call <sid>hi('rubyInstanceVariable',          s:hue_5,   '', '', '')
  call <sid>hi('rubyInterpolation',             s:hue_1,   '', '', '')
  call <sid>hi('rubyInterpolationDelimiter',    s:hue_5,   '', '', '')
  call <sid>hi('rubyKeyword',                   s:hue_2,   '', '', '')
  call <sid>hi('rubyModule',                    s:hue_3,   '', '', '')
  call <sid>hi('rubyPseudoVariable',            s:hue_5,   '', '', '')
  call <sid>hi('rubyRegexp',                    s:hue_1,   '', '', '')
  call <sid>hi('rubyRegexpDelimiter',           s:hue_1,   '', '', '')
  call <sid>hi('rubyStringDelimiter',           s:hue_4,   '', '', '')
  call <sid>hi('rubySymbol',                    s:hue_1,   '', '', '')
  " }}}

  " Spelling highlighting ---------------------------------------------------{{{
  call <sid>hi('SpellBad',     '', s:syntax_bg, 'undercurl', '')
  call <sid>hi('SpellLocal',   '', s:syntax_bg, 'undercurl', '')
  call <sid>hi('SpellCap',     '', s:syntax_bg, 'undercurl', '')
  call <sid>hi('SpellRare',    '', s:syntax_bg, 'undercurl', '')
  " }}}

  " Vim highlighting --------------------------------------------------------{{{
  call <sid>hi('vimCommand',      s:hue_3,  '', '', '')
  call <sid>hi('vimCommentTitle', s:mono_3, '', 'bold', '')
  call <sid>hi('vimFunction',     s:hue_1,  '', '', '')
  call <sid>hi('vimFuncName',     s:hue_3,  '', '', '')
  call <sid>hi('vimHighlight',    s:hue_2,  '', '', '')
  call <sid>hi('vimLineComment',  s:mono_3, '', s:italic, '')
  call <sid>hi('vimParenSep',     s:mono_2, '', '', '')
  call <sid>hi('vimSep',          s:mono_2, '', '', '')
  call <sid>hi('vimUserFunc',     s:hue_1,  '', '', '')
  call <sid>hi('vimVar',          s:hue_5,  '', '', '')
  " }}}

  " XML highlighting --------------------------------------------------------{{{
  call <sid>hi('xmlAttrib',  s:hue_6_2, '', '', '')
  call <sid>hi('xmlEndTag',  s:hue_5,   '', '', '')
  call <sid>hi('xmlTag',     s:hue_5,   '', '', '')
  call <sid>hi('xmlTagName', s:hue_5,   '', '', '')
  " }}}

  " ZSH highlighting --------------------------------------------------------{{{
  call <sid>hi('zshCommands',     s:syntax_fg, '', '', '')
  call <sid>hi('zshDeref',        s:hue_5,     '', '', '')
  call <sid>hi('zshShortDeref',   s:hue_5,     '', '', '')
  call <sid>hi('zshFunction',     s:hue_1,     '', '', '')
  call <sid>hi('zshKeyword',      s:hue_3,     '', '', '')
  call <sid>hi('zshSubst',        s:hue_5,     '', '', '')
  call <sid>hi('zshSubstDelim',   s:mono_3,    '', '', '')
  call <sid>hi('zshTypes',        s:hue_3,     '', '', '')
  call <sid>hi('zshVariableDef',  s:hue_6,     '', '', '')
  " }}}

  " Rust highlighting -------------------------------------------------------{{{
  call <sid>hi('rustExternCrate',          s:hue_5,    '', 'bold', '')
  call <sid>hi('rustIdentifier',           s:hue_2,    '', '', '')
  call <sid>hi('rustDeriveTrait',          s:hue_4,    '', '', '')
  call <sid>hi('SpecialComment',           s:mono_3,    '', '', '')
  call <sid>hi('rustCommentLine',          s:mono_3,    '', '', '')
  call <sid>hi('rustCommentLineDoc',       s:mono_3,    '', '', '')
  call <sid>hi('rustCommentLineDocError',  s:mono_3,    '', '', '')
  call <sid>hi('rustCommentBlock',         s:mono_3,    '', '', '')
  call <sid>hi('rustCommentBlockDoc',      s:mono_3,    '', '', '')
  call <sid>hi('rustCommentBlockDocError', s:mono_3,    '', '', '')
  " }}}

  " man highlighting --------------------------------------------------------{{{
  hi link manTitle String
  call <sid>hi('manFooter', s:mono_3, '', '', '')
  " }}}

  " ALE (Asynchronous Lint Engine) highlighting -----------------------------{{{
  call <sid>hi('ALEWarningSign', s:hue_6_2, '', '', '')
  call <sid>hi('ALEErrorSign', s:hue_5,   '', '', '')

  " Neovim Terminal Colors --------------------------------------------------{{{
  if has('nvim')
    let g:terminal_color_0  = "#353a44"
    let g:terminal_color_8  = "#353a44"
    let g:terminal_color_1  = "#e88388"
    let g:terminal_color_9  = "#e88388"
    let g:terminal_color_2  = "#a7cc8c"
    let g:terminal_color_10 = "#a7cc8c"
    let g:terminal_color_3  = "#ebca8d"
    let g:terminal_color_11 = "#ebca8d"
    let g:terminal_color_4  = "#72bef2"
    let g:terminal_color_12 = "#72bef2"
    let g:terminal_color_5  = "#d291e4"
    let g:terminal_color_13 = "#d291e4"
    let g:terminal_color_6  = "#65c2cd"
    let g:terminal_color_14 = "#65c2cd"
    let g:terminal_color_7  = "#e3e5e9"
    let g:terminal_color_15 = "#e3e5e9"
  endif

  " Delete functions =========================================================={{{
  " delf <SID>X
  " delf <SID>rgb
  " delf <SID>color
  " delf <SID>rgb_color
  " delf <SID>rgb_level
  " delf <SID>rgb_number
  " delf <SID>grey_color
  " delf <SID>grey_level
  " delf <SID>grey_number
  " }}}

endif
"}}}

" Public API --------------------------------------------------------------{{{
function! one#highlight(group, fg, bg, attr)
  call <sid>X(a:group, a:fg, a:bg, a:attr)
endfunction
"}}}

if exists('s:dark') && s:dark
  set background=dark
endif

" vim: set fdl=0 fdm=marker:
