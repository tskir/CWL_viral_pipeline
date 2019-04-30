#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand: cat
inputs:
  input_1:
    type: File
    inputBinding:
      position: 1
  input_2:
    type: File
    inputBinding:
      position: 2
  output_file:
    type: string

stdout: $(inputs.output_file)
outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.output_file)