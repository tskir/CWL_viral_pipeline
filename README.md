# CWL_viral_pipeline

# Running full pipeline from CLI

# Structure of pipeline
**Input**: assembly file NAME.fasta

**1. Filtering contigs** <br>
Filter contigs by length threshold in kb (default: 5kb). <br>
     ***Input***: NAME.fasta <br>
     ***Output***: NAME_filt500bp.fasta 
   
**2.1. VirSorter** <br>
Mining viral signal from microbial genomic data. Tool generates folder *Predicted_viral_sequences* (relevant are VIRSorter_cat-[123].fasta and VIRSorter_prophages_cat-[45].fasta). <br>
     ***Input***: NAME_filt500bp.fasta <br>
     ***Output***: Predicted_viral_sequences
     
**2.2. VirFinder** <br>
R package for identifying viral sequences from metagenomic data using sequence signatures. <br>
     ***Input***: NAME_filt500bp.fasta <br>
     ***Output***: VirFinder_output.tsv
     
**3. Parsing virus files**   
According of results on previous steps script generates High_confidence, Low_confidence and Prophages files. Some of output files may be missing. <br>
     ***Input***: <br>
                  - NAME_filt500bp.fasta <br>
                  - VirFinder_output.tsv <br>
                  - Predicted_viral_sequences <br>
     ***Output***: <br>
                  - High_confidence.fna <br>
                  - Low_confidence.fna <br>
                  - Prophages.fna
                  
**4. Prodigal** <br>
Tool predicts proteins for each input fasta-file. <br>
     ***Input***: output files of step #3  <br>
                  - High_confidence.fna <br>
                  - Low_confidence.fna <br>
                  - Prophages.fna <br>
     ***Output***: <br>
                  - High_confidence_prodigal.faa <br>
                  - Low_confidence_prodigal.faa <br>
                  - Prophages_prodigal.faa
    
**5. HMMSCAN** <br>
HMMSCAN is used to search protein sequences against collections of protein profiles. <br>
    ***Input***: output files of step #4  <br>
                  - High_confidence_prodigal.faa <br>
                  - Low_confidence_prodigal.faa <br>
                  - Prophages_prodigal.faa <br>
    ***Output***:  <br>
                  - High_confidence_prodigal_hmmscan.tbl <br>
                  - Low_confidence_prodigal_hmmscan.tbl <br>
                  - Prophages_prodigal_hmmscan.tbl <br>
                  
**6. Table(s) processing** <br>
Scripts add titles to columns and separate columns with tabs. <br>
    ***Input***: <br>
                  - High_confidence_prodigal_hmmscan.tbl <br>
                  - Low_confidence_prodigal_hmmscan.tbl <br>
                  - Prophages_prodigal_hmmscan.tbl <br>
    ***Output***: <br>
                  - High_confidence_prodigal_hmmscan_modified.faa <br>
                  - Low_confidence_prodigal_hmmscan_modified.faa <br>
                  - Prophages_prodigal_hmmscan_modified.faa <br>
        
**7. Ratio evalue table** <br>
Generates tabular file (File_informative_ViPhOG.tsv) listing results per protein, which include the ratio of the aligned target profile and the abs value of the total Evalue. <br>
    ***Input***: <br>
                  - High_confidence_prodigal_hmmscan_modified.faa <br>
                  - Low_confidence_prodigal_hmmscan_modified.faa <br>
                  - Prophages_prodigal_hmmscan_modified.faa <br>
    ***Output***: <br>
                  - High_confidence_prodigal_hmmscan_modified_informative.tsv <br>
                  - Low_confidence_prodigal_hmmscan_modified_informative.tsv <br>
                  - Prophages_prodigal_hmmscan_modified_informative.tsv <br>


**8. Annotation** <br>
Script generates tabular output for each viral prediction file which summarizes the ViPhOG annotations for all the corresponding predicted proteins. <br>
    ***Input***: <br>
                  - High_confidence.fna <br>
                  - High_confidence_prodigal_hmmscan_modified_informative.tsv <br>
                  - High_confidence.fna <br>
                  - Low_confidence.fna <br>
                  - Low_confidence_prodigal_hmmscan_modified_informative.tsv <br>
                  - Low_confidence.fna <br>
                  - Prophages.fna <br>
                  - Prophages_prodigal_hmmscan_modified_informative.tsv <br>
                  - Prophages.fna <br>
   ***Output***: <br>           
                  - High_confidence_prodigal_hmmscan_modified_informative_prot_ann_table.tsv <br>
                  - Low_confidence_prodigal_hmmscan_modified_informative_prot_ann_table.tsv <br>
                  - Prophages_prodigal_hmmscan_modified_informative_prot_ann_table.tsv <br>

**9.1. Mapping** <br>
Script creates an output directory for each viral prediction file and generates contig maps for each viral contig in pdf format, which are then stored in the created output director. <br>
   ***Input***: <br>           
                  - High_confidence_prodigal_hmmscan_modified_informative_prot_ann_table.tsv <br>
                  - Low_confidence_prodigal_hmmscan_modified_informative_prot_ann_table.tsv <br>
                  - Prophages_prodigal_hmmscan_modified_informative_prot_ann_table.tsv <br>
  ***Output***: <br>           
                  - High_confidence_mapping_results <br>
                  - Low_confidence_mapping_results <br>
                  - Prophages_mapping_results <br>
                  
**9.2. Assign taxonomy** <br>
Script generates tabular file with taxonomic assignment of viral contigs based on ViPhOG annotations.<br>
   ***Input***: <br>           
                  - High_confidence_prodigal_hmmscan_modified_informative_prot_ann_table.tsv <br>
                  - Low_confidence_prodigal_hmmscan_modified_informative_prot_ann_table.tsv <br>
                  - Prophages_prodigal_hmmscan_modified_informative_prot_ann_table.tsv <br>
   ***Output***: <br>
                  - High_confidence_prodigal_hmmscan_modified_informative_prot_ann_table_tax_assign.tsv <br>
                  - Low_confidence_prodigal_hmmscan_modified_informative_prot_ann_table_tax_assign.tsv <br>
                  - Prophages_prodigal_hmmscan_modified_informative_prot_ann_table_tax_assign.tsv <br>
  
```
          Assembly
             |
          Length filter
             |        \
             |         \
          VirFinder  VirSorter
             |         /
             |        /
          Parsing virus files
                   |
                   |
                Prodigal             -- S
                   |    \               u
               HMMscan   \              b
                   |      \             W
            Modification   |            o
                   |      /             r
                   |     /              k
                  Annotation            F
                     |    \             l
                     |     \            o
                  Mapping   Assign   -- w
                                              
```

# Example output directory structure
```

```
