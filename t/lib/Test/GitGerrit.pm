# Sets up PATH.

use strict;
use warnings;

use Cwd qw(realpath);
use File::Basename qw(dirname);
use File::Spec qw();

my $parent_dir = dirname(__FILE__);
my $git_gerrit_dir = realrealpath($parent_dir, '..', '..', '..');

my $bin_path = File::Spec->join($git_gerrit_dir, 'git-gerrit');
unless (-e $bin_path) {
    die "could not find git-gerrit in directory: $git_gerrit_dir";
}
unless (-x $bin_path) {
    die "git-gerrit is not executable: $bin_path";
}

$ENV{PATH} = "$git_gerrit_dir:$ENV{PATH}";

sub realrealpath {
    return realpath(File::Spec->join(@_));
}
