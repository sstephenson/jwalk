CHARS="$(printf '\n\t')"
LF="${CHARS%?}"
TAB="${CHARS#?}"


# Stage 1:
#   Replace escaped double-quote sequences (`\"`) with tabs
#   Insert linefeeds around all other double-quote characters

sed -e '
  s/\\"/'"$TAB"'/g
  s/"[^"]*"/\'"$LF"'&\'"$LF"'/g
' |


# Stage 2:
#   For every chunk of the stream that's not a string literal,
#     Insert linefeeds around brackets, braces, colons, and commas
#   Replace all tabs in string literals with escaped double-quotes

sed -e '
  /".*"$/ !{
    s/[][,:}{}]/\'"$LF"'&\'"$LF"'/g
  }
  s/'"$TAB"'/\\"/g
' |


# Stage 3:
#   Remove leading whitespace and empty lines

sed -e '
  s/^[ '"$TAB"']*//
  /^$/d
'
