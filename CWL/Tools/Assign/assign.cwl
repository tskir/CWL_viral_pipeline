#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

label: "Viral contig assign"

requirements:
  DockerRequirement:
    dockerPull: assign:latest
  InlineJavascriptRequirement: {}

baseCommand: ['python', '/contig_taxonomic_assign.py']
# arguments: ["-o", "Assign_results"]

inputs:
  input_table:
    type: File
    inputBinding:
      separate: true
      prefix: "-i"

stdout: stdout.txt
stderr: stderr.txt

outputs:
  stdout: stdout
  stderr: stderr

  assign_table:
    type: File
    outputBinding:
      glob: "*tax_assign.tsv"