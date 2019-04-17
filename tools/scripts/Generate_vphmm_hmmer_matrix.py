#!/usr/bin/env python3.7

import os
import subprocess
import argparse
import re
import pandas as pd
import sys

def hmmer_domtbl(viral_sequence_file, output_dir):
	"""This function takes a fasta file with predicted viral contigs and putative prophage sequences,
	   identifies their putative CDS, compare the corresponding proteins against the ViPhOG HMM database
	   and generates a pandas dataframe that stores the obtained results""" 
	prodigal_path = "/hps/nobackup2/production/metagenomics/garp/software/bin/prodigal"
	hmmscan_path = "/hps/nobackup2/production/metagenomics/garp/software/bin/hmmscan"
	hmm_database_path = "/hps/nobackup2/production/metagenomics/garp/Data/hmmFiles/vpHMM_database"
	dataset_id = os.path.basename(viral_sequence_file).split("_")[0]
	prodigal_output = os.path.join(output_dir, "%s_viral_CDS.faa" % dataset_id)
	hmmer_output = os.path.join(output_dir, "%s_hmmer_ViPhOG.tbl" % dataset_id)
	subprocess.call("%s -a %s -i %s -p meta" % (prodigal_path, prodigal_output, viral_sequence_file), stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL, shell = True)
	subprocess.call("%s --domtblout %s --noali -E 0.001 %s %s" % (hmmscan_path, hmmer_output, hmm_database_path, prodigal_output), stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL, shell = True)
	subprocess.call("sed -i '/^#/d; s/ \+/\t/g' %s" % hmmer_output, shell = True)
	subprocess.call("echo -e 'target name\ttarget accession\ttlen\tquery name\tquery accession\tqlen\tfull sequence E-value\tfull sequence score\tfull sequence bias\t#\tof\tc-Evalue\ti-Evalue\tdomain score\tdomain bias\thmm coord from\thmm coord to\tali coord from\tali coord to\tenv coord from\tenv coord to\tacc\tdescription of target' \
			| cat - %s > /tmp/out && mv /tmp/out %s" % (hmmer_output, hmmer_output), stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL, shell = True)	


if __name__ == "__main__":
	parser = argparse.ArgumentParser(description = "Generate ViPhOG hit table with 0.001 E-value threshold for viral contigs file")
	parser.add_argument("-f", "--fasta", dest = "input_file", help = "Viral and prophage contigs file", required = True)
	parser.add_argument("-o", "-outdir", dest = "output_dir", help = "Output directory for storing hmmer output file", default = ".")
	if len(sys.argv) == 1:
		parser.print_help()
	else:
		args = parser.parse_args()
		input_file = args.input_file
		output_dir = args.output_dir
		hmmer_domtbl(input_file, output_dir)
