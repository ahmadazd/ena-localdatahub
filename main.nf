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
params.metadata_output = 'logs'
params.readFiles_output = 'rawReadsFiles'
params.analysis_logs_output = 'logs'
params.ignore_list = 'ignore_list.txt'
params.analysis_type = null
params.webin_username = null
params.webin_password = null
params.asynchronous = false
params.test = true
params.analysisConfig_location = 'conf'


// Print usage
def helpMessage() {
  log.info """
        Usage:
        The typical command for running the pipeline is as follows:
        nextflow run 

        Mandatory arguments:
        --project_id                    Project accession number 
        --tax_id                        Tax Id or scientific name
        --fileType                      The downloaded file type (fastq or bam)
        --ignore_list
        --analysis_type                 The analysis type
        --webin_username                The webin account to submit the analysis  
        --webin_password                The password for the webin account

        Optional arguments:
        --help                         This usage statement.
        --asynchronous                 Default false 
        --test                         Default true
        --metadata_output              Default logs
        --readFiles_output             The directory name for the reads output files, default rawReadsFiles
        --analysis_logs_output         The directory name for the analysis output logs, default logs
        --analysisConfig_location      The directory for the analysis config file, default conf
        --ignore_list                  Name of the ignore list file that contains the list of the runs to be excluded from fetching, defult ignore_list.txt
        """
}

// Show help message
if (params.help) {
    helpMessage()
    exit 0
}

assert params.submit_project_id, "Parameter 'submit_project_id' is not specified"
assert params.fileType, "Parameter 'fileType' is not specified"
assert params.metadata_output, "Parameter 'metadata_output' is not specified"
assert params.readFiles_output, "Parameter 'readFiles_output' is not specified"
assert params.analysis_logs_output, "Parameter 'analysis_logs_output' is not specified"
assert params.analysis_type, "Parameter 'analysis_type' is not specified"
assert params.webin_username, "Parameter 'analysis_username' is not specified"
assert params.webin_password, "Parameter 'analysis_password' is not specified"
assert params.analysisConfig_location, "Parameter 'analysisConfig_location' is not specified"
assert params.ignore_list, "Parameter 'ignore_list' is not specified"


// Import modules/subworkflows
include { localDataHub_workflow } from './workflow/workflow.nf'

// Run main workflow
workflow {
    main:
    localDataHub_workflow(params.metadata_project_id, params.submit_project_id, params.tax_id, params.fileType,params.metadata_output, 
    params.readFiles_output, params.ignore_list, params.analysis_logs_output, params.analysis_type, params.webin_username,
    params.webin_password, params.asynchronous, params.test, params.analysisConfig_location)
    
}