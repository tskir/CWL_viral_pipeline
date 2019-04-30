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
    type: float?
  identifier_length_filter:
    type: string?

  output_file_virfinder:  # VirFinder
    type: string

  input_data_dir_virsorter:  # VirSorter
    type: Directory

  input_virsorter_dir:  # Parse files
    type: Directory

  input_prodigal_procedure:  # Prodigal
    type: string
  input_name_output_prophages:
    type: string

  output_hmmscan:  # HMMSCAN
    type: string
  evalue_hmmscan:
    type: float
  noali_hmmscan:
    type: boolean
  database_hmmscan:
    type: string



outputs:
  output_virfinder:  # INTERMEDIATE OUTPUT
    outputSource: virfinder/output
    type: File
  output_virsorter:   # INTERMEDIATE OUTPUT
    outputSource: virsorter/output_fasta
    type:
      type: array
      items: File
  output_parse:   # INTERMEDIATE OUTPUT
    outputSource: parse_pred_contigs/output_high_conf
    type: File?
  output_parse:   # INTERMEDIATE OUTPUT
    outputSource: parse_pred_contigs/output_low_conf
    type: File?
  output_parse:   # INTERMEDIATE OUTPUT
    outputSource: parse_pred_contigs/output_prophages
    type: File?
  output_parse_stdout:
    outputSource: parse_pred_contigs/stdout
    type: File
  output_parse_stderr:
    outputSource: parse_pred_contigs/stderr
    type: File
  output_prodigal:   # INTERMEDIATE OUTPUT
    outputSource: prodigal_prophages/output_fasta
    type: File
  output_hmmscan:   # INTERMEDIATE OUTPUT
    outputSource: hmmscan/output_table
    type: File


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
    run: virfinder.cwl
    label: "VirFinder: R package for identifying viral sequences from metagenomic data using sequence signatures"

  virsorter:
    in:
      fasta_file: length_filter/filtered_contigs_fasta
      data: input_data_dir_virsorter
    out:
      - output_fasta
    run: virsorter.cwl
    label: "VirSorter: mining viral signal from microbial genomic data"

  parse_pred_contigs:
    in:
      assembly: length_filter/filtered_contigs_fasta
      virfinder_tsv: virfinder/output
      virsorter_dir: input_virsorter_dir
    out:
      - output_high_conf?
      - output_low_conf?
      - output_prophages?
      - stdout
      - stderr
    run: parse_viral_pred.cwl

  prodigal_prophages:
    in:
      viral_cds: input_name_output_prophages
      input_fasta: parse_pred_contigs/output_prophages
      procedure: input_prodigal_procedure
    out:
      - output_fasta
    run: prodigal.cwl
    label: "Protein-coding gene prediction for prokaryotic genomes"

  hmmscan:
    in:
      domtblout: output_hmmscan
      e_value: evalue_hmmscan
      noali: noali_hmmscan
      database: database_hmmscan
      seqfile: prodigal_prophages/output_fasta
    out:
      - output_table
    run: hmmscan.cwl





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
                   |
                   |
                Prodigal
                   |    \
               HMMscan   \
                   |      \
            Modification  |
                   |      /
                   |     /
                  Annotation
                      |
                      |
                   Mapping