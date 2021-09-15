#!/usr/bin/env python2
DESCRIPTION = '''

Takes a variant table and converts it to a biallelic fasta file (i.e., each variant site is represented by two columns in the alignment)

NOTE:
	- Will ignore sites with >1 ALT allele (so multiallel sites)
	- Will convert samples with a ploidy of 3 to a ploidy of 2 by collapsing one of the suplicate allelels 
		- I.e., A/A/C -> A/C; A/A/A -> A/A
'''
import sys
import os
import argparse
import logging
import gzip
import re

## Pass arguments.
def main():
	## Pass command line arguments. 
	parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, description=DESCRIPTION)
	parser.add_argument('-i', '--input', metavar='input_SNPs.table', 
		required=False, default=sys.stdin, type=lambda x: File(x, 'r'), 
		help='Input [gzip] variant table file (default: stdin)'
	)
	parser.add_argument('-o', '--out', metavar='input_SNPs.fasta', 
		required=False, default=sys.stdout, type=lambda x: File(x, 'w'), 
		help='Output [gzip] fasta file with 2 character representation of each variant (default: stdout)'
	)
	parser.add_argument('--debug', 
		required=False, action='store_true', 
		help='Print DEBUG info (default: %(default)s)'
	)
	args = parser.parse_args()
	
	## Set up basic debugger
	logFormat = "[%(levelname)s]: %(message)s"
	logging.basicConfig(format=logFormat, stream=sys.stderr, level=logging.INFO)
	if args.debug:
		logging.getLogger().setLevel(logging.DEBUG)
	
	logging.debug('%s', args) ## DEBUG
	
	
	with args.input as infile, args.out as outfile:
		variant_site_zygosity(infile, outfile)



def variant_site_zygosity(infile, outfile):
	variants_total = 0
	variants_biallelic = 0
	
	for CHROM, POS, REF, ALT, VARIANT_FORMAT_FIELDS, SAMPLE_ORDER in parse_variant_table(infile):
		## Add header to output files if this is our first variant line
		if variants_total == 0:
			sample_fasta = {x:'' for x in SAMPLE_ORDER}
		variants_total += 1
		
		## Ignore multiallelic sites
		if ',' in ALT:
			continue
		variants_biallelic += 1
		
		##
		for sample_id in SAMPLE_ORDER:
			GT = re.split('/|\|', VARIANT_FORMAT_FIELDS[sample_id]['GT'])
			GT_str = ''.join(sorted(set(GT))) ## Make set (i.e., uniq), sort values, join together (will either be one or two characters long: A, C, G, T or AC, AG, etc.)
			
			## Check if variant GT_str is homozygus (A, C, G, T) and uncompress into two alleles (AA, CC, GG, TT)
			## If variant GT_str is heterozygus (AC, AG, GT, etc.) then we can just use/append this string directly
			## As we dont allow multiallelic sites then we dont have to wory about any other cases. 
			if len(GT_str) == 1:    # IS homozygous (only one allele)
				if GT_str == 'A':
					sample_fasta[sample_id] += 'AA'
				elif GT_str == 'C':
					sample_fasta[sample_id] += 'CC'
				elif GT_str == 'G':
					sample_fasta[sample_id] += 'GG'
				elif GT_str == 'T':
					sample_fasta[sample_id] += 'TT'
				else:
					sample_fasta[sample_id] += 'NN'
			else:                    # IS heterozygous (has multiple [>1] alleles)
				sample_fasta[sample_id] += GT_str
	for sample_id in SAMPLE_ORDER:
		outfile.write('>' + sample_id + '\n')
		outfile.write(sample_fasta[sample_id] + '\n')
	
	## Print total variants processed/used
	logging.info('Total variants processed: %s', variants_total)
	logging.info('Biallelic variants processed: %s', variants_biallelic)
	logging.info('Multiallelic variants ignored: %s', variants_total-variants_biallelic)


