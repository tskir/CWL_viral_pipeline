#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand: echo
inputs:
  expression:
    type: string
    inputBinding:
      position: 1
  output_file:
    type: string

stdout: $(inputs.output_file)
outputs:
  output_echo:
    type: File
    outputBinding:
      glob: $(inputs.output_file)