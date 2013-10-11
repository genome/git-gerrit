use strict;
use warnings;

use Test::More tests => 9;
use Test::System import => [qw(run_ok)];
use Test::GitGerrit;

use File::Spec qw();
use File::Temp qw();
use Git::Repository qw(Test);
use IO::File qw();

my $work_tree = File::Temp->newdir();
Git::Repository->run(init => $work_tree);
my $r = Git::Repository->new(work_tree => $work_tree);

my @files;
for my $i (1..3) {
    push @files, new_file($work_tree);
    $r->run('add', $files[-1]);
    $r->run('commit', '-m', "add $files[-1]");
}

my @commit_lines = $r->run('log', '--oneline');
is(scalar(@commit_lines), scalar(@files),
    sprintf('git shows %d commits', scalar(@files)));

my $out;

$r->run_exit_is(1, 'gerrit', 'change-ids');

my @init_args;
if ($ENV{JENKINS_URL}) {
    # running in Jenkins
    @init_args = ('--username', 'apipe-review' );
}
$r->run_exit_ok('gerrit', 'init', @init_args, 'git-gerrit');

my $hook = File::Spec->join($r->git_dir, 'hooks', 'commit-msg');
ok( -f $hook, 'commit-msg hook added');

$r->run_exit_ok('fetch');
$r->run_exit_ok('branch', '--set-upstream', 'master', 'origin/master');
$r->run_exit_ok('pull', '--rebase');
$r->run_exit_ok('gerrit', 'change-ids');

my @log = $r->run('log', '@{u}..');
my @change_id_lines = grep { /Change-Id/ } @log;
is(scalar(@change_id_lines), scalar(@commit_lines),
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