def parse_variant_table(table_file, delim='\t'):
	'''
	Takes a variant table and parses the file and yields each data line (skipping returning the header line).
	Assumes:
		- Pos 1-4: CHROM, POS, REF, ALT
		- Pos 5-:  S1.GT, S1.AD, .., S2.GT, S2.AD, .......
	'''
	
	## Parse header line
	header = table_file.readline().strip().split(delim)
	
	# sample_fields = {S1:{GT:4, AD:5, ..}, S2:{GT:x, AD:x+1, ..}, .......}
	sample_fields = {}
	SAMPLE_ORDER = []
	for i, f in enumerate(header):
		if i < 4: # Ignore if first 4 columns (CHROM, POS, REF, ALT)
			continue
		
		f_split = f.split('.')
		f_sample = ','.join(f_split[:-1])
		f_format_name = f_split[-1]
		
		if f_sample not in SAMPLE_ORDER:
			SAMPLE_ORDER.append(f_sample)
		
		if f_sample not in sample_fields.keys():
			sample_fields[f_sample] = {}
		sample_fields[f_sample][f_format_name] = i
	logging.debug('%s', SAMPLE_ORDER)
	logging.debug('%s', sample_fields)
	
	## Parse variant lines
	for line in table_file:
		line = line.strip()
		if not line or line.startswith('#'):
			continue
		line_split = line.split(delim)
		
		CHROM, POS, REF, ALT = line_split[0:4]
		VARIANT_FORMAT_FIELDS = {}
		for sample_id in sample_fields.keys():
			VARIANT_FORMAT_FIELDS[sample_id] = {}
			for field_id in sample_fields[sample_id].keys():
				VARIANT_FORMAT_FIELDS[sample_id][field_id] = line_split[sample_fields[sample_id][field_id]]
		logging.debug('CHROM:%s, POS:%s, REF:%s, ALT:%s', CHROM, POS, REF, ALT)
		logging.debug('VARIANT_FORMAT_FIELDS:%s', VARIANT_FORMAT_FIELDS)
		
		yield CHROM, POS, REF, ALT, VARIANT_FORMAT_FIELDS, SAMPLE_ORDER



class File(object):
	'''
	Context Manager class for opening stdin/stdout/normal/gzip files.

	 - Will check that file exists if mode='r'
	 - Will open using either normal open() or gzip.open() if *.gz extension detected.
	 - Designed to be handled by a 'with' statement (other wise __enter__() method wont 
	    be run and the file handle wont be returned)
	
	NOTE:
		- Can't use .close() directly on this class unless you uncomment the close() method
		- Can't use this class with a 'for' loop unless you uncomment the __iter__() method
			- In this case you should also uncomment the close() method as a 'for'
			   loop does not automatically cloase files, so you will have to do this 
			   manually.
		- __iter__() and close() are commented out by default as it is better to use a 'with' 
		   statement instead as it will automatically close files when finished/an exception 
		   occures. 
		- Without __iter__() and close() this object will return an error when directly closed 
		   or you attempt to use it with a 'for' loop. This is to force the use of a 'with' 
		   statement instead. 
	
	Code based off of context manager tutorial from: https://book.pythontips.com/en/latest/context_managers.html
	'''
 	def __init__(self, file_name, mode):
		## Upon initializing class open file (using gzip if needed)
		self.file_name = file_name
		self.mode = mode
		
		## Check file exists if mode='r'
		if not os.path.exists(self.file_name) and mode == 'r':
			raise argparse.ArgumentTypeError("The file %s does not exist!" % self.file_name)
	
		## Open with gzip if it has the *.gz extension, else open normally (including stdin)
		try:
			if self.file_name.endswith(".gz"):
				#print "Opening gzip compressed file (mode: %s): %s" % (self.mode, self.file_name) ## DEBUG
				self.file_obj = gzip.open(self.file_name, self.mode+'b')
			else:
				#print "Opening normal file (mode: %s): %s" % (self.mode, self.file_name) ## DEBUG
				self.file_obj = open(self.file_name, self.mode)
		except IOError as e:
			raise argparse.ArgumentTypeError('%s' % e)
	def __enter__(self):
		## Run When 'with' statement uses this class.
		#print "__enter__: %s" % (self.file_name) ## DEBUG
		return self.file_obj
	def __exit__(self, type, value, traceback):
		## Run when 'with' statement is done with object. Either because file has been exhausted, we are done writing, or an error has been encountered.
		#print "__exit__: %s" % (self.file_name) ## DEBUG
		self.file_obj.close()
#	def __iter__(self):
#		## iter method need for class to work with 'for' loops
#		#print "__iter__: %s" % (self.file_name) ## DEBUG
#		return self.file_obj
#	def close(self):
#		## method to call .close() directly on object.
#		#print "close: %s" % (self.file_name) ## DEBUG
#		self.file_obj.close()


if __name__ == '__main__':
	main()
