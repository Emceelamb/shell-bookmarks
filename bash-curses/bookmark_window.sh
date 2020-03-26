source $(dirname $0)/bashsimplecurses/simple_curses.sh

bookmarkfile="$HOME/.shellbookmarks"
main(){
  window "Saved Bookmarks" "red" "50%"

  saved_bookmarks=()
  while IFS= read -r line; do
    saved_bookmarks+=("$line")
  done < $bookmarkfile
    counter=0
    for i in "${saved_bookmarks[@]}"
    do 
      bookmark=($i)
      append_tabbed "$counter ${bookmark[1]}" 2  " "
      (( counter++))
    done
  endwin
}

no_loop
