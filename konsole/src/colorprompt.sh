#!/bin/bash

function kf6_get_color_rgb() {
    echo $(
	kreadconfig6 \
	    --file ~/.config/kdeglobals \
	    --group ${1:-General} \
	    --key ${2:-BackgroundNormal} \
	| sed 's/,/;/g' | cut -d\; -f1-3
    )
}

if [ "${XDG_CURRENT_DESKTOP}6" == "KDE6" ]; then
    case "${TERM}" in
        xterm-256color) 
            _rgb_color=$(
	        kf6_get_color_rgb \
                    Colors:Selection \
                    BackgroundNormal
	    ) \
            && ACCENT_COLOR=$(echo -e "\e[38;2;${_rgb_color}m")
        ;;
        *) 
            # Do nothing
	;;
    esac
fi

if tty -s; then
    red=$(tput setaf 1)
    green=$(tput setaf 2)
    yellow=$(tput setaf 3)
    blue=$(tput setaf 4)
    purple=$(tput setaf 5)
    cyan=$(tput setaf 6)
    gray=$(tput setaf 7)

    HOST_COLOR=
    if [ -r ~/.config/colorpromptrc ]; then 
	. $(realpath -eL ${HOME}/.config/colorpromptrc)
    fi
    
    RST=$(tput sgr0)
    if [ $(id -u) -eq 0 ]; then
       ACCENT_COLOR=${red}
    else
       ACCENT_COLOR=${ACCENT_COLOR:-${blue}}
    fi

    HOST_COLOR=${HOST_COLOR:-${ACCENT_COLOR}}
fi

PS1_U="\[${RST}\][\[${USER_COLOR}\]\u\[${RST}\]"
PS1_H="\[${RST}\]\[${HOST_COLOR}\]\h\[${RST}\]"
PS1_C="\${CHROOT_NAME:+(\${CHROOT_NAME})}"
PS1_S="\[${ACCENT_COLOR}\]\\$\[${RST}\]"

# Set the shell prompt
export PS1="${PS1_U:-\u}@${PS1_H:-\h}${PS1_C} \w]${PS1_S:-\$} "
