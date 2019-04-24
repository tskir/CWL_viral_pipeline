class: Workflow
cwlVersion: v1.0

requirements:
  SubworkflowFeatureRequirement: {}  
  MultipleInputFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  input_fasta_file:
    type: File

outputs:
  cat-fasta:
    outputSource: virsorter/fastas
    type: array

steps:
  virsorter:
    run: run_virsorter.cwl
    in:
      fasta_file: input_fasta_file
    out:
      - fastas
    label: 'VirSorter: mining viral signal from microbial genomic data'

$namespaces:
 edam: http://edamontology.org/
 iana: https://www.iana.org/assignments/media-types/
 s: http://schema.org/

$schemas:
 - http://edamontology.org/EDAM_1.16.owl
 - https://schema.org/docs/schema_org_rdfa.html

s:license: "https://www.apache.org/licenses/LICENSE-2.0"
s:copyrightHolder: "EMBL - European Bioinformatics Institute"
