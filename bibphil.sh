#!/bin/bash

PHILPAGE=$(mktemp)
curl -s -o "$PHILPAGE" -O $1
DOI=$(grep "[>]10.[0-9]" "$PHILPAGE" | sed -n 1p | sed 's/<[^>]*>//g' | sed 's/ //g')
PDFLINK=$(grep -o 'https.*pdf' "$PHILPAGE" | sed -n 1p)
SCI_HUB="http://sci-hub.tw/"



function getbibentry(){

        read -p "Save a bib entry for the pdf? [Y/N]: "  ANSWER
        case "$ANSWER" in
                [yY] | [yY][eE][sS])
                        read -p "Where to save the file (absolute path): " BIBFILE
                        echo "Making a bib entry"

                        local ENTRY=$(mktemp)
                        curl  -s -o "$ENTRY" -LH "Accept: application/x-bibtex" http://dx.doi.org/$DOI

                        cat "$ENTRY" >> "$BIBFILE"
                        echo "The following entry was added to $BIBFILE"
                        cat "$ENTRY"
                        echo " "
                        ;;
                [nN] | [nN][oO])
                        echo "No bib entry was produced"
                        exit 0
                        ;;
                *)
                        echo "Invalid Answer =/"
                        exit 1
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

        pdfinfo

        if [ -n "$DOI" ]; then

                echo "Downloading your pdf..."
                curl -s -OL $(curl -s http://sci-hub.se/"$DOI" | grep location.href | grep -o http.*pdf)

        elif [ -n "$PDFLINK" ]; then
                
                echo "Downloading your pdf..."
                local FORMATNAME=$(grep  "nofollow" "$PHILPAGE" | sed 's/<[^>]*>//g' | sed -n 1p | sed 's/[ ,.?!-]/_/g' | sed 's/$/.pdf/g')
                curl  -o "$FORMATNAME" -s -LO "$PDFLINK"

        else
                echo "No archive avaliable for download!"
                exit 0
        fi
        
        echo "Download finished!"
        
        if [[ -n "$DOI" ]] || [[ -n "$PDFLINK" ]]; then
                getbibentry
        fi


        echo "++++++++++++++++++++++++"
        echo "+ BibPhil end!"
        echo "++++++++++++++++++++++++"
        
}

main $1
