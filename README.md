## This repository is "forked" from https://bitbucket.org/sonnhammergroup/hieranoid/src/master/ 
Done with the intention of testing and updating. 


# Hieranoid 2 - Hierarchical orthology inference algorithm
___

## About

* Hieranoid 2 is a continuation of Fabian Schreiber work and the fork of original repository.
* Hieranoid 1 was published in Journal of Molecular Biology (DOI: 10.1016/j.jmb.2013.02.018).

## Installation

1. On GNU/Linux distribution such as Debian or Ubuntu, external programs can be installed by

       
        sudo apt-get install blast2 muscle hhsuite kalign git

    Hieranoid 2 was tested with blast2 (2.2.18), muscle (3.8.31).      

2. Clone the source code from the repository

        git clone https://bitbucket.org/mkaduk/hieranoid-2


3. Prepare perl enviroment where you intend to run Hieranoid 2.
    
    ** Note**: Perl allow for compiled libraries which are specific for hardware architecture where they were installed.

    Basic setup of perl enviroment

        # Bootstrap locally perl 5.20.1
        wget -O - http://install.perlbrew.pl --no-check-certificate  | bash
        source ~/perl5/perlbrew/etc/bashrc
        perlbrew --notest install perl-5.20.1
        perlbrew switch perl-5.20.1
        perlbrew install-cpanm

        # Use cpanm from perlbrew to install required modules
        perlbrew exec cpanm BioPerl
        perlbrew exec cpanm Bio::Phylo
        perlbrew exec cpanm Moose
        perlbrew exec cpanm Log::Log4perl
        perlbrew exec cpanm Net::OpenSSH::Parallel
        perlbrew exec cpanm XML::LibXML
        perlbrew exec cpanm XML::Parser

## Configuration

Minimal configuration to get started

1. Create project subdirectories

        mkdir mkad # Create project directory
        mkdir mkad/log
        mkdir mkad/sequences
        mkdir mkad/tree

    Copy you proteomes in fasta format, guide tree to corresponding directories.

    **Note**: Names of branches in guidetree in Newick format, must be the same as proteoms file names without an extension.


2. Set project details in configuration file

        nano lib/Configurations/Configuration.pm

        $rootDirectory = "/scratch/Hieranoid2/";
        $projectName = "mkad";
        $tempDir = "/scratch/temp/;
        $speciesFilesDirectory = "$rootDirectory/mkad/sequences-short/";
        $treeFile = "$rootDirectory/mkad/tree/fungi5-short.tre";

3. Set up external programs

    External programs are usually placed in extern directory and depend on configuration. 
    Hieranoid 2.0 was tested with usearch5.1 in combination with segmasker (from blast 2.2.28), blastall (from blast 2.2.18) and muscle 3.8.31.

    Listing of extern directory

        muscle
        muscle3.8.31_i86linux64
        blast-2.2.18/
        usearch5.1
        usearch5.1.221_i86linux32

   After populating extern directory, correct paths must be set in aforementioned Configuration.pm file.

## Running Hieranoid 2

   To run Hieranoid perlbrew enviroment was used, but any other perl installation is acceptable. 
   Example run would look like

       source ~/perl5/perlbrew/etc/bashrc  # Load perlbrew enviroment
       perlbrew exec perl -I ./lib ./hieranoid.pl
