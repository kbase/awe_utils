use JSON;
use Data::Dumper;
use Getopt::Long;
use Pod::Usage;

use vars qw($help $dest $module_dat $nofatal);
GetOptions('h'    => \$help,
           'help' => \$help,
	   'd'    => \$download,
    ) or pod2usage(0);

pod2usage(-exitstatus => 0,
          -output => \*STDOUT,
          -verbose => 2,
          -noperldoc => 1,
    ) if (defined $help);


my $id = shift;
$id = $ENV{AWE_JOB} if $ENV{AWE_JOB} && !$id;

$jstring = `mg_job $id`;

$r=decode_json($jstring);

$LAST = $#{ $r->{data}->{tasks} };

foreach $a (@{ $r->{data}->{tasks} }) {
        my $task_id = $1 if $a->{taskid} =~ /\_(\d+)/;
        $outputs = $a->{outputs} if $task_id == $LAST;
}


foreach $filename ( keys %$outputs ) {
        $cmd = 'curl -s ' . $outputs->{$filename}->{url} . ' > ' . $filename . "\n";
        print "download $filename with command:\n$cmd\n";
        system($cmd);
}



=pod

=head1  NAME

awe-data

=head1  SYNOPSIS

=over

=item awe-data.pl -d

=back

=head1  DESCRIPTION

The awe-data program in the awe_utils package queries the awe server with a job id to find output files associated with that job. If the -d option is specified, then the data is downloaded. 

=head1  COMMAND-LINE OPTIONS

=over

=item -h, --help  This documentation

=item -d download the data 


=back

=cut
