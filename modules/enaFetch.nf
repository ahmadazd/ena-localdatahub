#!/usr/bin/env nextflow

nextflow.enable.dsl=2 

process ENA_RAWREADS_FETCH {
	tag "ENA_RawReads_Fetch"                  
	label 'default'                
	publishDir "$output", mode: 'move' 

    input:
        val project_id
        val tax_id
        val fileType
        path output

    output:
        path "$output/*.fastq*", arity: "0..*", emit: fastq, optional: true
        path "$output/*.bam*", arity: "0..*", emit: bam, optional: true


    script:
    if (project_id != '' & tax_id != '') {
        """
        ena_pathogen_fetch.py -p $project_id -t $tax_id -ft $fileType -o $output
        """
     }
     else if (tax_id == '' ) {
        """
        ena_pathogen_fetch.py -p $project_id -ft $fileType -o $output
        """
     }
    else if (project_id == '' ) {
        """
        ena_pathogen_fetch.py -t $tax_id -ft $fileType -o $output
        """
     }
}
