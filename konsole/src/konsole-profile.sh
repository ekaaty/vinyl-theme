#!/bin/bash

__which() {
    /usr/bin/which "${1}" 2> /dev/null \
    || echo "${1}${KDE_SESSION_VERSION}"
}

__kreadconfig=$(__which kreadconfig)
__konsoleprofile=$(__which konsoleprofile)


if [ "${XDG_CURRENT_DESKTOP}" == "KDE" ]; then
    _colorScheme=$(
        ${__kreadconfig} \
            --file ~/.config/kdeglobals \
            --group General \
            --key ColorScheme \
        | sed 's/\ /-/g;s/-.*-/-/'
    )

   ${__konsoleprofile} \
        ColorScheme="${_colorScheme:-system}"    
fi
