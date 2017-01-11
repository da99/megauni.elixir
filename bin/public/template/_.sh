#!/usr/bin/env mksh
# -*- mksh -*-
#
#

template () {

  local +x action="$1"; shift

  if [[ "$action" == "examples" ]]; then
    echo ""
    echo "==========================================="
    echo "bin/template  model   Screen_Name"
    echo "bin/template  model   Screen_Name  create"
    echo ""
    echo "bin/template  routes  Screen_Name"
    echo ""
    echo "bin/template  spec    Screen_Name"
    echo "bin/template  spec    Screen_Name  create"
    echo ""
    echo "bin/template  UP Screen_Name"
    echo "bin/template  UP Screen_Name  action_name"
    echo ""
    echo "bin/template  create    --> 01-create"
    echo "bin/template  read      --> 02-read"
    echo "bin/template  up_create --> 06-up_create"
    echo "bin/template  read_create --> 07-read_create"
    echo "bin/template  my_action --> XX-my_action"
    echo "==========================================="
    return 0
  fi

  # ====================
  if [[ -z "$@" ]]; then
    case "$action" in 
      create)
        echo "01-create"
        ;;
      read)
        echo "02-read"
        ;;
      update)
        echo "03-update"
        ;;
      trash)
        echo "04-trash"
        ;;
      delete)
        echo "05-delete"
        ;;
      up_create)
        echo "06-up_create"
        ;;
      read_create)
        echo "07-read_create"
        ;;
      *)
        echo "XX-$action"
        ;;
    esac

    exit 0
  fi # =================

  class="$1"
  shift

  sub_action="$@"
  tmpl="Server/Okdoki/templates/$action.rb"
  instance="$(echo $class | tr '[A-Z]' '[a-z]')"

  case "$action" in

    model)
      if [[ -z "$sub_action" ]]; then
        new_file="Server/$class/model.rb"
      else
        new_file="Server/$class/model/$sub_action.rb"
        tmpl="Server/Okdoki/templates/model.action.rb"
      fi
      ;; # ===================================================

    migrate)
      . bin/lib/list-models
      if [[ ! "${mods[@]}" == *"$class"* ]]
      then
        echo "$class not in list."
        exit 1
      fi

      bin/migrate_create "$class" "$@"
      exit 0
      ;; # ===================================================

    spec)
      new_file="Server/$class/specs/$(bin/template "$sub_action").rb"
      ;; # ===================================================

    routes)
      new_file="Server/$class/routes.rb"
      ;; # ===================================================

    *)
      echo "Unknown command: $action" 1>&2
      exit 1
      ;; # ===================================================

  esac # === case "$action"

  if [[ -f "$new_file" ]]
  then
    $yellow "=== already exists: $new_file"
  else

    # === Create the dir(s) if needed:
    mkdir -p "$(dirname "$new_file")"

    # === Replace template "vars":
    sed "s/MODEL/$class/g"  "$tmpl" >> "$new_file"
    sed "s/!model/$instance/g"           -i "$new_file"
    sed "s/!action/$action/g"            -i "$new_file"

    if [[ ! -z "$sub_action" ]]
    then
      sed "s/!sub_action/$sub_action/g"  -i "$new_file"
    fi

    # === Show finish message:
    echo "=== created: $new_file"
  fi # === if file exists or not

} # === template


