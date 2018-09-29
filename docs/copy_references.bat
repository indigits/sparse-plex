@echo off
copy "I:\work\projects\public\articles\texmf\bibtex\bib\misc\sksrrcs.bib" .
sed 's/@online/@misc/' sksrrcs.bib > sksrrcs2.bib
mv sksrrcs2.bib sksrrcs.bib

