#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand: sed
inputs:
  table_for_modification:
    type: File
    inputBinding:
      separate: true
      position: 2
  inplace:
    type: string
    inputBinding:
      separate: true
  output_file:
    type: string

stdout: $(inputs.output_file)
outputs:
  output_without_lattice:
    type: File
    outputBinding:
      glob: $(inputs.output_file)