#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool


label: "Biosequence analysis using profile hidden Markov models"

requirements:
  InlineJavascriptRequirement: {}
  SubworkflowFeatureRequirement: {}

inputs:
   input_table:
     type: File

outputs:
  output_table:
    type: File
    outputSource: file_modification/modified

steps:
  file_modification:
    in: input_table
    out: [modified]
    run:
      class: CommandLineTool
      baseCommand: [sed -i '/^#/d; s/ \+/\t/g']
      inputs: input_table
      outputs:
        type: File
        outputBinding:
          glob: .
