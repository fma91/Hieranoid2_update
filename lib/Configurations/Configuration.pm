########################################################################
# Script name  :    Configuration.pm
#
# Date created :    December 2011
#
# Author       :    Fabian Schreiber <fab.schreiber@gmail.com>
#
# Modified by  :    Mateusz Kaduk <mateusz.kaduk@gmail.com>
# 
# This is the configuration file for Hieranoid
# See the User manual for detailed descriptions
# NOTE: Paths must end with "/"
########################################################################
package Configuration;
{
use Cwd; #automatically determins current working directory
use File::Basename;

#$rootDirectory = Cwd::cwd;
$rootDirectory = "/scratch/Hieranoid2/";
## attach lib/ to PERL5LIB path
push(@INC,"$rootDirectory/lib");
       
       
#print "Root directory is $rootDirectory \n";

#####
#  Computation mode
#
#####
    ### Multi-Core specific options
    # Parallel
    # If > 1 node is available, Hieranoid will be started parallel
    # This must be the product of the number of cpu cores each cluster node has and number of nodes
    #$available_nodes = 144; # 18*8
    $available_nodes = 8; #
    # Time for the hieranoid master process to wait for child processes to finish
    $wallTime = 150000; # Orginally was 150000

    ## COMPUTATION ON CLUSTER	
    # "single" - single core 
    # "multi" - multi-core
    # "afs" - cluster mode with afs shared folder
    $computationMode = "multi";
    
    # List of nodes accessible by ssh
$sshCluster = [ 
"k06n17.pdc.kth.se",
"k08n17.pdc.kth.se",
"k09n12.pdc.kth.se",
"k01n03.pdc.kth.se",
"k08n44.pdc.kth.se",
"k09n02.pdc.kth.se",
"k01n37.pdc.kth.se",
"k03n23.pdc.kth.se",
"k04n41.pdc.kth.se",
"k06n32.pdc.kth.se",
"k07n12.pdc.kth.se",
"k08n18.pdc.kth.se",
"k02n14.pdc.kth.se",
"k06n10.pdc.kth.se",
"k07n46.pdc.kth.se",
"k01n12.pdc.kth.se",
"k09n16.pdc.kth.se",
"k06n09.pdc.kth.se",
"k04n19.pdc.kth.se",
"k01n43.pdc.kth.se",
"k08n24.pdc.kth.se",
"k09n22.pdc.kth.se",
"k03n15.pdc.kth.se",
"k07n45.pdc.kth.se",
"k02n18.pdc.kth.se",
"k02n02.pdc.kth.se",
"k09n10.pdc.kth.se",
"k08n29.pdc.kth.se",
"k01n38.pdc.kth.se",
"k04n42.pdc.kth.se",
"k01n09.pdc.kth.se",
"k07n38.pdc.kth.se",
"k02n25.pdc.kth.se",
"k03n18.pdc.kth.se",
"k02n01.pdc.kth.se",
"k08n10.pdc.kth.se",
"k08n08.pdc.kth.se",
"k06n21.pdc.kth.se",
"k06n37.pdc.kth.se",
"k03n04.pdc.kth.se",
"k06n33.pdc.kth.se",
"k07n47.pdc.kth.se",
"k03n16.pdc.kth.se",
"k01n21.pdc.kth.se",
"k03n10.pdc.kth.se",
"k04n22.pdc.kth.se",
"k04n45.pdc.kth.se",
"k02n38.pdc.kth.se",
"k02n40.pdc.kth.se",
"k03n14.pdc.kth.se"
#"k07n34.pdc.kth.se" # Master
];
    
    # Path to Hieranoid2 on cluster
    $pathCluster = "/scratch/Hieranoid2/";
    
    # Path to AFS directory on cluster
    $afsCluster = "/afs/pdc.kth.se/misc/pdc/volumes/sbc/prj.sbc.erison.6/Hieranoid/";
    
    # Path where perl libraries are stored on cluster
    $libCluster = "/afs/pdc.kth.se/home/m/mateuszk/perl5/lib/perl5/";
    
    # Temporary directory with enough space for muscle
    $tempDir = "/scratch/temp/";
    
    # Update path for rootDirectory if running on cluster
    unless( -e $rootDirectory) {
      $rootDirectory = $pathCluster;
    }
    
#####
# PROJECT PARAMETERS
# 
#####    
    ## Check the following setting and make changes accordingly
    # a directory with 'projectName' will be created in the current directory
    $projectName = "mkad";
    # Folder with proteome sequences
    # Note that the file names have to match the species names in the tree
    $speciesFilesDirectory = "$rootDirectory/mkad/sequences-short/";
    
    ## Choose sequence input format
    # fasta : ".fa", 
    # seqxml : ".xml"
    $sequenceInputFormat = "fa";
    
    ## Tree File
    # Specify guide tree file
    $treeFile = "$rootDirectory/mkad/tree/fungi5-short.tre";
        
##############
### BINARIES
#
# Make sure the following binaries are installed
###############
    
    ## HMMER BIN DIRECTORY
    # ALIGNMENT PROGRAM
    $muscle = "$rootDirectory/extern/muscle3.8.31_i86linux64";
    $kalign = "/usr/bin/kalign";
    
    # SIMILARITY SEARCH
    # Needs one of the following two programs: usearch or blast
    # If using Usearch, you also need segmasker, as usearch does not perform sequence masking
    # Binary of Usearch program http://www.drive5.com/usearch/
    $usearch = "$rootDirectory/extern/usearch5.1";
    # SEQUENCE MASKING
    $segmasker = "$rootDirectory/extern/segmasker";
    
    # Binary of Blast program
    $blast = "$rootDirectory/extern/blast-2.2.18/bin/blastall";
    $formatdb = "$rootDirectory/extern/blast-2.2.18/bin/formatdb";
    
    # Perl binary for spawned sub-processes
    # For "cluster" perlbrew installed on a node
    $perl = "/afs/pdc.kth.se/home/m/mateuszk/perl5/perlbrew/bin/perlbrew -q exec perl"; # -q option is important to silence perlbrew from sending anyting to stdout/stderr since blast_parser.pl uses stdout to create files
    # For "multi" perlbrew installed locally
    # $perl = "/home/mateuszk/perl5/perlbrew/bin/perlbrew exec perl";
    
    # PROFILE VS PROFILE COMPARISONS
    # Debian paths for package hhsuite
    $hhmake = "/usr/bin/hhmake";
    $hhblits = "/usr/bin/hhblits";
    $hhsearch = "/usr/bin/hhsearch";
    $hmmbuild = "/usr/bin/hmmbuild";
    $hmmscan = "/usr/bin/hmmscan";
    
    # Parser
    $blast2xml = "$rootDirectory/usearch2xml.pl";
    # Parses similarity search output in xml-format and combines HSP 
    $blastParser = "$rootDirectory/blast_parser.pl";
    
    # Substitution matrix
    # This matrix is used by the code calculating consensus sequence and does not affect blast search parameters
    $substitutionMatrixPath = "$rootDirectory/BLOSUM62";

#################################################
## Don't have to change the following
##################################################
    
    $allResultsDirectory = $rootDirectory."/$projectName";
    $hieranoidResultsDirectory = $allResultsDirectory."/nodes";
    $hieranoidProfilesDirectory = $allResultsDirectory."/profiles";
    $hieranoidConsensusDirectory = $allResultsDirectory."/consensus";
    $hieranoidMappingDirectory = $allResultsDirectory."/mapping";
        
    ## Similarity Search
    # Summarizing information
    # for consensus: 'clade_consensus'
    # for profiles : 'hierarchical_profile'
    # ...
    $summarizeInformation = 'clade_consensus';
    #$summarizeInformation = 'hierarchical_profile';
    
    ## use of outgroup
    # use of outgroup increases computation time, but might detect gene losses
    $use_outgroup = '';

    ## Profile search
    $profileSearch = "hhsearch";
    # number of hits to look at for profile-profile search
    $noHHsearchHits = "5";

    ## Orthology prediction        
    # Inparanoid = 'inparanoid'
    # can be expanded later
    $orthologyPredictionTool = 'inparanoid';
    
    # Format of orthology predictions 
    # Format of orthology predictions
    # comma-separated genes: 'groupFile'
    # OrthoXML format : 'orthoxml'
    $orthologGroupsFormat = 'groupFile';
    
    # Similarity Search        
    # Tool to perform similarity searches
    # usearch
    # blast
    $similaritySearchTool = 'usearch';
    #$similaritySearchTool = 'blast';
    
    ## Similarity search specific options
    # Blast-specific
    $similaritySearchCutoff = 40;
    # one of the following
    # --maxrejects 0 --maxaccepts 1000
    # --nousort
    $ublastParameters = "--maxlen 100000 --minlen 4 --evalue 0.01 --maxrejects 5 --maxaccepts 5";
    
    # Add orphan genes
    $addNonMatchingSequences = 'true';

    ## SEQUENCE TYPE
    # PROTEINS = "p"
    $sequence_type = "p";

####################
## Debugging information
####################
    $log_directory = "$rootDirectory/$projectName/log";
    #print "Log directory is $log_directory \n";
    $hieranoid_log = "$log_directory/$projectName.hieranoid.log";
    $inparanoid_log = "$log_directory/$projectName.inparanoid.log";
    $timeFile = "$log_directory/$projectName.benchmark.times";
    $tmpDir = "/tmp/";
}

1;
