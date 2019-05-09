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
  assign_results:
    outputSource: assign/assign_table
    type: File

steps:
  prodigal:
    label: "Protein-coding gene prediction for prokaryotic genomes"
    in:
      input_fasta: fasta_file
    out:
      - output_fasta
    run: ../Tools/Prodigal/prodigal.cwl

  hmmscan:
    in:
      seqfile: prodigal/output_fasta
    out:
      - output_table
    run: ../Tools/HMMScan/hmmscan.cwl

  hmm_postprocessing:
    in:
      input_table: hmmscan/output_table
    out:
      - modified_file
    run: ../Tools/Modification/processing_hmm_result.cwl

  ratio_evalue:
    in:
      input_table: hmm_postprocessing/modified_file
    out:
      - informative_table
    run: ../Tools/RatioEvalue/ratio_evalue.cwl

  annotation:
    in:
      input_fasta: prodigal/output_fasta
      input_table: ratio_evalue/informative_table
      input_fna: fasta_file
    out:
      - annotation_table
    run: ../Tools/Annotation/viral_annotation.cwl

  mapping:
    in:
      input_table: annotation/annotation_table
    out:
      - folder
    run: ../Tools/Mapping/mapping.cwl

  assign:
    in:
      input_table: annotation/annotation_table
    out:
      - assign_table
    run: ../Tools/Assign/assign.cwl