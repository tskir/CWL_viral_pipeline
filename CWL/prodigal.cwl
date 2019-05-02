#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool


label: "Protein-coding gene prediction for prokaryotic genomes"

requirements:
  DockerRequirement:
    dockerPull: prodigal:latest
  InlineJavascriptRequirement: {}

baseCommand: [prodigal]
arguments: ["-p", "meta"]
arguments:
  - prefix: -a
    valueFrom: $(inputs.input_fasta.nameroot)_prodigal.faa

inputs:
  input_fasta:
    type: File
    inputBinding:
      separate: true
      prefix: "-i"

stdout: stdout.txt
stderr: stderr.txt

outputs:
  stdout: stdout
  stderr: stderr

  output_fasta:
    type: File
    outputBinding:
      glob: "*_prodigal.faa"

