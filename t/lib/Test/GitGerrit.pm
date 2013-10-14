# Sets up PATH.
package Test::GitGerrit;

use base 'Test::Builder::Module';

use strict;
use warnings;

use Cwd qw();
use File::Basename qw(dirname);
use File::Spec qw();

my $parent_dir = dirname(__FILE__);
my $top_dir = realpath($parent_dir, '..', '..', '..');

my $bin_path = File::Spec->join($top_dir, 'git-gerrit');
unless (-e $bin_path) {
    die "could not find git-gerrit in directory: $top_dir";
}
unless (-x $bin_path) {
    die "git-gerrit is not executable: $bin_path";
}

my $tbin_dir = File::Spec->join($top_dir, 't', 'bin');
unless (-d $tbin_dir) {
    die "could not find t/bin directory: $tbin_dir";
}

$ENV{PATH} = "$top_dir:$tbin_dir:$ENV{PATH}";

sub realpath {
    return Cwd::realpath(File::Spec->join(@_));
}

1;
