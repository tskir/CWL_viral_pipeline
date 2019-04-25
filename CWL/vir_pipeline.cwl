class: Workflow
cwlVersion: v1.0

requirements:
  SubworkflowFeatureRequirement: {}  
  MultipleInputFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  input_fasta_file:  # input assembly
    type: File
  output_dir_length_filter:  # optional for Length Filter
    type: Directory?
  length_length_filter:
    type: int?
  identifier_length_filter:
    type: string?

  output_file_virfinder:  # VirFinder
    type: string

  input_data_dir_virsorter:  # VirSorter
    type: Directory

outputs:
  output_virfinder:
    outputSource: virfinder/output
    type: File
  output_virsorter:
    outputSource: virsorter/output_fasta
    type:
      type: array
      items: File


steps:
  length_filter:
    in:
      fasta_file: input_fasta_file
      length: length_length_filter
      outdir: output_dir_length_filter
      identifier: output_file_virfinder
    out:
      - filtered_contigs_fasta
    run: length_filtering.cwl
  virfinder:
    in:
      fasta_file: length_filter/filtered_contigs_fasta
      output_file: output_file_virfinder
    out:
      - output
    run: run_virfinder.cwl
    label: "VirFinder: R package for identifying viral sequences from metagenomic data using sequence signatures"
  virsorter:
    in:
      fasta_file: length_filter/filtered_contigs_fasta
      data: input_data_dir_virsorter
    out:
      - output_fasta
    run: run_virsorter.cwl
    label: 'VirSorter: mining viral signal from microbial genomic data'


doc: |
  scheme:
      Assembly
         |
      Length filter
         |        \
         |         \
      VirFinder     VirSorter
         |         /
         |        /
      Parsing virus files
