nextflow.enable.dsl=2

process PROCESO_WASM {
    container 'ghcr.io/fermyon/wasm-pkg/fermyon/hello-world:1.0.0'
    ext containerEngine: 'wasm'

    input:
    val muestra

    output:
    stdout

    script:
    """
    returning ${muestra}
    """
}

workflow {
    def canal_entrada = channel.of('Hola', 'Mundo')
    PROCESO_WASM(canal_entrada) | view
}
