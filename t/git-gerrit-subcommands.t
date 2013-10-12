use strict;
use warnings;

use Test::More tests => 6;
use Test::System import => [qw(run_ok)];
use Test::GitGerrit;

use File::Spec qw();
use File::Temp qw();
use Git::Repository qw(Test);
use IO::File qw();

my $work_tree = File::Temp->newdir();
Git::Repository->run(init => $work_tree);
my $r = Git::Repository->new(work_tree => $work_tree);

my $add_and_comit = sub {
    my $file = new_file($work_tree);
    $r->run('add', $file);
    $r->run('commit', '-m', "add $file");
    return $file;
};

$add_and_comit->();
my $base = $r->run('rev-parse', '--short', 'HEAD');
chomp $base;

my @files;
for my $i (1..3) {
    push @files, $add_and_comit->();
}

my @commit_lines = $r->run('log', '--oneline');
is(scalar(@commit_lines), (@files + 1), # +1 = $base
    sprintf('git shows %d commits', scalar(@files)));

my $out;

$r->run_exit_is(1, 'gerrit', 'change-ids');

$r->run_exit_ok('gerrit', 'init', 'git-gerrit');

my $hook = File::Spec->join($r->git_dir, 'hooks', 'commit-msg');
ok( -f $hook, 'commit-msg hook added');

$r->run_exit_ok('gerrit', 'change-ids', $base);

my @log = $r->run('log', "$base..");
my @change_id_lines = grep { /Change-Id/ } @log;
is(scalar(@change_id_lines), scalar(@files),
    'each of those commits has Change-Id'
) or diag @log;

################################################################################

my $file_count;
sub new_file {
    my $dir_path = shift;
    my $file_name = 'file' . ++$file_count;
    my $file_path = File::Spec->join($dir_path, $file_name);
    my $fh = IO::File->new($file_path, 'w');
    $fh->print($file_name);
    $fh->close();
    return $file_path;
}
