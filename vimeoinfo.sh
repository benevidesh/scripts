#!/bin/bash

# titulo 
# sed 's/title/\ntitle/g' <nome-do-arq> | grep '^title"\:' | sed 's/,/\n/g' | sed -n 1p | sed 's/"//g' | sed 's/title://g' | sed 's/\u00a7/ - /g'

# descrição
# sed 's/description/\ndescription/g' 59645793 | grep '^description\"\:' | sed -n 1p | sed 's/<[^>]*>//g' | sed 's/"/\n/g' | sed -n 3p

# comments
# sed 's/,/\n/g' 59645793 | grep 'userInteractionCount' | sed 's/[^0-9]*//g' | sed -n 1p

# likes
# sed 's/,/\n/g' 59645793 | grep 'userInteractionCount' | sed 's/[^0-9]*//g' | sed -n 2p

# views
# sed 's/,/\n/g' 59645793 | grep 'userInteractionCount' | sed 's/[^0-9]*//g' | sed -n 3p

function vimeoinfo(){
        local FILEPATH=$(mktemp)
        curl -s -o "$FILEPATH" -O $1 

        local V_TITLE=$(sed 's/title/\ntitle/g' "$FILEPATH" | grep '^title"\:' | sed 's/,/\n/g' | sed -n 1p | sed 's/"//g' | sed 's/title://g' | sed 's/\u00a7/ - /g')
        local V_DESCRIPTION=$(sed 's/description/\ndescription/g' "$FILEPATH" | grep '^description\"\:' | sed -n 1p | sed 's/<[^>]*>//g' | sed 's/"/\n/g' | sed -n 3p)
        local v_VIEWS=$(sed 's/,/\n/g' "$FILEPATH" | grep 'userInteractionCount' | sed 's/[^0-9]*//g' | sed -n 3p)
        local V_LIKES=$(sed 's/,/\n/g' "$FILEPATH" | grep 'userInteractionCount' | sed 's/[^0-9]*//g' | sed -n 2p)
        local V_COMMENTS=$(sed 's/,/\n/g' "$FILEPATH" | grep 'userInteractionCount' | sed 's/[^0-9]*//g' | sed -n 1p)



        echo "==="
        echo "Titulo: $V_TITLE"
        echo "Descrição: $V_DESCRIPTION"
        echo "Visualizações: $v_VIEWS"
        echo "Curtidas: $V_LIKES"
        echo "Qtd. de Comentários: $V_COMMENTS"
        echo "==="



}


vimeoinfo $1
