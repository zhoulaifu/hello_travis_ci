IMAGE=test01
MOUNT=/mnt/local
all:
	echo "Hello travis ci"
	gcc hello.c
	#./a.out

build_docker:
	docker build --build-arg GIT_ACCESS_TOKEN=a1726de51c70ef109d9c73dff914261d20c796a9 -t "${IMAGE}" .

shaping:
	docker run --mount type=bind,source=${PWD},target=${MOUNT} -it "${IMAGE}" \
	bash -c "GSL='' LANG_LEX='' /opt/teex/shaping/main_tool < hello.c > hello_shape.c"

	docker run --mount type=bind,source=${PWD},target=${MOUNT} -it "${IMAGE}" \
	bash -c "mkdir -p in/  && tail -n +2 shape_parameters.txt > in/init.txt && rm -f shape_parameters.txt"

sanitizing:
	docker run --mount type=bind,source=${PWD},target=${MOUNT} -it "${IMAGE}" \
	afl-gcc hello_shape.c
fuzzing:
	docker run --mount type=bind,source=${PWD},target=${MOUNT} -it "${IMAGE}" \
	bash -c "afl-fuzz -i in -o out -- ./a.out"

run_docker:
	docker run \
	--mount type=bind,source=${PWD},target=${MOUNT} \
	-it "${IMAGE}" /bin/bash


git:
	git commit -a -m ".."
	git push
