#!/bin/bash

PHILPAGE=$(mktemp)
curl -s -o "$PHILPAGE" -O $1
DOI=$(grep "[>]10.[0-9]" "$PHILPAGE" | sed -n 1p | sed 's/<[^>]*>//g' | sed 's/ //g')
PDFLINK=$(grep -o 'https.*pdf' "$PHILPAGE" | sed -n 1p | sed 's/ //g')
SCI_HUB="http://sci-hub.tw/"
LOCAL_BIB="$HOME/.bibphil.tmp"



function getbibentry(){

        read -p "Save a bib entry for the pdf? [Y/N]: "  ANSWER
        case "$ANSWER" in
                [yY] | [yY][eE][sS])

                        local ENTRY=$(mktemp)
                        curl  -s -o "$ENTRY" -LH "Accept: application/x-bibtex" http://dx.doi.org/$DOI
                        
                        if [[ -f "$LOCAL_BIB" ]]; then
                                local PATH_BIB=$(sed -n 1p "$LOCAL_BIB")
                                echo " " >> "$PATH_BIB"
                                cat "$ENTRY" >> "$PATH_BIB"
                                echo " " >> "$PATH_BIB"
                                echo "Saving on $PATH_BIB"
                        else 
                                read -p "Where is your bib file? (absolute path): " BIBFILE
                                echo "$BIBFILE" >> "$LOCAL_BIB"
                                echo "Making a bib entry..." 
                                echo " " >> "BIBFILE"
                                cat "$ENTRY" >> "$BIBFILE"
                                echo " " >> "$BIBFILE"
                                echo "The following entry was added to $BIBFILE"
                                cat "$ENTRY"
                                echo " "
                        fi
                        ;;

                [nN] | [nN][oO])
                        echo "No bib entry was produced"
                        ;;
                *)
                        echo "Invalid Answer =/"
                        ;;
        esac


}

function pdfinfo(){

        local TITLE=$(grep  "<h1[^>]*>" ${PHILPAGE} | sed 's/<[^>]*>//g')
        local AUTHOR=$(grep "itemprop='author'" ${PHILPAGE} | sed 's/<[^>]*>//g')

        echo "Title: $TITLE"
        echo "Author: $AUTHOR"
}

main (){

        echo "++++++++++++++++++++++++"
        echo "+ BibPhil start!"
        echo "++++++++++++++++++++++++"
        echo "Looking for your pdf..."

        sleep 2
        
        pdfinfo;

       if [ -n "$PDFLINK" ]; then
                echo "Downloading your pdf..."
                curl -s -LO "$PDFLINK"
        elif [ -n "$DOI" ]; then
               echo "Downloading your pdf..." 
               curl -s -LO $(curl -s http://sci-hub.tw/"$DOI" | grep location.href | grep -o http.*pdf)
        else
                echo "No archive avaliable for download!"
        fi
        
        echo "Download finished!"
        
        if [[ -n "$DOI" ]] || [[ -n "$PDFLINK" ]]; then
                getbibentry
        fi

        echo "++++++++++++++++++++++++"
        echo "+ BibPhil end!"
        echo "++++++++++++++++++++++++"
        
}

main
