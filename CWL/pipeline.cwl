class: Workflow
cwlVersion: v1.0

requirements:
  SubworkflowFeatureRequirement: {}  
  MultipleInputFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}
  ScatterFeatureRequirement: {}

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

  outputdir_VS:
    type: string

  input_virsorter_dir:  # Parse files
    type: Directory

  input_name_output_prophages: # Prodigal
    type: string

  output_hmmscan:  # HMMSCAN
    type: string
  database_hmmscan:
    type: string

  name_modification:  # postprocessing
    type: string

  outdir_mapping:
    type: string


outputs:
  output_length_filtering:
    outputSource: length_filter/filtered_contigs_fasta
    type: File
  output_virfinder:
    outputSource: virfinder/output
    type: File
  output_virsorter:
    outputSource: virsorter/output_fasta
    type:
      type: array
      items: File
  output_parse:
    outputSource: parse_pred_contigs/output_fastas
    type:
      type: array
      items: File
  output_parse_stdout:
    outputSource: parse_pred_contigs/stdout
    type: File
  output_parse_stderr:
    outputSource: parse_pred_contigs/stderr
    type: File
  output_prodigal:
    outputSource: subworkflow_for_each_fasta/prodigal_out
    type:
      type: array
      items: File
  output_final:
    outputSource: subworkflow_for_each_fasta/mapping_results
    type:
      type: array
      items: Directory

steps:
  length_filter:
    in:
      fasta_file: input_fasta_file
      length: length_length_filter
      outdir: output_dir_length_filter
      identifier: identifier_length_filter
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
      - output_fastas
      - stdout
      - stderr
    run: parse_viral_pred.cwl

  subworkflow_for_each_fasta:
    in:
      fasta_file: parse_pred_contigs/output_fastas  #array

      input_name_output_prophages: input_name_output_prophages

      output_hmmscan: output_hmmscan
      database_hmmscan: database_hmmscan

      outdir_mapping: outdir_mapping

      name_modification: name_modification
    out:
      - prodigal_out
      - hmmscan_out
      - modification_out
      - ratio_evalue_table
      - annotation_table
      - mapping_results


    scatter: fasta_file
    run: subworkflow_viral_processing.cwl


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
                Prodigal        -- s
                   |    \          u
               HMMscan   \         b
                   |      \        w
            Modification  |        o
                   |      /        r
                   |     /         k
                  Annotation       f
                      |            l
                      |            o
                   Mapping      -- w