#!/bin/bash
set -e
set -x

source ${HOME}/VPY_2.7/bin/activate

cd /mnt/TxOne/production/pipeline/

python ${HOME}/software/ngs_pipeline/txone/pipeline/import_data.py panel \
 --customer_id CUSTOMER_ID\
 --external_patient_identifier CASE_ID\
 --internal_patient_identifier CASE_ID\
 --gender GENDER\
 --age AGE\
 --mesh_concept_identifier MESH_ID\
 --disease_stage 'N/A'\
 --prior_treatment 'N/A'\
 --co_medication 'N/A'\
 --barcode BARCODE\
 --date_of_sample_taking 'SAMPLE_DATE as YYYY-MM-DD'\
 --sequencing_type normal\
 --description ''\
 --lib_layout PE\
 --sequencing_platform illumina\
 --reads_file_type ILM1.8\
 --tumor_dir /mnt/TxOne/reads/CASE_ID/tumor\
 --et ETHNICITY

python ${HOME}/software/ngs_pipeline/txone/pipeline/start_analysis.py -b
