#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

label: "Viral contig mapping"

requirements:
  DockerRequirement:
    dockerPull: mapping:latest
  InlineJavascriptRequirement: {}

baseCommand: ['Rscript', '/Make_viral_contig_map.R']

inputs:
  input_table:
    type: File
    inputBinding:
      separate: true
      prefix: "-t"
  outdir:
    type: string
    inputBinding:
      separate: true
      prefix: "-o"

outputs:
  stdout: stdout
  stderr: stderr
  folder:
    type: Directory
    outputBinding:
      glob: $(inputs.outdir)

  #mapping_results:
  #  type:
  #    type: array
  #    items: File
  #  outputBinding:
  #    glob: $(inputs.outdir+"/"+"*.pdf")
