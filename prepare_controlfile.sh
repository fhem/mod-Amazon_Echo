#!/usr/bin/env bash

source $HOME/.profile

controls_file="controls_echodevice.txt"
changed_file="CHANGED"

rm ${controls_file}
find -type f \( -path './FHEM/*' -o -path './www/*' \) -print0 | while IFS= read -r -d '' f;
do
    echo "DEL ${f}" >> ${controls_file}
    out="UPD "$(stat -c %y  $f | cut -d. -f1 | awk '{printf "%s_%s",$1,$2}')" "$(stat -c %s $f)" ${f}"
    echo ${out//.\//} >> ${controls_file}
done

rm ${changed_file}
echo "*** And in this weeks episode at $(basename `git rev-parse --show-toplevel`):" >> ${changed_file}
git log HEAD --pretty="%h %ad %s" --date=format:"%m.%d.%Y %H:%M" FHEM/ www/ >> ${changed_file}

find . -type f -iname '.DS_Store' -delete