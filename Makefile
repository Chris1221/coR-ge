all: git

git: 
	git add -A
	git commit -am "update package"
	git push
