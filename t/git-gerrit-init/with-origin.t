use strict;
use warnings;

use Test::More tests => 3;
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

my @init_args;
if ($ENV{JENKINS_URL}) {
    # running in Jenkins
    @init_args = ('--username', 'apipe-review' );
}
$r->run_exit_ok('gerrit', 'init', @init_args, 'git-gerrit');

chomp(my $old_origin = $r->run('config', 'remote.old-origin.url'));
is($old_origin, $bare_repo_path, 'Original remote "origin" now called "old-origin"');

chomp(my $new_origin = $r->run('config', 'remote.origin.url'));
isnt($new_origin, $bare_repo_path, 'remote origin has changed');

