#!/bin/bash

set -e

TARGET_DIR=../target

rm -rf $TARGET_DIR

if [[ ! -d "$TARGET_DIR" ]]; then
  mkdir -p $TARGET_DIR
  mkdir -p $TARGET_DIR/images
  mkdir -p $TARGET_DIR/pdf
fi

for f in ../images/*.svg
do
  if [[ $f =~ \./images/(.*)\.svg ]]; then
    if [[ $(grep foreignObject ../images/${BASH_REMATCH[1]}.svg | wc -l) != 0 ]]; then
      ## Process foreignObject in SVG using phantomjs as renderer
      svg2pdf -w 100% ../images/${BASH_REMATCH[1]}.svg $TARGET_DIR/pdf/${BASH_REMATCH[1]}.pdf
      inkscape --without-gui --export-area-drawing --file=$TARGET_DIR/pdf/${BASH_REMATCH[1]}.pdf --export-plain-svg=$TARGET_DIR/images/${BASH_REMATCH[1]}.svg
    else
      ## Inkscape can process SVG whitch without foreignObject directly
      cp ../images/${BASH_REMATCH[1]}.svg $TARGET_DIR/images/${BASH_REMATCH[1]}.svg
    fi
    inkscape --without-gui --export-area-drawing --file=$TARGET_DIR/images/${BASH_REMATCH[1]}.svg --export-pdf=$TARGET_DIR/${BASH_REMATCH[1]}.pdf --export-latex=$TARGET_DIR/${BASH_REMATCH[1]}.pdf_tex
    ## Pre-process pdf_tex file to get better result
    python3 svgtex.py $TARGET_DIR/${BASH_REMATCH[1]}.pdf_tex $TARGET_DIR/${BASH_REMATCH[1]}.pdf_tex.tmp
    mv $TARGET_DIR/${BASH_REMATCH[1]}.pdf_tex.tmp $TARGET_DIR/${BASH_REMATCH[1]}.pdf_tex
  fi
done

for f in ../images/*.jpg; do
    [ -e "$f" ] && cp -rf ../images/*.jpg $TARGET_DIR/images || echo "Ignore jpg files"
    ## This is all we needed to know, so we can break after the first iteration
    break
done

for f in ../images/*.png; do
    [ -e "$f" ] && cp -rf ../images/*.png $TARGET_DIR/images || echo "Ignore png files"
    ## This is all we needed to know, so we can break after the first iteration
    break
done

for f in ../images/*.bmp; do
    [ -e "$f" ] && cp -rf ../images/*.bmp $TARGET_DIR/images || echo "Ignore bmp files"
    ## This is all we needed to know, so we can break after the first iteration
    break
done

for f in ../*.md
do
  if [[ $f =~ \./(.*)\.md ]]; then
    cp $f $TARGET_DIR
    FILENAME="${BASH_REMATCH[1]}.md" pandoc -o "$TARGET_DIR/${BASH_REMATCH[1]}.tex" -f markdown_github+footnotes+header_attributes-hard_line_breaks-intraword_underscores --pdf-engine=lualatex --top-level-division=chapter --listings --filter ./filter.py $f
    python3 mathtex.py $TARGET_DIR/${BASH_REMATCH[1]}.tex $TARGET_DIR/${BASH_REMATCH[1]}.tex.tmp
    mv $TARGET_DIR/${BASH_REMATCH[1]}.tex.tmp $TARGET_DIR/${BASH_REMATCH[1]}.tex
  fi
done

cp *.tex $TARGET_DIR/
cp latexmkrc $TARGET_DIR/

cd $TARGET_DIR/

latexmk -pdf index.tex
