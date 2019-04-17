#!/usr/bin/env python3.7

import os
import subprocess
import re
import argparse
import sys
import glob
from Bio import SeqIO

def virus_pred(assembly_file, output_dir, virome_dataset, prok_mode):
	"""Creates fasta file with viral contigs and putative prophages predicted with VirFinder_Euk_Mod and Virsorter"""
	#VirFinder run using the VF.modEPV_k8.rda prediction model for prokaryotic and eukaryotic viruses
	#The output of the script is a file recording the prediction results for all contigs and another file
	#that only includes those results for which fdr < 0.1
	#Input file must contain the dataset ID followed by _ at the beginning of the file name
	#Contigs IDs must be comprised of the dataset ID and a sequential number separated by _
	#if prok_mode:
	#	print("Running VirFinder only for prokaryotic viruses")
	#	subprocess.call("VirFinder_analysis_Prok.R -f %s -o %s" % (assembly_file, output_dir), stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL, shell = True) 
	#else:
	#	print("Running VirFinder for prokaryotic and eukaryotic viruses")
	#	subprocess.call("VirFinder_analysis_Euk.R -f %s -o %s" % (assembly_file, output_dir), stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL, shell = True)
	#Path to directory containing VirSorter's databases
	virsorter_data_path = "/hps/nobackup2/production/metagenomics/garp/databases/virsorter-data"
	#Run VirSorter using the RefSeq + Virome database and the decontamination mode for viral enriched samples
	#if virome_dataset = True, otherwise run VirSorter without desontamination mode
	dataset_id = os.path.basename(assembly_file).split("_")[0]
	virsorter_dir = os.path.join(output_dir, "%s_virsorter" % dataset_id)
	os.mkdir(virsorter_dir)
	if virome_dataset:
		print("Running VirSorter with virome decontamination mode")
		subprocess.call("wrapper_phage_contigs_sorter_iPlant.pl -f %s --db 2 --wdir %s --virome --data-dir %s" % (assembly_file, virsorter_dir, virsorter_data_path), stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL, shell = True)
	else:
		print("Running VirSorter without virome decontamination mode")
		subprocess.call("wrapper_phage_contigs_sorter_iPlant.pl -f %s --db 2 --wdir %s --data-dir %s" % (assembly_file, virsorter_dir, virsorter_data_path), stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL, shell = True)
	#viral_contigs_ids = []
	#viral_contigs_desc = []
	#record_list = []
	#prophage_id = []
	#Save ids and descriptions of contigs predicted as viral by VirFinder (fdr < 0.1)
	#VirFinder_file = os.path.join(output_dir, re.search(r"%s\w+table-sig\.tab" % dataset_id, ",".join(os.listdir(output_dir))).group(0))
	#with open(VirFinder_file) as input_file:
	#	if len(input_file.readlines()) > 1:
	#		input_file.seek(0)
	#		input_file.readline()
	#		for line in input_file:
	#			if line.split(" ")[0] not in viral_contigs_ids:
	#				viral_contigs_ids.append(line.split(" ")[0])
	#				viral_contigs_desc.append("%s_VirFinder" % re.search(r"length_\d+", line).group(0))
	#VirSorter_viral_list = [x for x in glob.glob(os.path.join(virsorter_dir, "Predicted_viral_sequences", "*")) if re.search(r"cat-[12]\.fasta", x)]
	#VirSorter_prophage_list = [x for x in glob.glob(os.path.join(virsorter_dir, "Predicted_viral_sequences", "*")) if re.search(r"cat-[45]\.fasta", x)]
	#Save ids of contigs predicted as viral by VirSorter and that are different from those reported by VirFinder
	#for item in VirSorter_viral_list:
	#	if os.stat(item).st_size != 0:
	#		with open(item) as input_file:
	#			id_search = re.compile(r"%s_\d+" % dataset_id)
	#			prop_search = re.compile(r"(length_\d+)[a-z0-9_-]+(cat_\d)")
	#			for line in input_file:
	#				if id_search.search(line) and id_search.search(line).group(0) not in viral_contigs_ids:
	#					viral_contigs_ids.append(id_search.search(line).group(0))
	#					viral_contigs_desc.append("%s_VirSorter_%s" % (prop_search.search(line).group(1), prop_search.search(line).group(2)))
	#				elif id_search.search(line):
	#					target_index = viral_contigs_ids.index(id_search.search(line).group(0))
	#					viral_contigs_desc[target_index] = viral_contigs_desc[target_index] + "_VirSorter_%s" % re.search(r"cat_\d$", line).group(0)
	#Save ids and SeqRecord objects of putative prophages identified by VirSorter
	#for item in VirSorter_prophage_list:
	#	if os.stat(item).st_size != 0:
	#		for record in SeqIO.parse(item, "fasta"):
	#			record.id = id_search.search(record.id).group(0)
	#			record.description = "%s_VirSorter_%s" % (prop_search.search(record.description).group(1), prop_search.search(record.description).group(2))
	#			prophage_id.append(record.id)
	#			record_list.append(record)
	#Add Pro suffix to ids of prophage SeqRecords and a sequential number if more than one prophage were predicted in the same contig
	#if len(record_list) > 0:
	#	indices = []
	#	for i,j in enumerate(record_list):
	#		if prophage_id.count(j.id) > 1 and i not in indices:
	#			num = 1
	#			j.id = j.id + "-Pro-%s" % num
	#			num += 1
	#			for x in range(i+1, len(record_list)):
	#				if record_list[x].id == re.split("-", j.id)[0]:
	#					record_list[x].id = record_list[x].id + "-Pro-%s" % num
	#					num += 1
	#					indices.append(x)
	#		elif i not in indices:
	#			j.id = j.id + "-Pro"
	#Retrieve SeqRecord objects of viral contigs predicted by VirFinder and VirSorter
	#if len(viral_contigs_ids) > 0:
	#	for position, contig in enumerate(viral_contigs_ids):
	#		for record in SeqIO.parse(assembly_file, "fasta"):
	#			if record.id == contig:
	#				record.description = viral_contigs_desc[position]
	#				record_list.append(record)
	#				break
	#return record_list

if __name__ == "__main__":
	parser = argparse.ArgumentParser(description = "Write fasta file with predicted viral contigs and putative prophages")
	parser.add_argument("-f", "--fasta", dest = "input_file", help = "Assembly fasta file", required = True)
	parser.add_argument("-o", "--outdir", dest = "outdir", help = "output directory", default = ".")
	parser.add_argument("--virome", dest = "virome", action = "store_true", help = "Indicate whether you are processing a metagenomic or viromic dataset")
	parser.add_argument("--prok", dest = "mode", action = "store_true", help = "Indicate whether you would like the pipeline to focus only on prokaryotic viruses")
	if len(sys.argv) == 1:
		parser.print_help()
	else:
		args = parser.parse_args()
		input_file = args.input_file
		#dataset_id = os.path.basename(input_file).split("_")[0]
		#viral_sequences = virus_pred(input_file, args.outdir, args.virome, args.mode)
		#SeqIO.write(viral_sequences, os.path.join(args.outdir, "%s_viral_sequences.fna" % dataset_id), "fasta")
		virus_pred(input_file, args.outdir, args.virome, args.mode)
