# Sets up PATH.
package Test::GitGerrit;

use base 'Test::Builder::Module';

use strict;
use warnings;

use Cwd qw();
use File::Basename qw(dirname);
use File::Spec qw();

my $parent_dir = dirname(__FILE__);
my $git_gerrit_dir = realpath($parent_dir, '..', '..', '..');

my $bin_path = File::Spec->join($git_gerrit_dir, 'git-gerrit');
unless (-e $bin_path) {
    die "could not find git-gerrit in directory: $git_gerrit_dir";
}
unless (-x $bin_path) {
    die "git-gerrit is not executable: $bin_path";
}

$ENV{PATH} = "$git_gerrit_dir:$ENV{PATH}";

sub realpath {
    return Cwd::realpath(File::Spec->join(@_));
}

1;
