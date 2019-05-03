#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow

requirements:
  SubworkflowFeatureRequirement: {}
  MultipleInputFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}
  ScatterFeatureRequirement: {}

inputs:
  fasta_file:
    type: File

  database_hmmscan:
    type: string

  name_modification:  # File postprocessing
    type: string

  outdir_mapping:  # Mapping
    type: string

outputs:
  prodigal_out:
    outputSource: prodigal/output_fasta
    type: File
  hmmscan_out:
    outputSource: hmmscan/output_table
    type: File
  modification_out:
    outputSource: hmm_postprocessing/modified_file
    type: File
  ratio_evalue_table:
    outputSource: ratio_evalue/informative_table
    type: File
  annotation_table:
    outputSource: annotation/annotation_table
    type: File
  mapping_results:
    outputSource: mapping/folder
    type: Directory

steps:
  prodigal:
    label: "Protein-coding gene prediction for prokaryotic genomes"
    in:
      input_fasta: fasta_file
    out:
      - output_fasta
    run: prodigal.cwl

  hmmscan:
    in:
      seqfile: prodigal/output_fasta
      database: database_hmmscan
    out:
      - output_table
    run: hmmscan.cwl

  hmm_postprocessing:
    in:
      input_table: hmmscan/output_table
      output_name: name_modification
    out:
      - modified_file
    run: processing_hmm_result.cwl

  ratio_evalue:
    in:
      input_table: hmm_postprocessing/modified_file
    out:
      - informative_table
    run: ratio_evalue.cwl

  annotation:
    in:
      input_fasta: prodigal/output_fasta
      input_table: ratio_evalue/informative_table
    out:
      - annotation_table
    run: viral_annotation.cwl

  mapping:
    in:
      input_table: annotation/annotation_table
      outdir: outdir_mapping
    out:
      - folder
    run: mapping.cwl
