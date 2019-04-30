#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow


label: "Biosequence analysis using profile hidden Markov models"

requirements:
  InlineJavascriptRequirement: {}
  SubworkflowFeatureRequirement: {}

inputs:
  input_table:
    type: File
  modification:
    type: string
  expression_echo:
    type: string
  output_name:
    type: string
  current_output_1:
    type: string
  current_output_2:
    type: string

outputs:
  modified_file:
    outputSource: add_title/output
    type: File

steps:
  lattice_modification:
    in:
      table_for_modification: input_table
      inplace: modification
      output_file: current_output_1
    out:
      - output_without_lattice
    run: lattice_modification_table.cwl

  expression_modification:
    in:
      expression: expression_echo
      output_file: current_output_2
    out:
      - output_echo
    run: echo_modification_table.cwl

  add_title:
    in:
      input_1: expression_modification/output_echo
      input_2: lattice_modification/output_without_lattice
      output_file: output_name
    out:
      - output
    run: add_title_modification.cwl

