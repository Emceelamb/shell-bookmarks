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
bookmarkfile="$(pwd)/.shellbookmarks"

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

######## LIST BOOKMARKS #######
  if [[ -z "$1" ]] || [[ $1 == 'l' ]]; then
    counter=0
    for i in "${saved_bookmarks[@]}"
    do printf '[%d] %s\n' "$counter" "${i}"
      (( counter++))
    done

######## GOTO BOOKMARK #######
  elif [[ $1 == 'g' ]]; then
    working_dir=${saved_bookmarks[$2]}
    cd $working_dir
    echo -e "\e[${GREEN}Jumped to $working_dir.\e[${NORMAL}"

######## SAVE BOOKMARK #######
  elif [[ $1 == 's' ]]; then
    working_dir=$(pwd)
    echo $working_dir >> $bookmarkfile
    echo -e "Saved \e[${RED}$working_dir\e[${NORMAL} to bookmarks."

####### DELETE BOOKMARK ######
  elif [[ $1 == 'd' ]]; then
    toDelete=$(($2 + 1))
    sed -i "${toDelete}d" $bookmarkfile
    echo -e "Deleted \e[${RED}${saved_bookmarks[$2]}\e[${NORMAL} from bookmarks."


##############################
########  EDGE CASES   #######
##############################

####### IF INVALID ARG #######

  elif [[ $1 !=  [0-9] ]]; then
    echo -e "\e[${RED}Bookmark command not recognized!\e[${NORMAL}"
    echo -e "View saved boomarks with 'bmk l'"
    echo -e "Save location to boomark with 'bmk s'"
    echo -e "Delete saved boomark with 'bmk d <bookmark>'"
    echo -e "Goto saved boomark with 'bmk g <bookmark>'"

####################################################
######  IF 'G' LEFT OUT BUT BOOKMARK EXISTS  #######
################  GO TO BOOKMARK  ##################
####################################################

  elif [[ $1 -ge 0 ]] && [[ $1 -le ${#saved_bookmarks[@]} ]]; then
    working_dir=${saved_bookmarks[$1]}
    cd $working_dir
    echo -e "\e[${GREEN}Jumped to $working_dir.\e[${NORMAL}"
  
  elif [[ $1 -gt ${#saved_bookmarks[@]} ]]; then
    echo -e "\e[${RED}Bookmark not found!\e[${NORMAL}"

  fi

  # readarray requires GNU Bash 4.0 <=
  # readarray -t saved_bookmarks < $bookmarkfile
  
    saved_bookmarks=()
    while IFS= read -r line; do
      saved_bookmarks+=("$line")
    done < $bookmarkfile
    echo $saved_bookmarks  
}
