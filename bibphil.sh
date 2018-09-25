#!/bin/bash




PHILPAGE=$(mktemp)
curl -s -o "$PHILPAGE" -O $1
DOI=$(grep ">10.[0-9]" "$PHILPAGE" | sed -n 1p | sed 's/<[^>]*>//g' | sed 's/ //g')
PDFLINK=$(grep -o 'https.*pdf' "$PHILPAGE" | sed -n 1p)
SCI_HUB="http://sci-hub.tw/"


function getbibentry(){
        local ENTRY=$(mktemp)
        curl  -s -o "$ENTRY" -LH "Accept: application/x-bibtex" http://dx.doi.org/$DOI
        read -p "Where to save the file (absolute path): " BIBFILE
        echo "Making a bib entry"
        cat "$ENTRY" >> "$BIBFILE"
        echo "The following entry was added to $BIBFILE"
        cat "$ENTRY"
        echo " "

}

bibphil (){

        echo "BibPhil start!"
        echo "==="
        echo "Searching for doi..."

        if [ -n "$DOI" ]; then

                echo "Doi: $DOI founded!"
                echo "Downloading your pdf..."
                curl -s -OL $(curl -s http://sci-hub.se/"$DOI" | grep location.href | grep -o http.*pdf)
                echo "Download...ok"

        elif [ -n "$PDFLINK" ]; then
                
                echo "No digital object identifier (doi) founded!"
                echo "Trying to downloading from PhilArchive..."

                local FORMATNAME=$(grep  "nofollow" "$PHILPAGE" | sed 's/<[^>]*>//g' | sed -n 1p | sed 's/[ ,.?!-]/_/g' | sed 's/$/.pdf/g')
                curl  -o "$FORMATNAME" -s -LO "$PDFLINK"
                echo "Download...ok"

        else
                echo "No archive avaliable for download!"
                exit 0
        
        fi

        read -p "Would you like to save a corresponding bib entry for the pdf? [Y/N]: " WANTBIB
        case "$WANTBIB" in
                [yY] | [yY][eE][sS])
                        getbibentry
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

bibphil $1
