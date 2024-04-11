#!/usr/bin/env nextflow

// See the NOTICE file distributed with this work for additional information
// regarding copyright ownership.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Import modules/subworkflows
include { ENA_METADATA_FETCH } from '../modules/enaMetadataFetch.nf'
include { ENA_RAWREADS_FETCH } from '../modules/enaFetch.nf'
include { ENA_ANALYSIS_SUBMIT } from '../modules/enaSubmit.nf'

workflow localDataHub_workflow {
    take:
        metadata_project_id
        submit_project_id
        tax_id
        fileType
        metadata_output
        readFiles_output
        ignore_list
        analysis_output
        analysis_file
        analysis_type
        webin_username
        webin_password
        asynchronous
        test
        analysisConfig_location
        

    main:

        // Execute the metadata fetching process and produce a metadata file with URLs
        metadata_output_ch = ENA_METADATA_FETCH(metadata_project_id, tax_id, fileType, "$PWD/${metadata_output}").each { file -> file.text.readLines()}
        // Parse the metadata file and retrieve the runs along with their corresponding samples and URLs
        metadata_content = metadata_output_ch .splitCsv( header: ['run_accession','sample_accession', 'url'], skip: 1 ).multiMap { it ->
        run_acc: it['run_accession']
        sample_acc: it['sample_accession']
        url: it['url']
        }
        .set{metadata}

        // Execute the file fetching process and produce a metadata file with fetched file names
        rawreads_output_ch = ENA_RAWREADS_FETCH(metadata.url, metadata.run_acc, metadata.sample_acc, fileType, "$PWD/${readFiles_output}",
        "$PWD/${metadata_output}","$PWD/${ignore_list}").each { file -> file.text.readLines()}
        // Parse the metadata file and retrieve the runs along with their corresponding samples and fetched file names
        fetched_metadata_content = rawreads_output_ch .splitCsv( header: ['run_accession','sample_accession', 'file_name'], skip: 1 ).multiMap { it ->
        run_acc: it['run_accession']
        sample_acc: it['sample_accession']
        file_name: it['file_name']
        }
        .set{fetched_metadata}  
        
        /*OPTIONAL: you can retrive the run accession, sample accession and the file name and inject them in the next process by refrencing the following: 
         run accession: fetched_metadata.run_acc
         sample accession: fetched_metadata.sample_acc
         file name: fetched_metadata.file_name
        */
        
        /* EXAMPLE OF THE USER SUB-WORKFLOW : user_output_ch = user_process (fetched_metadata.run_acc, fetched_metadata.sample_acc, fetched_metadata.file_name, otherInputParams).each { file -> file.text.readLines()}
        // Parse the metadata file and retrieve the runs along with their corresponding samples and analysed file names(should be including the relative path)
        fetched_metadata_content = rawreads_output_ch .splitCsv( header: ['run_accession','sample_accession', 'file_name'], skip: 1 ).multiMap { it ->
        run_acc: it['run_accession']
        sample_acc: it['sample_accession']
        analysis_file: it['analysis_file']
        }
        .set{analysed_metadata}  

        **************************************
        The parameters retrieved from the user channel's output can be used as inputs in the submission channel, as follows:
        run accession: analysed_metadata.run_acc
        sample accession: analysed_metadata.sample_acc
        analysis_file: analysed_metadata.file_name

        */


        // Execute the analysed file submitting process
        /*
        in the process below the parameters values for run_accession (analysed_metadata.run_acc), sample accession (analysed_metadata.sample_acc) and analysed file names (analysed_metadata.file_name)
         needs to be considered and changed according to the user sub-workflow
        */
        ena_analysis_submit_ch = ENA_ANALYSIS_SUBMIT(submit_project_id, analysed_metadata.sample_acc, analysed_metadata.run_acc, "$PWD/${analysed_metadata.file_name}",
         analysis_type, webin_username, webin_password, asynchronous, test, "$PWD/${analysis_output}", "$PWD/${analysisConfig_location}")




}