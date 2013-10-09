# Sets up PATH.
package Test::GitGerrit;

use base 'Test::Builder::Module';
use base 'Exporter';
our @EXPORT_OK = qw(run_expect_return_code);

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

sub run_expect_return_code {
    my $tb = __PACKAGE__->builder;

    my $repo = shift;
    my $expected_exit_code = shift;
    my @cmd = @_;
#print STDERR "Verbose: $ENV{TEST_VERBOSE} About to execute ",join(' ', @cmd),"\n";
#system('bash') if grep { m/init/ } @cmd;
    my $out = $repo->run(@cmd, { quiet => !$ENV{TEST_VERBOSE} });
    my $exit_code = $? >> 8;
#print STDERR "    exit code $exit_code\n";
#print STDERR "    output: $out\n";
    my $rv = $tb->is_num($exit_code, $expected_exit_code,
        sprintf('`%s` exited %s as expected',
            join(' ', 'git', @cmd),
            $expected_exit_code)
    );
    ($rv || $ENV{TEST_VERBOSE}) or $tb->diag($out);
    return $rv;
}

1;
