#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

label: "Viral contig annotation"

requirements:
  DockerRequirement:
    dockerPull: annotation:latest
  InlineJavascriptRequirement: {}

baseCommand: ['python', '/viral_contigs_annotation.py']
arguments: ["-o", $(runtime.outdir)]

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
      prefix: "-t"

outputs:
  annotation_table:
    type: File
    outputBinding:
      glob: Viral_protein_annotation_table.tsv