# ez-benchmark

Benchmarking template for measuring program CPU usage, memory, etc.

# Usage

First, clone this repository;

```
git clone https://github.com/stevekm/ez-benchmark.git
cd ez-benchmark
```

Put the commands to run your program inside a Nextflow [`process`](https://www.nextflow.io/docs/latest/process.html) in the `main.nf`. Some example processes have been included already.

Put any system specific environment configurations you might need for your programs to run inside `env.sh`.

Run the workflow with `make run`. Should look something like this;

```
$ make run
. "env.sh"
nextflow run main.nf -with-docker "ubuntu:latest"
N E X T F L O W  ~  version 20.10.0
Launching `main.nf` [maniac_morse] - revision: 7d472081fa
----------------
benchmark workflow params:
[input_file:input.txt, output_dir:output]
----------------
executor >  local (7)
[94/080e62] process > sleeper        [100%] 1 of 1 ✔
[2e/f4a06c] process > use_mem (250m) [100%] 3 of 3 ✔
[a5/f32794] process > use_cpu (60)   [100%] 3 of 3 ✔

Completed at: 17-Apr-2021 11:18:24
Duration    : 1m 5s
CPU hours   : (a few seconds)
Succeeded   : 7
```

The output should include two files;
- `trace.txt`: text table listing the execution metrics of each task
- `nextflow.html`: HTML report with graphs showing the system resource usages of the tasks

# Software

This template uses the [Nexflow](https://www.nextflow.io/) workflow framework, which requires `bash` and Java 8+. Docker is used in this example to ensure that all required metrics are available on systems such as macOS which lack procfs.
