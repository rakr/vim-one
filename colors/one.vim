" Name:    one vim colorscheme
" Author:  Ramzi Akremi
" License: MIT
" Version: 1.1.1-pre

" Global setup =============================================================={{{

if exists("*<SID>X")
  delf <SID>X
  delf <SID>XAPI
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
  fun <SID>XAPI(group, fg, bg, attr)
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
  " the original one is borrowed from mhartington/oceanic-next
  function! <SID>X(group, fg, bg, attr, ...)
    let l:attrsp = get(a:, 1, "")
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
    if !empty(l:attrsp)
      exec "hi " . a:group . " guisp=" . l:attrsp[0]
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

  " Pre-define some hi groups -----------------------------------------------{{{
  call <sid>X('OneMono1', s:mono_1, '', '')
  call <sid>X('OneMono2', s:mono_2, '', '')
  call <sid>X('OneMono3', s:mono_3, '', '')
  call <sid>X('OneMono4', s:mono_4, '', '')

  call <sid>X('OneHue1', s:hue_1, '', '')
  call <sid>X('OneHue2', s:hue_2, '', '')
  call <sid>X('OneHue3', s:hue_3, '', '')
  call <sid>X('OneHue4', s:hue_4, '', '')
  call <sid>X('OneHue5', s:hue_5, '', '')
  call <sid>X('OneHue52', s:hue_5_2, '', '')
  call <sid>X('OneHue6', s:hue_6, '', '')
  call <sid>X('OneHue62', s:hue_6_2, '', '')

  hi! link OneSyntaxFg OneMono1
  " }}}

  " Vim editor color --------------------------------------------------------{{{
  call <sid>X('Normal',       s:syntax_fg,     s:syntax_bg,      '')
  call <sid>X('bold',         '',              '',               'bold')
  call <sid>X('ColorColumn',  '',              s:syntax_cursor,  '')
  call <sid>X('Conceal',      s:mono_4,        s:syntax_bg,      '')
  call <sid>X('Cursor',       '',              s:syntax_accent,  '')
  call <sid>X('CursorIM',     '',              '',               '')
  call <sid>X('CursorColumn', '',              s:syntax_cursor,  '')
  call <sid>X('CursorLine',   '',              s:syntax_cursor,  'none')
  hi! link Directory OneHue2
  call <sid>X('ErrorMsg',     s:hue_5,         s:syntax_bg,      'none')
  call <sid>X('VertSplit',    s:vertsplit,     '',               'none')
  call <sid>X('Folded',       s:syntax_bg,     s:syntax_fold_bg, 'none')
  call <sid>X('FoldColumn',   s:mono_3,        s:syntax_cursor,  '')
  hi! link IncSearch OneHue6
  hi! link LineNr OneMono4
  call <sid>X('CursorLineNr', s:syntax_fg,     s:syntax_cursor,  'none')
  call <sid>X('MatchParen',   s:hue_5,         s:syntax_cursor,  'underline,bold')
  call <sid>X('Italic',       '',              '',               s:italic)
  hi! link ModeMsg OneSyntaxFg
  hi! link MoreMsg OneSyntaxFg
  call <sid>X('NonText',      s:mono_3,        '',               'none')
  call <sid>X('PMenu',        '',              s:pmenu,          '')
  call <sid>X('PMenuSel',     '',              s:mono_4,         '')
  call <sid>X('PMenuSbar',    '',              s:syntax_bg,      '')
  call <sid>X('PMenuThumb',   '',              s:mono_1,         '')
  hi! link Question OneHue2
  call <sid>X('Search',       s:syntax_bg,     s:hue_6_2,        '')
  call <sid>X('SpecialKey',   s:special_grey,  '',               'none')
  call <sid>X('Whitespace',   s:special_grey,  '',               'none')
  call <sid>X('StatusLine',   s:syntax_fg,     s:syntax_cursor,  'none')
  hi! link StatusLineNC OneMono3
  call <sid>X('TabLine',      s:mono_1,        s:syntax_bg,      '')
  call <sid>X('TabLineFill',  s:mono_3,        s:visual_grey,    'none')
  call <sid>X('TabLineSel',   s:syntax_bg,     s:hue_2,          '')
  call <sid>X('Title',        s:syntax_fg,     '',               'bold')
  call <sid>X('Visual',       '',              s:visual_grey,    '')
  call <sid>X('VisualNOS',    '',              s:visual_grey,    '')
  hi! link WarningMsg OneHue5
  hi! link TooLong OneHue5
  call <sid>X('WildMenu',     s:syntax_fg,     s:mono_3,         '')
  call <sid>X('SignColumn',   '',              s:syntax_bg,      '')
  hi! link Special OneHue2
  " }}}

  " Vim Help highlighting ---------------------------------------------------{{{
  hi! link helpCommand OneHue62
  hi! link helpExample OneHue62
  call <sid>X('helpHeader',       s:mono_1,  '', 'bold')
  hi! link helpSectionDelim OneMono3
  " }}}

  " Standard syntax highlighting --------------------------------------------{{{
  call <sid>X('Comment',        s:mono_3,        '',          s:italic)
  hi! link Constant OneHue4
  hi! link String OneHue4
  hi! link Character OneHue4
  hi! link Number OneHue6
  hi! link Boolean OneHue6
  hi! link Float OneHue6
  call <sid>X('Identifier',     s:hue_5,         '',          'none')
  hi! link Function OneHue2
  hi! link Statement OneHue3
  hi! link Conditional OneHue3
  hi! link Repeat OneHue3
  hi! link Label OneHue3
  call <sid>X('Operator',       s:syntax_accent, '',          'none')
  hi! link Keyword OneHue5
  hi! link Exception OneHue3
  hi! link PreProc OneHue62
  hi! link Include OneHue2
  hi! link Define OneHue3
  hi! link Macro OneHue3
  hi! link PreCondit OneHue62
  hi! link Type OneHue62
  hi! link StorageClass OneHue62
  hi! link Structure OneHue62
  hi! link Typedef OneHue62
  hi! link Special OneHue2
  call <sid>X('SpecialChar',    '',              '',          '')
  call <sid>X('Tag',            '',              '',          '')
  call <sid>X('Delimiter',      '',              '',          '')
  call <sid>X('SpecialComment', '',              '',          '')
  call <sid>X('Debug',          '',              '',          '')
  call <sid>X('Underlined',     '',              '',          'underline')
  call <sid>X('Ignore',         '',              '',          '')
  call <sid>X('Error',          s:hue_5,         s:syntax_bg, 'bold')
  hi! link Todo OneHue3
  " }}}

  " Diff highlighting -------------------------------------------------------{{{
  call <sid>X('DiffAdd',     s:hue_4, s:visual_grey, '')
  call <sid>X('DiffChange',  s:hue_6, s:visual_grey, '')
  call <sid>X('DiffDelete',  s:hue_5, s:visual_grey, '')
  hi! link DiffText OneHue2
  call <sid>X('DiffAdded',   s:hue_4, s:visual_grey, '')
  call <sid>X('DiffFile',    s:hue_5, s:visual_grey, '')
  call <sid>X('DiffNewFile', s:hue_4, s:visual_grey, '')
  hi! link DiffLine OneHue2
  call <sid>X('DiffRemoved', s:hue_5, s:visual_grey, '')
  " }}}

  " Asciidoc highlighting ---------------------------------------------------{{{
  hi! link asciidocListingBlock OneMono2
  " }}}

  " C/C++ highlighting ------------------------------------------------------{{{
  hi! link cInclude OneHue3
  hi! link cPreCondit OneHue3
  hi! link cPreConditMatch OneHue3

  hi! link cType OneHue3
  hi! link cStorageClass OneHue3
  hi! link cStructure OneHue3
  hi! link cOperator OneHue3
  hi! link cStatement OneHue3
  hi! link cTODO OneHue3
  hi! link cConstant OneHue6
  hi! link cSpecial OneHue1
  hi! link cSpecialCharacter OneHue1
  hi! link cString OneHue4

  hi! link cppType OneHue3
  hi! link cppStorageClass OneHue3
  hi! link cppStructure OneHue3
  hi! link cppModifier OneHue3
  hi! link cppOperator OneHue3
  hi! link cppAccess OneHue3
  hi! link cppStatement OneHue3
  hi! link cppConstant OneHue5
  hi! link cCppString OneHue4
  " }}}

  " Cucumber highlighting ---------------------------------------------------{{{
  hi! link cucumberGiven OneHue2
  hi! link cucumberWhen OneHue2
  hi! link cucumberWhenAnd OneHue2
  hi! link cucumberThen OneHue2
  hi! link cucumberThenAnd OneHue2
  hi! link cucumberUnparsed OneHue6
  call <sid>X('cucumberFeature',         s:hue_5,  '', 'bold')
  hi! link cucumberBackground OneHue3
  hi! link cucumberScenario OneHue3
  hi! link cucumberScenarioOutline OneHue3
  call <sid>X('cucumberTags',            s:mono_3, '', 'bold')
  call <sid>X('cucumberDelimiter',       s:mono_3, '', 'bold')
  " }}}

  " CSS/Sass highlighting ---------------------------------------------------{{{
  hi! link cssAttrComma OneHue3
  hi! link cssAttributeSelector OneHue4
  hi! link cssBraces OneMono2
  hi! link cssClassName OneHue6
  hi! link cssClassNameDot OneHue6
  hi! link cssDefinition OneHue3
  hi! link cssFontAttr OneHue6
  hi! link cssFontDescriptor OneHue3
  hi! link cssFunctionName OneHue2
  hi! link cssIdentifier OneHue2
  hi! link cssImportant OneHue3
  hi! link cssInclude OneMono1
  hi! link cssIncludeKeyword OneHue3
  hi! link cssMediaType OneHue6
  hi! link cssProp OneHue1
  hi! link cssPseudoClassId OneHue6
  hi! link cssSelectorOp OneHue3
  hi! link cssSelectorOp2 OneHue3
  hi! link cssStringQ OneHue4
  hi! link cssStringQQ OneHue4
  hi! link cssTagName OneHue5
  hi! link cssAttr OneHue6

  hi! link sassAmpersand OneHue5
  hi! link sassClass OneHue62
  hi! link sassControl OneHue3
  hi! link sassExtend OneHue3
  hi! link sassFor OneMono1
  hi! link sassProperty OneHue1
  hi! link sassFunction OneHue1
  hi! link sassId OneHue2
  hi! link sassInclude OneHue3
  hi! link sassMedia OneHue3
  hi! link sassMediaOperators OneMono1
  hi! link sassMixin OneHue3
  hi! link sassMixinName OneHue2
  hi! link sassMixing OneHue3

  hi! link scssSelectorName OneHue62
  " }}}

  " Elixir highlighting------------------------------------------------------{{{
  hi! link elixirModuleDefine Define
  hi! link elixirAlias OneHue62
  hi! link elixirAtom OneHue1
  hi! link elixirBlockDefinition OneHue3
  hi! link elixirModuleDeclaration OneHue6
  hi! link elixirInclude OneHue5
  hi! link elixirOperator OneHue6
  " }}}

  " Git and git related plugins highlighting --------------------------------{{{
  hi! link gitcommitComment OneMono3
  hi! link gitcommitUnmerged OneHue4
  call <sid>X('gitcommitOnBranch',      '',        '', '')
  hi! link gitcommitBranch OneHue3
  hi! link gitcommitDiscardedType OneHue5
  hi! link gitcommitSelectedType OneHue4
  call <sid>X('gitcommitHeader',        '',        '', '')
  hi! link gitcommitUntrackedFile OneHue1
  hi! link gitcommitDiscardedFile OneHue5
  hi! link gitcommitSelectedFile OneHue4
  hi! link gitcommitUnmergedFile OneHue62
  call <sid>X('gitcommitFile',          '',        '', '')
  hi! link gitcommitNoBranch       gitcommitBranch
  hi! link gitcommitUntracked      gitcommitComment
  hi! link gitcommitDiscarded      gitcommitComment
  hi! link gitcommitSelected       gitcommitComment
  hi! link gitcommitDiscardedArrow gitcommitDiscardedFile
  hi! link gitcommitSelectedArrow  gitcommitSelectedFile
  hi! link gitcommitUnmergedArrow  gitcommitUnmergedFile

  hi! link SignifySignAdd OneHue4
  hi! link SignifySignChange OneHue62
  hi! link SignifySignDelete OneHue5
  hi! link GitGutterAdd    SignifySignAdd
  hi! link GitGutterChange SignifySignChange
  hi! link GitGutterDelete SignifySignDelete
  hi! link diffAdded OneHue4
  hi! link diffRemoved OneHue5
  " }}}

  " Go highlighting ---------------------------------------------------------{{{
  hi! link goDeclaration OneHue3
  hi! link goField OneHue5
  hi! link goMethod OneHue1
  hi! link goType OneHue3
  hi! link goUnsignedInts OneHue1
  " }}}

  " Haskell highlighting ----------------------------------------------------{{{
  hi! link haskellDeclKeyword OneHue2
  hi! link haskellType OneHue4
  hi! link haskellWhere OneHue5
  hi! link haskellImportKeywords OneHue2
  hi! link haskellOperators OneHue5
  hi! link haskellDelimiter OneHue2
  hi! link haskellIdentifier OneHue6
  hi! link haskellKeyword OneHue5
  hi! link haskellNumber OneHue1
  hi! link haskellString OneHue1
  "}}}

  " HTML highlighting -------------------------------------------------------{{{
  hi! link htmlArg OneHue6
  hi! link htmlTagName OneHue5
  hi! link htmlTagN OneHue5
  hi! link htmlSpecialTagName OneHue5
  hi! link htmlTag OneMono2
  hi! link htmlEndTag OneMono2

  call <sid>X('MatchTag', s:hue_5, s:syntax_cursor, 'underline,bold')
  " }}}

  " JavaScript highlighting -------------------------------------------------{{{
  hi! link coffeeString OneHue4

  hi! link javaScriptBraces OneMono2
  hi! link javaScriptFunction OneHue3
  hi! link javaScriptIdentifier OneHue3
  hi! link javaScriptNull OneHue6
  hi! link javaScriptNumber OneHue6
  hi! link javaScriptRequire OneHue1
  hi! link javaScriptReserved OneHue3
  " https://github.com/pangloss/vim-javascript
  hi! link jsArrowFunction OneHue3
  hi! link jsBraces OneMono2
  hi! link jsClassBraces OneMono2
  hi! link jsClassKeywords OneHue3
  hi! link jsDocParam OneHue2
  hi! link jsDocTags OneHue3
  hi! link jsFuncBraces OneMono2
  hi! link jsFuncCall OneHue2
  hi! link jsFuncParens OneMono2
  hi! link jsFunction OneHue3
  hi! link jsGlobalObjects OneHue62
  hi! link jsModuleWords OneHue3
  hi! link jsModules OneHue3
  hi! link jsNoise OneMono2
  hi! link jsNull OneHue6
  hi! link jsOperator OneHue3
  hi! link jsParens OneMono2
  hi! link jsStorageClass OneHue3
  hi! link jsTemplateBraces OneHue52
  hi! link jsTemplateVar OneHue4
  hi! link jsThis OneHue5
  hi! link jsUndefined OneHue6
  hi! link jsObjectValue OneHue2
  hi! link jsObjectKey OneHue1
  hi! link jsReturn OneHue3
  " https://github.com/othree/yajs.vim
  hi! link javascriptArrowFunc OneHue3
  hi! link javascriptClassExtends OneHue3
  hi! link javascriptClassKeyword OneHue3
  hi! link javascriptDocNotation OneHue3
  hi! link javascriptDocParamName OneHue2
  hi! link javascriptDocTags OneHue3
  hi! link javascriptEndColons OneMono3
  hi! link javascriptExport OneHue3
  hi! link javascriptFuncArg OneMono1
  hi! link javascriptFuncKeyword OneHue3
  hi! link javascriptIdentifier OneHue5
  hi! link javascriptImport OneHue3
  hi! link javascriptObjectLabel OneMono1
  hi! link javascriptOpSymbol OneHue1
  hi! link javascriptOpSymbols OneHue1
  hi! link javascriptPropertyName OneHue4
  hi! link javascriptTemplateSB OneHue52
  hi! link javascriptVariable OneHue3
  " }}}

  " JSON highlighting -------------------------------------------------------{{{
  hi! link jsonCommentError OneMono1
  hi! link jsonKeyword OneHue5
  hi! link jsonQuote OneMono3
  call <sid>X('jsonTrailingCommaError',   s:hue_5,   '', 'reverse' )
  call <sid>X('jsonMissingCommaError',    s:hue_5,   '', 'reverse' )
  call <sid>X('jsonNoQuotesError',        s:hue_5,   '', 'reverse' )
  call <sid>X('jsonNumError',             s:hue_5,   '', 'reverse' )
  hi! link jsonString OneHue4
  hi! link jsonBoolean OneHue3
  hi! link jsonNumber OneHue6
  call <sid>X('jsonStringSQError',        s:hue_5,   '', 'reverse' )
  call <sid>X('jsonSemicolonError',       s:hue_5,   '', 'reverse' )
  " }}}

  " Markdown highlighting ---------------------------------------------------{{{
  hi! link markdownUrl OneMono3
  call <sid>X('markdownBold',             s:hue_6,   '', 'bold')
  call <sid>X('markdownItalic',           s:hue_6,   '', 'bold')
  hi! link markdownCode OneHue4
  hi! link markdownCodeBlock OneHue5
  hi! link markdownCodeDelimiter OneHue4
  hi! link markdownHeadingDelimiter OneHue52
  hi! link markdownH1 OneHue5
  hi! link markdownH2 OneHue5
  hi! link markdownH3 OneHue5
  hi! link markdownH3 OneHue5
  hi! link markdownH4 OneHue5
  hi! link markdownH5 OneHue5
  hi! link markdownH6 OneHue5
  hi! link markdownListMarker OneHue5
  " }}}

  " PHP highlighting --------------------------------------------------------{{{
  hi! link phpClass OneHue62
  hi! link phpFunction OneHue2
  hi! link phpFunctions OneHue2
  hi! link phpInclude OneHue3
  hi! link phpKeyword OneHue3
  hi! link phpParent OneMono3
  hi! link phpType OneHue3
  hi! link phpSuperGlobals OneHue5
  " }}}

  " Pug (Formerly Jade) highlighting ----------------------------------------{{{
  hi! link pugAttributesDelimiter OneHue6
  hi! link pugClass OneHue6
  call <sid>X('pugDocType',               s:mono_3,   '', s:italic)
  hi! link pugTag OneHue5
  " }}}

  " PureScript highlighting -------------------------------------------------{{{
  hi! link purescriptKeyword OneHue3
  hi! link purescriptModuleName OneSyntaxFg
  hi! link purescriptIdentifier OneSyntaxFg
  hi! link purescriptType OneHue62
  hi! link purescriptTypeVar OneHue5
  hi! link purescriptConstructor OneHue5
  hi! link purescriptOperator OneSyntaxFg
  " }}}

  " Python highlighting -----------------------------------------------------{{{
  hi! link pythonImport OneHue3
  hi! link pythonBuiltin OneHue1
  hi! link pythonStatement OneHue3
  hi! link pythonParam OneHue6
  hi! link pythonEscape OneHue5
  call <sid>X('pythonSelf',                 s:mono_2,    '', s:italic)
  hi! link pythonClass OneHue2
  hi! link pythonOperator OneHue3
  hi! link pythonEscape OneHue5
  hi! link pythonFunction OneHue2
  hi! link pythonKeyword OneHue2
  hi! link pythonModule OneHue3
  hi! link pythonStringDelimiter OneHue4
  hi! link pythonSymbol OneHue1
  " }}}

  " Ruby highlighting -------------------------------------------------------{{{
  hi! link rubyBlock OneHue3
  hi! link rubyBlockParameter OneHue5
  hi! link rubyBlockParameterList OneHue5
  hi! link rubyCapitalizedMethod OneHue3
  hi! link rubyClass OneHue3
  hi! link rubyConstant OneHue62
  hi! link rubyControl OneHue3
  hi! link rubyDefine OneHue3
  hi! link rubyEscape OneHue5
  hi! link rubyFunction OneHue2
  hi! link rubyGlobalVariable OneHue5
  hi! link rubyInclude OneHue2
  hi! link rubyIncluderubyGlobalVariable OneHue5
  hi! link rubyInstanceVariable OneHue5
  hi! link rubyInterpolation OneHue1
  hi! link rubyInterpolationDelimiter OneHue5
  hi! link rubyKeyword OneHue2
  hi! link rubyModule OneHue3
  hi! link rubyPseudoVariable OneHue5
  hi! link rubyRegexp OneHue1
  hi! link rubyRegexpDelimiter OneHue1
  hi! link rubyStringDelimiter OneHue4
  hi! link rubySymbol OneHue1
  " }}}

  " Spelling highlighting ---------------------------------------------------{{{
  call <sid>X('SpellBad',     '', s:syntax_bg, 'undercurl')
  call <sid>X('SpellLocal',   '', s:syntax_bg, 'undercurl')
  call <sid>X('SpellCap',     '', s:syntax_bg, 'undercurl')
  call <sid>X('SpellRare',    '', s:syntax_bg, 'undercurl')
  " }}}

  " Vim highlighting --------------------------------------------------------{{{
  hi! link vimCommand OneHue3
  call <sid>X('vimCommentTitle', s:mono_3, '', 'bold')
  hi! link vimFunction OneHue1
  hi! link vimFuncName OneHue3
  hi! link vimHighlight OneHue2
  call <sid>X('vimLineComment',  s:mono_3, '', s:italic)
  hi! link vimParenSep OneMono2
  hi! link vimSep OneMono2
  hi! link vimUserFunc OneHue1
  hi! link vimVar OneHue5
  " }}}

  " XML highlighting --------------------------------------------------------{{{
  hi! link xmlAttrib OneHue62
  hi! link xmlEndTag OneHue5
  hi! link xmlTag OneHue5
  hi! link xmlTagName OneHue5
  " }}}

  " ZSH highlighting --------------------------------------------------------{{{
  hi! link zshCommands OneSyntaxFg
  hi! link zshDeref OneHue5
  hi! link zshShortDeref OneHue5
  hi! link zshFunction OneHue1
  hi! link zshKeyword OneHue3
  hi! link zshSubst OneHue5
  hi! link zshSubstDelim OneMono3
  hi! link zshTypes OneHue3
  hi! link zshVariableDef OneHue6
  " }}}

  " Rust highlighting -------------------------------------------------------{{{
  call <sid>X('rustExternCrate',          s:hue_5,    '', 'bold')
  hi! link rustIdentifier OneHue2
  hi! link rustDeriveTrait OneHue4
  hi! link SpecialComment OneMono3
  hi! link rustCommentLine OneMono3
  hi! link rustCommentLineDoc OneMono3
  hi! link rustCommentLineDocError OneMono3
  hi! link rustCommentBlock OneMono3
  hi! link rustCommentBlockDoc OneMono3
  hi! link rustCommentBlockDocError OneMono3
  " }}}

  " man highlighting --------------------------------------------------------{{{
  hi! link manTitle String
  hi! link manFooter OneMono3
  " }}}

  " ALE (Asynchronous Lint Engine) highlighting -----------------------------{{{
  hi! link ALEWarningSign OneHue62
  hi! link ALEErrorSign OneHue5


  " Neovim NERDTree Background fix ------------------------------------------{{{
  hi! link NERDTreeFile OneSyntaxFg
  " }}}

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
  " delf <SID>XAPI
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
  call <sid>XAPI(a:group, a:fg, a:bg, a:attr)
endfunction
"}}}

if exists('s:dark') && s:dark
  set background=dark
endif

" vim: set fdl=0 fdm=marker:
