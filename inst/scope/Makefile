scope.pdf: scope.tex
	latexmk -pv -pdf $<
	latexmk -c
	git add -A
	git commit -am "update scope"
