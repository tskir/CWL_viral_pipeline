#!/usr/bin/env python3.7

import os
import sys
import re
import argparse
import operator
import subprocess
import pandas as pd
from Bio import SeqIO

sys.path.insert(0, "/homes/garp/scripts")

from filter_contigs_len import filter_contigs
from write_viral_predictions import virus_pred
from Generate_vphmm_hmmer_matrix import hmmer_domtbl
from Ratio_Evalue_table import ratio_evalue

parser = argparse.ArgumentParser(description = "Generate gene maps with ViPhOG annotations of putative viral contigs and prophage elements")
parser.add_argument("-f", "--fasta", dest = "input_file", help = "Relative or absolute path of metagenomic assembly fasta file", required = True)
parser.add_argument("-i", "--identifier", dest = "ident", help = "Identifier or accession number associated with your dataset, used for naming the pipeline's output", required = True)
parser.add_argument("-o", "--outdir", dest = "outdir", help = "Relative path to directory where you want the output directory to be stored (default: cwd)", default = ".")
parser.add_argument("-l", "--length", dest = "length", type = float, help = "Length threshold in kb for filtering contigs stored in the assembly file (default: 0.5)", default = "0.5")
parser.add_argument("--virome", dest = "virome", action = "store_true", help = "Use flag to indicate that your dataset was derived from a viral-enriched sample")
parser.add_argument("--prok", dest = "mode", action = "store_true", help = "Use flag to select viral prediction model trained only with prokaryotic viral sequences")

if len(sys.argv) == 1:
	parser.print_help()
else:
	args = parser.parse_args()
	input_file = args.input_file
	dataset_id = args.ident
	length_thres = args.length
	if args.outdir == ".":
		output_dir = os.path.join(os.getcwd(), "%s_viral_prediction" % dataset_id)
	else:
		output_dir = os.path.join(args.outdir, "%s_viral_prediction" % dataset_id)
	os.mkdir(output_dir)
	#Filter the metagenome assembly and retain only those contigs that are at least 1000 bp long
	filter_contigs(contig_file = input_file, thres = length_thres, output_dir = os.path.dirname(input_file), run_id = dataset_id)
	filtered_file_name = re.split(r"\.[a-z]+$", input_file)[0] + "_filt%sbp.fasta" % int(length_thres * 1000)
	if os.stat(filtered_file_name).st_size == 0:
		print("None of the assembled contigs is at least %s kb long" % length_thres)
		os.remove(filtered_file_name)
		sys.exit(0)
	#Detect viral contigs and prophages using function virus_pred (VirFinder + VirSorter)
	predicted_viruses = virus_pred(filtered_file_name, output_dir, args.virome, args.mode)
##	if len(predicted_viruses) < 1:
##		print("No viral contigs or prophages were detected in the analysed metagenome assembly")
##		sys.exit(1)
##	viral_prediction_file = os.path.join(output_dir, "%s_viral_sequences.fna" % dataset_id)
##	SeqIO.write(predicted_viruses, viral_prediction_file, "fasta")
	#Predict proteins encoded in viral sequences and compare them to the ViPhOG database, done by hmmer_domtbl function
##	hmmer_domtbl(viral_prediction_file, output_dir)
##	prodigal_output_file = os.path.join(output_dir, "%s_viral_CDS.faa" % dataset_id)
##	hmmer_output_file = os.path.join(output_dir, "%s_hmmer_ViPhOG.tbl" % dataset_id)
##	ViPhOG_overall_df = pd.read_table(hmmer_output_file)
	#Generate a new table containing only informative hits, model alingment ratios and absolute values of total Evalue exponents
##	informative_df = ratio_evalue(ViPhOG_overall_df)
##	informative_output = os.path.join(output_dir, "%s_informative_ViPhOG.tsv" % dataset_id)
##	informative_df.to_csv(informative_output, sep = "\t", index = False)
	#Generate new table summarizing taxonomic annotation results for each viral protein
##	annotation_list = []
##	for protein in SeqIO.parse(prodigal_output_file, "fasta"):
##		contig_id = re.search(r"[ESR0-9]+_\d+[-Pro]*", protein.id).group(0)
##		protein_prop = protein.description.split(" # ")
##		del(protein_prop[4])
##		if protein_prop[0] in informative_df["query"].values:
##			filtered_df = informative_df[informative_df["query"] == protein_prop[0]]
##			if len(filtered_df) > 1:
##				best_value_index = max(filtered_df["Abs_Evalue_exp"].items(), key = operator.itemgetter(1))[0]
##				protein_prop.extend(list(filtered_df.loc[best_value_index, ["ViPhOG", "Abs_Evalue_exp", "Taxon"]]))
##			else:
##				protein_prop.extend(list(filtered_df.loc[filtered_df.index[0], ["ViPhOG", "Abs_Evalue_exp", "Taxon"]]))
##		else:
##			protein_prop.extend(["No hit", "NA", ""])
##		annotation_list.append([contig_id] + protein_prop)
##	final_map_df = pd.DataFrame(annotation_list, columns = ["Contig", "CDS_ID", "Start", "End", "Direction", "Best_hit", "Abs_Evalue_exp", "Label"])
##	contig_maps_dir = os.path.join(output_dir, "%s_viral_contig_maps" % dataset_id)
##	os.mkdir(contig_maps_dir)
##	table_contig_maps = os.path.join(output_dir, "%s_table_contig_maps.tsv" % dataset_id)
##	final_map_df.to_csv(table_contig_maps, sep = "\t", index = False)
	#Generate gene maps illustrating taxonomic annotation results for each viral contig
##	subprocess.call("Make_viral_contig_map.R -t %s -o %s" % (table_contig_maps, contig_maps_dir), stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL, shell = True)
