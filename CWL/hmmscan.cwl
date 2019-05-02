#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool


label: "Biosequence analysis using profile hidden Markov models"

requirements:
  DockerRequirement:
    dockerPull: hmmscan:latest
  InlineJavascriptRequirement: {}

baseCommand: ["hmmscan"]
arguments: ["-E", "0.001", "--noali"]
arguments:
  - prefix: --domtblout
    valueFrom: $(inputs.seqfile.nameroot)_hmmscan.tbl

inputs:
  database:
    type: string
    inputBinding:
      position: 4
      separate: true
  seqfile:
    type: File
    inputBinding:
      position: 5
      separate: true


stdout: stdout.txt
stderr: stderr.txt

outputs:
  stdout: stdout
  stderr: stderr

  output_table:
    type: File
    outputBinding:
      glob: "*hmmscan.tbl"