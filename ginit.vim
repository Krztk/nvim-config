" Set Editor Font
if exists(':GuiFont')
    " Use GuiFont! to ignore font errors
    " GuiFont JetBrains Mono:h12
    GuiFont Literation Mono Nerd Font:h12 "liberation mono + icons
endif

" Disable GUI Tabline
if exists(':GuiTabline')
    GuiTabline 0
endif

" Disable GUI Popupmenu
if exists(':GuiPopupmenu')
    GuiPopupmenu 0
endif
