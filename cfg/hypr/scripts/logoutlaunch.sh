#!/usr/bin/env sh

# -- utils --

msg() {
  printf "\033[32;1m%s\033[m %s\n" "$PROMPT" "$*"
}

warn() {
  >&2 printf "\033[33;1m%s \033[mwarning: %s\n" "$PROMPT" "$*"
}

die() {
  >&2 printf "\033[31;1m%s \033[merror: %s\n" "$PROMPT" "$*"
  exit 1
}

confirm() {
  >&2 printf "\033[33;1m%s \033[mconfirm? %s" "$PROMPT" "$CONFIRM_PROMPT"
  read -n 1 -r ans
  [[ ! "$ans" =~ ^[Yy]$ ]] && {
    >&2 printf '%s\n' 'Exiting.'
    exit 1
  };
  echo
}

ask() {
  >&2 printf "\033[33;1m%s \033[(y/N) %s" "$PROMPT" "$CONFIRM_PROMPT"
  read -n 1 -r ans
  echo
  [[ ! "$ans" =~ ^[Yy]$ ]] && {
    return 1
  }
}

has() {
  if ! command -v "$1" &>/dev/null; then
    return 1
  fi
}

# -- usage --

usage() {
>&2 cat <<"EOF"
  main   -  show main logout
  quick  -  show quick logout
EOF
exit 1
}

# -- main --

main() {
  [ "$1" ] || usage

  flag=${1#-}
  shift

  case $flag in
    'main'|'quick') launch $flag ;;
    *) die "command does not exist" ;;
  esac
}

launch() {
  # detect monitor y res
  res=`cat /sys/class/drm/*/modes | head -1 | cut -d 'x' -f 2`

  # scale config layout and style
  case $1 in
    main)
      export mgn=$(( res * 10 / 100 ))
      export hvr=$(( res * 5 / 100 )) ;;
    quick)  wlColms=2
      export mgn=$(( res * 8 / 100 ))
      export mgn2=$(( res * 65 / 100 ))
      export hvr=$(( res * 3 / 100 ))
      export hvr2=$(( res * 60 / 100 )) ;;
    *)  die "Error: invalid parameter passed..." ;;
  esac

  # scale font size
  export fntSize=$(( res * 2 / 100 ))

  # detect gtk system theme
  #export gtkThm=`gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g"`
  #export csMode=`gsettings get org.gnome.desktop.interface color-scheme | sed "s/'//g" | awk -F '-' '{print $2}'`
  #export wbarTheme="$HOME/.config/waybar/themes/${gtkThm}.css"

  # eval hypr border radius
  #hyprTheme="$HOME/.config/hypr/themes/${gtkThm}.conf"
  #hypr_border=`awk -F '=' '{if($1~" rounding ") print $2}' $hyprTheme | sed 's/ //g'`
  hypr_border=4
  export active_rad=$(( hypr_border * 5 ))
  export button_rad=$(( hypr_border * 8 ))

  # set file variables
  wLayout="$HOME/.config/wlogout/layout_$1.ctl"
  wlTmplt="$HOME/.config/wlogout/style_$1.css"

  # eval config files
  wlStyle=`envsubst < $wlTmplt`

  # eval padding
  y_pad=$(( res * 20 / 100 ))

  [[ -z "$wlColms" ]] && {
    wlColms=`cat "$wLayout" | grep -E '"label"\s*:' | wc -l`
  }

  # launch wlogout
  wlogout -b $wlColms -c 0 -r 0 -T $y_pad -B $y_pad --layout $wLayout --css $wlTmplt --protocol layer-shell
}

main "$@" || exit 1
