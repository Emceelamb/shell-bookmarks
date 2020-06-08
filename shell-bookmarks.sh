#!/bin/sh

################################
################################
######   ┌─┐┬ ┬┌─┐┬  ┬     #####
######   └─┐├─┤├┤ │  │     #####
######   └─┘┴ ┴└─┘┴─┘┴─┘   #####
######   ┌┐ ┌─┐┌─┐┬┌─      #####
######   ├┴┐│ ││ │├┴┐      #####
######   └─┘└─┘└─┘┴ ┴      #####
######   ┌┬┐┌─┐┬─┐┬┌─┌─┐   #####
######   │││├─┤├┬┘├┴┐└─┐   #####
######   ┴ ┴┴ ┴┴└─┴ ┴└─┘   #####
################################
##################emceelamb#####

#### BOOKMARK FILE LOCATION ####
bookmarkfile="$HOME/.shellbookmarks"

#### BASH SIMPLE CURSES ####
curseswindow="$(dirname $(readlink -f '$0'))/bash-curses/bookmark_window.sh"

### ANSI COLOR CODES ###
RED="1;31m"
GREEN="1;32m"
NORMAL="0m"

if [ ! -e "$bookmarkfile" ]
then
  touch $bookmarkfile
  echo -e "Bookmark location: \e[${RED}$bookmarkfile\e[${NORMAL}"
fi

function bmk() {

  # readarray requires GNU Bash 4.0 <=
  # readarray -t saved_bookmarks < $bookmarkfile

  saved_bookmarks=()
  while IFS= read -r line; do
    saved_bookmarks+=("$line")
  done < $bookmarkfile

##### REMOVE ALL BOOK MARKS #####  
  if [[ $1 == 'clear' ]]; then
    mv $bookmarkfile ${bookmarkfile}.bak # Backup bookmarks
    touch $bookmarkfile
    echo "Cleared all bookmarks."

######## LIST BOOKMARKS #######
##### CHECK IF NO BOOKMARK EXISTS #####
  elif [[ -z "$1" ]] && [[ $(cat $bookmarkfile | wc -l) -eq 0 ]] || [[ $1 == 'l' ]] && [[ $(cat $bookmarkfile | wc -l) -eq 0 ]]; then
    echo -e "\e[${RED}No bookmarks found!\e[${NORMAL}"

##### IF BOOKMARK EXISTS #####
  elif [[ -z "$1" ]] || [[ $1 == 'l' ]]; then
    $curseswindow
    
    ### SIMPLE BOOKMARKS ###
    # counter=0
    # for i in "${saved_bookmarks[@]}"
    # do 
    #   bookmark=($i)
    #   printf '[%d] /%s\n' "$counter" "${bookmark[1]}"
    #   (( counter++))
    # done

######## GOTO BOOKMARK #######
##### CHECK IF NO BOOKMARK EXISTS #####
  elif [[ $1 == 'g' && $(cat $bookmarkfile | wc -l) -eq 0 ]]; then
    echo -e "\e[${RED}Bookmark not found!\e[${NORMAL}"

##### IF BOOKMARK EXISTS #####
  elif [[ $1 == 'g' && $(cat $bookmarkfile | wc -l) > 0 ]]; then

    tput clear
    bookmark=( ${saved_bookmarks[$2]} )
    cd ${bookmark[0]}
    echo -e "\e[${GREEN}Go to ${bookmark[1]}.\e[${NORMAL}"

######## SAVE BOOKMARK #######
  elif [[ $1 == 's' ]]; then
    current_dir=$(pwd)
    basename=$(basename $current_dir)
    echo $current_dir $basename >> $bookmarkfile
    echo -e "Saved \e[${RED}$basename\e[${NORMAL} to bookmarks."

####### DELETE BOOKMARK ######
##### CHECK IF NO BOOKMARK EXISTS #####
  elif [[ $1 == 'd' && $(cat $bookmarkfile | wc -l) -eq 0 ]]; then
    echo -e "\e[${RED}Bookmark not found!\e[${NORMAL}"

##### IF BOOKMARK EXISTS #####
  elif [[ $1 == 'd' ]]; then
    bookmark=( ${saved_bookmarks[$2]} )
    toDelete=$(($2 + 1))
    sed -i "${toDelete}d" $bookmarkfile
    echo -e "Deleted \e[${RED}${bookmark[1]}\e[${NORMAL} from bookmarks."


##############################
########  EDGE CASES   #######
##############################

####### IF INVALID ARG #######

  elif [[ $1 !=  [0-9] ]]; then
    echo -e "\e[${RED}Bookmark command not recognized!\e[${NORMAL}"
    echo -e "View saved bookmarks with 'bmk l'"
    echo -e "Save location to bookmark with 'bmk s'"
    echo -e "Delete saved bookmark with 'bmk d <bookmark>'"
    echo -e "Goto saved bookmark with 'bmk g <bookmark>'"
    echo -e "Clear all saved bookmark with 'bmk clear'"

####################################################
######  IF 'G' LEFT OUT BUT BOOKMARK EXISTS  #######
################  GO TO BOOKMARK  ##################
####################################################

##### CHECK IF NO BOOKMARK EXISTS #####
  elif [[ $1 == '0' && $(cat $bookmarkfile | wc -l) -eq 0 ]]; then
    echo -e "\e[${RED}Bookmark not found!\e[${NORMAL}"

##### OTHERWISE GOTO BOOKMARK #####
  elif [[ $1 -ge 0 ]] && [[ $1 -le ${#saved_bookmarks[@]} ]]; then
    tput clear
    bookmark=( ${saved_bookmarks[$1]} )
    cd ${bookmark[0]}
    echo -e "\e[${GREEN}Go to ${bookmark[1]}.\e[${NORMAL}"
  
  elif [[ $1 -gt ${#saved_bookmarks[@]} ]]; then
    echo -e "\e[${RED}Bookmark not found!\e[${NORMAL}"
  else:
    echo -e "\e[${RED}Bookmark not found!\e[${NORMAL}"

  fi

  # readarray requires GNU Bash 4.0 <=
  # readarray -t saved_bookmarks < $bookmarkfile
  
    saved_bookmarks=()
    while IFS= read -r line; do
      saved_bookmarks+=("$line")
    done < $bookmarkfile
}
