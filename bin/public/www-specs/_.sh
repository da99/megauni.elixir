
# === {{CMD}}

specs () {

  PORT="$(cat $THIS_DIR/config/ports | head -n 1)"
  URL="http://localhost:$PORT"
  $0 server reload

  PAGE="/no-exist"
  sh_color BOLD "--- '404 Not Found' on {{$PAGE}}: " "-n"
  curl --head --silent "$URL/no-exist" | grep -P "^HTTP/[\d\.]+ 404 Not Found"

  sh_color BOLD "--- '200 OK' on {{/}}: " "-n"
  curl --head --silent "$URL/" | grep -P "^HTTP/[\d\.]+ 200 OK"

  sh_color BOLD "--- Renders {{/}} as {{/index.html}}: " "-n"
  [[ "$(curl --silent "$URL/")" == "$(cat Public/index.html)" ]] && echo "equal"


  file="$(find Public -type f -iname "*.js" -print -quit | cut -d'/' -f2- )"
  sh_color BOLD "--- '200 OK' on JS files (eg {{$file}}): " "-n"
  curl --head --silent "$URL/$file" | grep -P "^HTTP/[\d\.]+ 200 OK"

  sh_color BOLD "--- Renders JS files (eg {{$file}}): " "-n"
  [[ "$(curl --silent "$URL/$file")" == "$(cat "Public/$file")" ]] && echo "equal"
} # === end function specs

www-specs () {
  specs
} # === end function
