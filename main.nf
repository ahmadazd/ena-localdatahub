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
nextflow.enable.dsl=2

//default params
params.help = false

// mandatory params
params.metadata_project_id = ''
params.submit_project_id = null
params.tax_id = ''
params.fileType = null
params.reads_output = null
params.analysis_logs_output = null
params.sample_list = null
params.run_list = null
params.analysis_file = null
params.analysis_type = null
params.analysis_username = null
params.analysis_password = null
params.asynchronous = false
params.test = true

// Print usage
def helpMessage() {
  log.info """
        Usage:
        The typical command for running the pipeline is as follows:
        nextflow run pipeline/workflow/drag_and_drop_workflow/drag_and_drop_workflow.nf  --webin_account <webin account id> --webin_password <webin account password>  --context <reads/genome> --mode <validate/submit> --senderEmail_password <email password> --environment <test/prod>

        Add the <sender_email> and <rec_email> value in the nextflow.config file

        Mandatory arguments:
        --project_id                    Project accession number 
        --tax_id                        Tax Id or scientific name
        --fileType                      The downloaded file type (fastq or bam)
        --reads_output                  The path for the reads output files
        --analysis_logs_output          The path for the analysis output logs
        --sample_list                   Sample accessions
        --run_list                      Run accessions
        --analysis_file                 The path for the analysis files
        --analysis_type                 The analysis type
        --analysis_username             The webin account to submit the analysis  
        --analysis_password             The password for the webin account

        Optional arguments:
        --help                         This usage statement.
        --asynchronous                 Default false 
        --test                         Default true
        """
}

// Show help message
if (params.help) {
    helpMessage()
    exit 0
}

assert params.submit_project_id, "Parameter 'submit_project_id' is not specified"
assert params.fileType, "Parameter 'fileType' is not specified"
assert params.reads_output, "Parameter 'reads_output' is not specified"
assert params.analysis_logs_output, "Parameter 'analysis_logs_output' is not specified"
assert params.sample_list, "Parameter 'sample_list' is not specified"
assert params.run_list, "Parameter 'run_list' is not specified"
assert params.analysis_file, "Parameter 'analysis_file' is not specified"
assert params.analysis_type, "Parameter 'analysis_type' is not specified"
assert params.analysis_username, "Parameter 'analysis_username' is not specified"
assert params.analysis_password, "Parameter 'analysis_password' is not specified"


// Import modules/subworkflows
include { localDataHub_workflow } from './workflow/workflow.nf'

// Run main workflow
workflow {
    main:
    localDataHub_workflow(params.metadata_project_id, params.submit_project_id, params.tax_id, params.fileType, params.reads_output, params.analysis_logs_output, params.sample_list, params.run_list, params.analysis_file, params.analysis_type, params.analysis_username, params.analysis_password, params.asynchronous, params.test)
    
}