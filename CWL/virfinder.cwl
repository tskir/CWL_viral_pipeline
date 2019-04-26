#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool


label: "VirFinder is a method for finding viral contigs from de novo assemblies."

requirements:
  DockerRequirement:
    dockerPull: virfinder:latest
  InlineJavascriptRequirement: {}

baseCommand: [run_virfinder.Rscript]

inputs:
  fasta_file:
    type: File
    inputBinding:
      separate: true

  output_file:
    type: string
    inputBinding:
      separate: true

stdout: stdout.txt
stderr: stderr.txt

outputs:
  stdout: stdout
  stderr: stderr

  output:
    type: File
    outputBinding:
      glob: $(inputs.output_file)


doc: |
  usage: Rscript run_virfinder.Rscript <input.fasta> <output.tsv>