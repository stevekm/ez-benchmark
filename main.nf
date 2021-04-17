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

process use_mem {
    //  a process that uses up some memory
    tag "${memsize}"

    input:
    val(memsize)

    script:
    """
    </dev/zero head -c "${memsize}" | tail 
    """
}


process use_cpu {
    // a process that uses a lot of CPU for a certain amount of time
    tag "${duration}"
    validExitStatus 124,0

    input:
    val(duration)

    script:
    """
    timeout "${duration}" md5sum /dev/zero &
    timeout "${duration}" md5sum /dev/zero &
    wait
    """
}

workflow {
    log.info("----------------")
    log.info("benchmark workflow params:")
    log.info("${params}")
    log.info("----------------")

    sleeper()

    mem_sizes = Channel.from([ "5m", "50m", "250m" ])
    use_mem(mem_sizes)

    durations = Channel.from([ "10", "30", "60" ])
    use_cpu(durations)

}
