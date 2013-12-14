use Getopt::Long;
use Pod::Usage;
use Data::Dumper;

use vars qw($help $template $data);
GetOptions('h'    => \$help,
           'help' => \$help,
	   't=s'  => \$template,
	   'd=s'  => \$data,
    ) or pod2usage(0);

pod2usage(-exitstatus => 0,
          -output => \*STDOUT,
          -verbose => 2,
          -noperldoc => 1,
    ) if (defined $help or (!defined $template) or (!defined $data));


# assumes the whole set of mg awe utils are installed and in path.


die unless -e $data && -e $template;

$job = `mg_submit $template $data`;

foreach (split (/\n/, $job) ) {
	print $job, "\n";
	$id = $1 if /submitting job script to AWE...Done! id=(\S+)/;
}

$screenrc = "screen.$$";
open F, ">$screenrc" or die "cannot open $screenrc";

print F<<END;

setenv	AWE_JOB $id
setenv	PS1 \"[$id] awe# \"
screen
title	$id 

END

exec "screen", "-c", "$screenrc";


=pod

=head1  NAME

awe-screen_submit

=head1  SYNOPSIS

=over

=item awe-screen_submit

=back

=head1  DESCRIPTION

The awe_screen_submit command executes a call to awe-submit and places the job id in an environment variable in a new screen. This allows the awe utilities to get the job id from an envornment variable (AWE_JOB).

=head1  COMMAND-LINE OPTIONS

=over

=item -h, --help  This documentation

=item -t  The workflow template

=item -d  The input data 

=back

=cut
