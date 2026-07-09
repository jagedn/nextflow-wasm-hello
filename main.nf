nextflow.enable.dsl=2

process PROCESO_DOCKER {
    container 'ubuntu:latest'
    // containerEngine 'docker' // No hace falta ponerlo, es el defecto por herencia

    output:
    path 'input_data.txt'

    script:
    """
    echo "Generando datos pesados desde un contenedor Docker tradicional..."
    echo "Muestra_A,Muestra_B,Muestra_C" > input_data.txt
    """
}

process PROCESO_WASM {
    containerEngine 'wasm' 
    container 'ttl.sh/mi-app-spin-filtrado:1h' // La referencia a tu componente de SpinKube

    input:
    val muestra

    output:
    stdout

    script:
    """
    --filtrar-muestra ${muestra}
    """
}

workflow {
    // 1. Ejecutamos la tarea pesada en Docker
    def datos_ch = PROCESO_DOCKER()

    // 2. Separamos el resultado en elementos individuales para procesar en paralelo
    def muestras_ch = datos_ch
        .splitText() { it.trim().split(',') }
        .flatten()

    // 3. Lanzamos miles (aquí 3) de micro-tareas concurrentes en Wasm/SpinKube
    PROCESO_WASM(muestras_ch) | view
}
