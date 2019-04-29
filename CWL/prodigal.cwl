#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool


label: "Protein-coding gene prediction for prokaryotic genomes"

requirements:
  DockerRequirement:
    dockerPull: prodigal:latest
  InlineJavascriptRequirement: {}

baseCommand: [prodigal]

inputs:
  viral_cds:
    type: string
    inputBinding:
      separate: true
      prefix: "-a"
  input_fasta:
    type: File
    inputBinding:
      separate: true
      prefix: "-i"
  procedure:
    type: string
    inputBinding:
      separate: true
      prefix: "-p"

stdout: stdout.txt
stderr: stderr.txt

outputs:
  stdout: stdout
  stderr: stderr

  output_fasta:
    type: File
    outputBinding:
      glob: $(inputs.viral_cds)

