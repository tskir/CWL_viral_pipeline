  prodigal:
    in:
      viral_cds: input_name_output_prophages
      input_fasta: parse_pred_contigs/output_fastas
      procedure: input_prodigal_procedure
    out:
      - output_fasta
    run: prodigal.cwl
    scatter: input_fasta
    label: "Protein-coding gene prediction for prokaryotic genomes"

  hmmscan:
    in:
      domtblout: output_hmmscan
      e_value: evalue_hmmscan
      noali: noali_hmmscan
      database: database_hmmscan
      seqfile: prodigal/output_fasta
    out:
      - output_table
    run: hmmscan.cwl

  processing_hmmscan_result:
    in:
      input_table: hmmscan/output_table
      output_name: name_modification
    out:
      - modified_file
    run: processing_hmm_result.cwl



  output_prodigal:   # INTERMEDIATE OUTPUT
    outputSource: prodigal/output_fasta
    type: File
  output_hmmscan:   # INTERMEDIATE OUTPUT
    outputSource: hmmscan/output_table
    type: File
  output_postprocessing:   # INTERMEDIATE OUTPUT
    outputSource: processing_hmmscan_result/modified_file
    type: File
