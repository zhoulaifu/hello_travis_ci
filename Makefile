IMAGE?=test01
MOUNT?=/mnt/local

TOKEN?=not_working
all:
	echo "Hello travis ci"
	gcc hello.c
	#./a.out

build_docker:
	docker build --build-arg GIT_ACCESS_TOKEN=${TOKEN} -t "${IMAGE}" .

shaping:
	docker run --mount type=bind,source=${PWD},target=${MOUNT} -it "${IMAGE}" \
	bash -c "GSL='' LANG_LEX='' /opt/teex/shaping/main_tool < hello.c > hello_shape.c"

	docker run --mount type=bind,source=${PWD},target=${MOUNT} -it "${IMAGE}" \
	bash -c "mkdir -p in/  && tail -n +2 shape_parameters.txt > in/init.txt && rm -f shape_parameters.txt"

debug:
	docker run --privileged -it "${IMAGE}" \
	cat /proc/sys/kernel/core_pattern
sanitizing:
	docker run --mount type=bind,source=${PWD},target=${MOUNT} -it "${IMAGE}" \
	afl-gcc hello_shape.c
fuzzing:
	mkdir -p out

	docker run --privileged --mount type=bind,source=${PWD},target=${MOUNT} -it "${IMAGE}" \
	bash -c "echo 'core' > /proc/sys/kernel/core_pattern"


	docker run --privileged --mount type=bind,source=${PWD},target=${MOUNT} -it "${IMAGE}" \
	timeout 20s bash -c "afl-fuzz -i in -o out -- ./a.out" || true

	docker run --privileged --mount type=bind,source=${PWD},target=${MOUNT} -it "${IMAGE}" \
	chmod -R +r out/ && echo "DEBUGGING" && ls -l out/


run_docker:
	docker run \
	--mount type=bind,source=${PWD},target=${MOUNT} \
	-it "${IMAGE}" /bin/bash


git:
	git commit -a -m ".."
	git push

clean_docker:
	docker rm  $$(docker ps -q -a)
	docker image prune -a
