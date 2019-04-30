#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool


label: "Biosequence analysis using profile hidden Markov models"

requirements:
  DockerRequirement:
    dockerPull: hmmscan:latest
  InlineJavascriptRequirement: {}

baseCommand: ["hmmscan"]

inputs:
  domtblout:
    type: string
    inputBinding:
      position: 1
      separate: true
      prefix: "--domtblout"
  e_value:
    type: float
    inputBinding:
      position: 2
      separate: true
      prefix: "-E"
  noali:
    type: boolean
    inputBinding:
      position: 3
      separate: true
      prefix: "--noali"
  database:
    type: File
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
      glob: $(inputs.domtblout)