#!/usr/bin/env nextflow

nextflow.enable.dsl=2 

process ENA_RAWREADS_FETCH {
	tag "ENA_RawReads_Fetch"                  
	label 'default'                
	//publishDir "$readFiles_output", mode: 'move' 

    input:
        val url
        val run_id
        val sample_id
        val fileType
        path readFiles_output
        path metadata_output
        path ignore_list

    output:
        path "$readFiles_output/*.fastq*", arity: "0..*", emit: fastq, optional: true
        path "$readFiles_output/*.bam*", arity: "0..*", emit: bam, optional: true
        path "$metadata_output/fetchedFiles_metadata.txt", emit: metadata_logs, optional: true


    script:
        """
        fetchReads.py -url '$url' -r $run_id -s $sample_id -ft $fileType -o $readFiles_output -log $metadata_output -i $ignore_list 
        """
}
