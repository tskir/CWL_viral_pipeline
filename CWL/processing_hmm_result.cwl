#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow


label: "Post processing hmmscan output"

requirements:
  InlineJavascriptRequirement: {}
  SubworkflowFeatureRequirement: {}

inputs:
  input_table:
    type: File
  output_name:
    type: string

outputs:
  modified_file:
    outputSource: add_title/output
    type: File

steps:
  tab_modification:
    in:
      table_for_modification: input_table
    out:
      - output_without_lattice
    run: modification_table.cwl

  expression_modification:
    in: []
    out:
      - output_echo
    run: echo_modification_table.cwl

  add_title:
    in:
      input_1: expression_modification/output_echo
      input_2: tab_modification/output_without_lattice
      output_file: output_name
    out:
      - output
    run: add_title_modification.cwl

