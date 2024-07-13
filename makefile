init:
	git checkout dev
	git pull
	git log --oneline -n 5
main:
	git checkout main
	git merge dev
	git push