#
# This module allows to start a job on cluster
# Requirments are ssh (no password) access, rsync and perlbrew
# Author:  Mateusz Kaduk <mateusz.kaduk@scilifelab.se>
#

package Cluster;
use Moose;
use Net::OpenSSH;
use File::Temp qw/ tempfile tempdir /;
use Data::Dumper;
use File::Basename;

# Generates random string with printable characters of given len
sub randStr
{
  my ($self, %args) = @_;
	my $len = $args{len};

	my @chars=('a'..'z','A'..'Z','0'..'9','_');
	my $random_string;
	foreach (1..$len) 
	{
		$random_string.=$chars[rand @chars];
	}
	return $random_string;
}

sub lock {
    my ($self, %args) = @_;
    my $dir = $args{dir};
    
    # Wait for unlocked AFS directory
    while( -e "$dir/afs.lock") { sleep(1); }
    
    # Place a lock
    system("hostname > $dir/afs.lock");
}

sub unlock {
    my ($self, %args) = @_;
    my $dir = $args{dir};
    # Remove lock
    system("rm -f $dir/afs.lock");
}

sub copy {
    my ( $self, %args ) = @_;
    my $srcDir = $args{srcDir};
    my $dstDir = $args{dstDir};
    
    my @syncCmdList;
    push(@syncCmdList, "rsync -qruWtd --include '*/'  --include '*started*' --exclude '*' ".$srcDir."/* ".$dstDir);         # Include only started
    push(@syncCmdList, "rsync -qruWtd --include '*/'  --exclude '*finished*' --exclude '*afs.lock*' --exclude '*.log*' --exclude 'temp/' --exclude '.*' ".$srcDir."/* ".$dstDir); # Include all except finished, file with log extension and afs.locks
    push(@syncCmdList, "rsync -qruWtd --include '*/'  --include '*finished*' --exclude '*' ".$srcDir."/* ".$dstDir);        # Include only finished
    
    foreach my $cmd (@syncCmdList) {
	system($cmd);
    }
}

# copy files between two directories in a safe way (this method should be used for AFS)
sub safecopy {
    my ( $self, %args ) = @_;
    my $srcDir = $args{srcDir};
    my $dstDir = $args{dstDir};
    my $lock   = $args{lock};
    
    if($lock == 1) {
      # Set a lock
      $self->lock(dir => $dstDir);
      $self->lock(dir => $srcDir);
    }
    # Copy files
    $self->copy(srcDir => $srcDir, dstDir => $dstDir);
    if($lock == 1) {
      # Remove a lock
      $self->unlock(dir => $dstDir);
      $self->unlock(dir => $srcDir);
    }
}

sub submitCommand {
	my ( $self, %args ) = @_;
	my $host        = $args{host};
	my $commandList = $args{commandList};
  my $mode        = $args{mode};
  
  #my $path = "/tmp/.ssh-$host";
  my $tag = $self->randStr(len => 8);
  my $path = "/tmp/.ssh-$tag";
  
	# Create OpenSSH object
	my $ssh = Net::OpenSSH->new($host, ctl_path => $path );

  # If has any jobs running wait
  my @pids = $ssh->capture("/sbin/pidof perl");
  my $npids = scalar @pids;
  while($npids > 1) {
    @pids = $ssh->capture("/sbin/pidof perl");
    $npids = scalar @pids;
    #print Dumper(@pids);
    #print "Waiting 10s for jobs on $host and npids $npids\n";
    sleep(10);
  }
  
  # No jobs running, submit commands
	for my $cmd (@$commandList) {
	   my $logFile = File::Temp->new(TEMPLATE => 'clusterXXXXX', OPEN => 0, TMPDIR => 1); # Create sub-process log file
	   if($mode eq "fg") {
	      $ssh->system("$cmd 2> $logFile.err > $logFile.out");
	    } else {
	      $ssh->system("nohup $cmd 2> $logFile.err > $logFile.out &");
	    }
	}
}

1;
