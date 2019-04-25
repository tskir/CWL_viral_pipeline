#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool


label: "VirFinder"
hints:
  DockerRequirement:
    dockerPull: virfinder:latest

requirements:
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
      glob: output.tsv


$namespaces:
 edam: http://edamontology.org/
 iana: https://www.iana.org/assignments/media-types/
 s: http://schema.org/
$schemas:
 - http://edamontology.org/EDAM_1.16.owl
 - https://schema.org/docs/schema_org_rdfa.html

s:license: "https://www.apache.org/licenses/LICENSE-2.0"
s:copyrightHolder: "EMBL - European Bioinformatics Institute"
