#!/usr/bin/perl
use warnings;
use strict;
use Getopt::Long;
use Data::Dumper; # For debugging

# Arguments
my $blast_output_file = "blast.out";
my $blast_xmloutput_file = "blast_out.xml";
my $options = GetOptions ("in|i=s" => \$blast_output_file);
# Check arguments
if(! -e $blast_output_file) {
    print "Couldn't find -i blast_output_file\n";
    exit;
}

# Sort usearch input file by first two columns in descending order
my $sort_cmd = "sort -rk1,2 -o ".$blast_output_file." ".$blast_output_file;
system($sort_cmd);

# Usearch results
my %usearch_hash;

# Read output into memory
open(my $fh, '<:encoding(UTF-8)', $blast_output_file)
    or die "Could not open file '$blast_output_file' $!";

while (my $row = <$fh>) {
    
    # Remove empty characeters at the end
    chomp $row;
    
    # If current row contains "query", skip it, its a header
    next if $row =~ /^query/;

    # Parse
    my ($query, $target, $bits, $ql, $tl, $qlo, $qhi, $tlo, $thi, $qs, $ts) = split("\t",$row);
    my $value = join("\t",($target, $bits, $ql, $tl, $qlo, $qhi, $tlo, $thi, $qs, $ts));
    
    if(exists $usearch_hash{$query}) {
	my $array = $usearch_hash{$query};
	push @$array, $value; # Dereference array and push on it
    } else {
	$usearch_hash{$query} = [$value];
    }
}
close($fh);

# print Dumper(%usearch_hash);
# Now we have target in key and values as array so we can parse the file according to that order

print("<BlastOutput>\n");

# Keep track of multiple entries for the same pair
my $previous_query = "";
my $previous_target = "";

# Counters
my $iteration_counter = 0;
my $hit_counter = 1;
my $hsp_counter = 1;

# Iterate keys
foreach my $key (keys %usearch_hash) {
    my $line = ${usearch_hash}{$key};
    
    # Iterate values for current key
    my $more_hsp = 0;
    foreach my $val (@$line) {
	my ($target, $bits, $ql, $tl, $qlo, $qhi, $tlo, $thi, $qs, $ts) = split("\t",$val);
	# print $key."\t".$target."\t".$bits."\n";
	# We can access values

	# The same iteration but new hit
	if($previous_query eq $key) {
	    if($previous_query ne $key || $previous_target ne $target ) {
#		print "==========> ".$key." and ".$target."\n";
		$hit_counter++;
		# Next hit
		print("<Hit>\n");
		print("<Hit_num>".$hit_counter."</Hit_num>\n");
		print("<Hit_id>".$target."</Hit_id>\n");
		print("<Hit_def>".$target."</Hit_def>\n");
		print("<Hit_len>".$tl."</Hit_len>\n");
		print("<Hit_hsps>\n");
		$more_hsp = 0;
	    } else {
		$hsp_counter++;
		$more_hsp = 1;
	    }
	    print("<Hsp>\n");
	    print("<Hsp_num>".$hsp_counter."</Hsp_num>\n");
	    print("<Hsp_bit-score>".$bits."</Hsp_bit-score>\n");
	    print("<Hsp_query-from>".$qlo."</Hsp_query-from>\n");
	    print("<Hsp_query-to>".$qhi."</Hsp_query-to>\n");
	    print("<Hsp_hit-from>".$tlo."</Hsp_hit-from>\n");
	    print("<Hsp_hit-to>".$thi."</Hsp_hit-to>\n");
	    my $max = ($ts, $qs)[$ts < $qs]; # Longest sequence is the hsp alignemtn length
	    print("<Hsp_align-len>".$max."</Hsp_align-len>\n");
	    print("<Hsp_qseq>A</Hsp_qseq>\n");
	    if($key eq $target) {
		print("<Hsp_hseq>A</Hsp_hseq>\n");
	    } else {
		print("<Hsp_hseq>B</Hsp_hseq>\n");
	    }
	    print("</Hsp>\n");
	    
	}
	# New iteration
	else {
	    # Bump iteration counter
	    $iteration_counter++;
	    print("<Iteration>\n");
	    print("<Iteration_iter-num>".$iteration_counter."</Iteration_iter-num>\n");
	    print("<Iteration_query-def>".$key."</Iteration_query-def>\n");
	    print("<Iteration_query-len>".$ql."</Iteration_query-len>\n");
	    print("<Iteration_hits>\n");

	    # Set hit counter
	    $hit_counter = 1;
	    $hsp_counter = 1;
	    
	    # First hsp
	    print("<Hit>\n");
	    print("<Hit_num>".$hit_counter."</Hit_num>\n");
	    print("<Hit_id>".$target."</Hit_id>\n");
	    print("<Hit_def>".$target."</Hit_def>\n");
	    print("<Hit_len>".$tl."</Hit_len>\n");
	    print("<Hit_hsps>\n");
	    print("<Hsp>\n");
	    print("<Hsp_num>".$hsp_counter."</Hsp_num>\n");
	    print("<Hsp_bit-score>".$bits."</Hsp_bit-score>\n");
	    print("<Hsp_query-from>".$qlo."</Hsp_query-from>\n");
	    print("<Hsp_query-to>".$qhi."</Hsp_query-to>\n");
	    print("<Hsp_hit-from>".$tlo."</Hsp_hit-from>\n");
	    print("<Hsp_hit-to>".$thi."</Hsp_hit-to>\n");
	    my $max = ($ts, $qs)[$ts < $qs]; # Longest sequence is the hsp alignemtn length
	    print("<Hsp_align-len>".$max."</Hsp_align-len>\n");
	    print("<Hsp_qseq>A</Hsp_qseq>\n");
	    if($key eq $target) {
		print("<Hsp_hseq>A</Hsp_hseq>\n");
	    } else {
		print("<Hsp_hseq>B</Hsp_hseq>\n");
	    }
	    print("</Hsp>\n");
	}
	
	# Set previous iteratation
	$previous_query = $key;
	$previous_target = $target;

	if(! $more_hsp) {
	    print("</Hit_hsps>\n");
	    print("</Hit>\n");
	}
    }
    
    # Close iteration
    print("</Iteration_hits>\n");
    print("</Iteration>\n");
}

print("</BlastOutput>\n");
