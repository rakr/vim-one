# Vim-One colorscheme

Light and dark vim colorscheme, shamelessly stolen from atom (another excellent text editor). **One** is best suited for GUI but does fallback gracefully and automatically if your environment does not support true colors.

Below a high-res screenshot, don't hesitate to open the image in a new tab to see all the details.

![Vim One Screenshot][screenshot_global]

## Vim Airline theme

Add the following line to your `~/.vimrc` or `~/.config/nvim/init.vim`

```vim
let g:airline_theme='one'
```

As for the colorscheme, this theme comes with light and dark flavors.


![Vim Airline Normal Dark][screenshot_normal_dark]
![Vim Airline Insert Dark][screenshot_insert_dark]
![Vim Airline Visual Dark][screenshot_visual_dark]
![Vim Airline Replace Dark][screenshot_replace_dark]

![Vim Airline Normal Light][screenshot_normal_light]
![Vim Airline Insert Light][screenshot_insert_light]
![Vim Airline Visual Light][screenshot_visual_light]
![Vim Airline Replace Light][screenshot_replace_light]

## List of enhanced language support
Work is still in progress, pull requests are more than welcome here.

* Cucumber features
* CSS and Sass
* Elixir
* HTML
* JavaScript, JSON
* Ruby
* Vim
* XML

## Installation

You can use your preferred Vim Package Manager to install **One**.

## Usage

**One** comes in two flavors: light and dark, make sure to properly set your `background` before setting the colorscheme.

To benefit from the **true color** support make sure to add the following lines in your `.vimrc` or `.config/nvim/init.vim`

```vim
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif
```

[screenshot_global]: screenshots/vim-one.png
[screenshot_normal_dark]: screenshots/normal-dark.png
[screenshot_insert_dark]: screenshots/insert-dark.png
[screenshot_visual_dark]: screenshots/visual-dark.png
[screenshot_replace_dark]: screenshots/replace-dark.png
[screenshot_normal_light]: screenshots/normal-light.png
[screenshot_insert_light]: screenshots/insert-light.png
[screenshot_visual_light]: screenshots/visual-light.png
[screenshot_replace_light]: screenshots/replace-light.png
