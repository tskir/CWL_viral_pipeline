class: Workflow
cwlVersion: v1.0

requirements:
  SubworkflowFeatureRequirement: {}  
  MultipleInputFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  input_fasta_file:
    type: File
  input_data_dir_virsorter:
    type: Directory
  output_file_virfinder:
    type: string

outputs:
  output_fastas:
    outputSource: virsorter/output_fasta
    type:
      type: array
      items: File
  output_tsv:
    outputSource: virfinder/output
    type: File

steps:

  virfinder:
    run: run_virfinder.cwl
    in:
      fasta_file: input_fasta_file
      output_file: output_file_virfinder
    out:
      - output
    label: "VirFinder: R package for identifying viral sequences from metagenomic data using sequence signatures"

  virsorter:
    run: run_virsorter.cwl
    in:
      fasta_file: input_fasta_file
      data: input_data_dir_virsorter
    out:
      - output_fasta
    label: 'VirSorter: mining viral signal from microbial genomic data'


$namespaces:
 edam: http://edamontology.org/
 iana: https://www.iana.org/assignments/media-types/
 s: http://schema.org/

$schemas:
 - http://edamontology.org/EDAM_1.16.owl
 - https://schema.org/docs/schema_org_rdfa.html

s:license: "https://www.apache.org/licenses/LICENSE-2.0"
s:copyrightHolder: "EMBL - European Bioinformatics Institute"
