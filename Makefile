export SHELL:=/bin/bash
.ONESHELL:
# NOTE: ONESHELL does not work on current macOS make
export PATH:=$(CURDIR):$(PATH)
# env configs specific to your system
ENV:=env.sh
# use this version of Nextflow
export NXF_VER:=20.10.0
./nextflow:
	. "$(ENV)" ; \
	curl -fsSL get.nextflow.io | bash
install: ./nextflow

# run the benchmark workflow
run:./nextflow
	. "$(ENV)"
	nextflow run main.nf -with-docker "ubuntu:latest" # "$(DOCKERTAG)"

# clean up some files
clean:
	rm -f .nextflow.log.*
	rm -f *.html.*
	rm -f trace.txt.*

clean-all: clean
	rm -f .nextflow.log*
	rm -f *.html
	rm -f trace.txt*
	rm -rf work
	rm -rf output

# interactive shell session with environment populated
bash:
	bash

# build the included Docker container
DOCKERTAG:=benchmarking
build:
	cd container && docker build -t "$(DOCKERTAG)" .

# save the important outputs
LABEL:=
RECORD_DIR:=$(CURDIR)/records
$(RECORD_DIR):
	mkdir -p "$(RECORD_DIR)"
record:$(RECORD_DIR)
	[ -z "$(LABEL)" ] && echo "ERROR: LABEL needs to be defined" && exit 1 || : ; \
	rec_dir="$(RECORD_DIR)/$(LABEL)" ; \
	[ -e "$$rec_dir" ] && echo "ERROR: $$rec_dir already exists" && exit 1 || : ; \
	mkdir -p "$$rec_dir" ; \
	mv nextflow.html "$${rec_dir}/" ; \
	mv timeline.html "$${rec_dir}/" ; \
	mv trace.txt "$${rec_dir}/"
