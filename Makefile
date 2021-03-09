all:
	echo "Hello travis ci"
	gcc hello.c
	#./a.out

git:
	git commit -a -m ".."
	git push
