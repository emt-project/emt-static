#!/bin/bash

cd tex 

echo "Processing collection PDF..."
xelatex -interaction=nonstopmode tmp.tex
xelatex -interaction=nonstopmode tmp.tex
mv tmp.pdf ../html/emt.pdf

for texfile in *.tex; do
    # Skip the main collection file
    if [ "$texfile" != "tmp.tex" ]; then
        echo "Processing $texfile..."
        basename=$(basename "$texfile" .tex)
        xelatex -interaction=nonstopmode "$texfile"
        xelatex -interaction=nonstopmode "$texfile"
        
        if [ -f "${basename}.pdf" ]; then
            mv "${basename}.pdf" "../html/"
        fi
    fi
done

rm *.aux *.log *.out *.tex
rm  *.idx *.ilg *.ind
# rm tmp.*