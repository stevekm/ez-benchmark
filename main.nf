nextflow.enable.dsl=2
// workflow for running benchmarks on misc tasks

// example params for reading input and output
params.input_file = "input.txt"
params.output_dir = "output"


process sleeper {
    // a process that takes some time to complete
    script:
    """
    sleep 10
    """
}

workflow {
    log.info("----------------")
    log.info("benchmark workflow params:")
    log.info("${params}")
    log.info("----------------")

    sleeper()

}
