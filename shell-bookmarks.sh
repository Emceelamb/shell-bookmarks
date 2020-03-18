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
NORMAL="0m"

if [ ! -e "$bookmarkfile" ]
then
  touch $bookmarkfile
  echo -e "Bookmark location: \e[${RED}$bookmarkfile\e[${NORMAL}"
fi

function bmk() {
  readarray -t saved_bookmarks < $bookmarkfile

######## LIST BOOKMARKS #######
  if [[ -z "$1" ]] || [[ $1 == 'l' ]]
  then
    counter=0
    for i in "${saved_bookmarks[@]}"
    do printf '[%d] %s\n' "$counter" "${i}"
      (( counter++))
    done

######## GOTO BOOKMARK #######
  elif [[ $1 == 'g' ]]
  then
    working_dir=${saved_bookmarks[$2]}
    cd $working_dir

######## SAVE BOOKMARK #######
  elif [[ $1 == 's' ]]
  then
    working_dir=$(pwd)
    echo $working_dir >> $bookmarkfile
    echo -e "Saved \e[${RED}$working_dir\e[${NORMAL} to bookmarks."

####### DELETE BOOKMARK ######
  elif [[ $1 == 'd' ]]
  then
    toDelete=$(($2 + 1))
    sed -i "${toDelete}d" $bookmarkfile
    echo -e "Deleted \e[${RED}${saved_bookmarks[$2]}\e[${NORMAL} from bookmarks."
  fi

  readarray -t saved_bookmarks < $bookmarkfile
}
