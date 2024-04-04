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
include { ENA_RAWREADS_FETCH } from '../modules/enaFetch.nf'
include { ENA_ANALYSIS_SUBMIT } from '../modules/enaSubmit.nf'

workflow localDataHub_workflow {
    take:
        metadata_project_id
        submit_project_id
        tax_id
        fileType
        reads_output
        analysis_output
        sample_list
        run_list
        analysis_file
        analysis_type
        analysis_username
        analysis_password
        asynchronous
        test
        

    main:
        ena_rawreads_fetch_ch = ENA_RAWREADS_FETCH(metadata_project_id, tax_id, fileType, "$PWD/${reads_output}")
        ena_analysis_submit_ch = ENA_ANALYSIS_SUBMIT(submit_project_id, sample_list, run_list, "$PWD/${analysis_file}", analysis_type, analysis_username, analysis_password, asynchronous, test, "$PWD/${analysis_output}")

}

workflow {
    localDataHub_workflow(params.metadata_project_id, params.submit_project_id, params.tax_id, params.fileType, params.sample_list, params.run_list, params.analysis_file, params.analysis_type, params.analysis_username, params.analysis_password, params.asynchronous, params.test, params.reads_output, params.analysis_output)
}