nextflow.enable.dsl=2

process PROCESO_WASM {
    ext.containerEngine 'wasm'
    container 'ghcr.io/fermyon/spin-command-rust-fixtures:v0.1.0'

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
    PROBAR_WASM(canal_entrada) | view
}
