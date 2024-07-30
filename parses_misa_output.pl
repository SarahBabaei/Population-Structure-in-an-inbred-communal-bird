#!/usr/bin/perl
use warnings;
use strict;

# This script will parse output files from the program misa 
# It will print to an output file the names of the microsats
# that have certain criteria (length and positioon in sequence) 

# execute this script in a directory like this: "perl parses_misa_output.pl"

# First generate an output file to which we will print the
# names of the good microsatellites.
# Later we can use this file to extract the sequences for each 
# of these microsats 
my $outputfile = "good_micros.txt";
unless (open(OUTFILE, "> $outputfile"))  {
	print "I can\'t write to $outputfile   $!\n\n";
	exit;
}
print "Creating output file: $outputfile\n";

# define variables to use for filtering results
my $max_repeats_allowed = 8;
my $min_repeats_allowed = 4;
my $min_flanking_size = 40;

# define variables to use in parsing
my @files; 
my $lines=0;
my $length;
my $type;
my $micro_start;
my $micro_end;
my @temp;
my @temp1;

# print the header of the data we are extracting to screen
print "name\tseq_length\tmicro_start\tmicro_end\tnum_repeats\n";
# also print this header to our output file
print OUTFILE "name\tseq_length\tmicro_start\tmicro_end\tnum_repeats\n";

# read in all the names of files in a directory that befin with 'E00386'
@files = glob("E00386*");

# cycle through each file, check the length, and check if it has a 
# microsat that is the correct number of repeats
foreach(@files){
	# open the file
	unless (open DATAINPUT, $_) {
		print "Can not find the data input file!\n";
		exit;
	}
	# look at each line of the file
	while ( my $line = <DATAINPUT>) {
		# put the values of the line in an array called @temp using a whitespace separator
		@temp = split(/\s+/,$line);
		# check if we are on line # 5 - this has details about the length of the sequence
	    if($lines == 5){ 
			$length = $temp[4]; # this is the length of the sequence
	    }
	    # check if we are on line # 6 - this has information on the (first) microsat
	    if($lines == 6){ 
			$type = $temp[2]; # this is the type of repeat (microsat or repeat)
			$micro_start = $temp[3]; # this is where the microsat starts in the sequence
			$micro_end = $temp[4]; # this is where the microsat ends in the sequence
			@temp1 = split(/[);]/,$temp[8]); # this allows us to determine how many repeats are in the microsat
	    }
	    # count each line
	    $lines +=1;
		# check length of file
	} # end while
	close DATAINPUT;
	if($lines == 7){ # ignore any seqs with more than one micro; these have a longer file tseq_length
		# only print to screen and the output file the mmicrosats that have characteristics we want
		if(($type eq 'microsatellite') && ($micro_start >= $min_flanking_size) && (($length-$micro_end) >= $min_flanking_size) && 
			($temp1[1] <= $max_repeats_allowed) && ($temp1[1] >= $min_repeats_allowed)) {
			print $_,"\t",$length,"\t",$micro_start,"\t",$micro_end,"\t",$temp1[1],"\n";
			print OUTFILE $_,"\t",$length,"\t",$micro_start,"\t",$micro_end,"\t",$temp1[1],"\n";
		}
	}
	# reset $line variable so it can be used in the next file
	$lines=0;
} # end of cycling though each file
# close the output file
close OUTFILE;