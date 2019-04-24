#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool


label: "VirSorter"
hints:
  DockerRequirement:
    dockerPull: simroux/virsorter:v1.0.5

requirements:
  InlineJavascriptRequirement: {}

baseCommand: [wrapper_phage_contigs_sorter_iPlant.pl]


inputs:
  fasta_file:
    type: File
    inputBinding:
      separate: true
      prefix: "-f"

  data:
    type: Directory
    inputBinding:
      separate: true
      prefix: "--data-dir"


stdout: stdout.txt
stderr: stderr.txt

outputs:
  stdout: stdout
  stderr: stderr

  output_fasta:
    type:
      type: array
      items: File
    outputBinding:
      glob: virsorter-out/Predicted_viral_sequences/*[1,2,3,4,5].fasta


$namespaces:
 edam: http://edamontology.org/
 iana: https://www.iana.org/assignments/media-types/
 s: http://schema.org/
$schemas:
 - http://edamontology.org/EDAM_1.16.owl
 - https://schema.org/docs/schema_org_rdfa.html

s:license: "https://www.apache.org/licenses/LICENSE-2.0"
s:copyrightHolder: "EMBL - European Bioinformatics Institute"
