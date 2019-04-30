#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

label: "Viral contig annotation"

requirements:
  DockerRequirement:
    dockerPull: viral_annotation:latest
  InlineJavascriptRequirement: {}

baseCommand: ['python', '/viral_contig_annotation.py']

inputs:
  input_fasta:
    type: File
    inputBinding:
      separate: true
      prefix: "-p"
  input_table:
    type: File
    inputBinding:
      separate: true
      prefix: "-a"
  outdir:
    type: Directory
    inputBinding:
      separate: true
      prefix: "-o"

outputs:
  annotation_table:
    type: File
    outputBinding:
      glob: *