use strict;
use warnings;

use Test::More tests => 1;
use Test::System import => [qw(run_ok)];
use Test::GitGerrit;

use File::Spec qw();
use File::Temp qw();
use Git::Repository qw(Test);
use IO::File qw();

my $bare_repo_path = File::Temp->newdir();
my $bare_repo = Git::Repository->run(init => '--bare', $bare_repo_path);

my $out;

my $work_tree = File::Temp->newdir();
Git::Repository->run(init => $work_tree);
my $r = Git::Repository->new(work_tree => $work_tree);

$r->run('remote', 'add', 'origin', $bare_repo_path);
$r->run('remote', 'add', 'old-origin', $bare_repo_path);
$r->run_exit_is(1, 'gerrit', 'init', 'git-gerrit');
