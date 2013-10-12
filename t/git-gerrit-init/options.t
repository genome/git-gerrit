use strict;
use warnings;

use Test::More;
use Test::GitGerrit;

use File::Spec qw();
use File::Temp qw();
use Git::Repository qw(Test);
use IO::File qw();

my %cases = (
    '-H' => 'localhost',
    '--hostname' => 'localhost',
    '-p' => 9000,
    '--port' => 9000,
    '-u' => 'username',
    '--username' => 'username',
);

plan tests => scalar(keys %cases);

for my $opt (sort keys %cases) {
    my $opt_value = $cases{$opt};
    my $qr = qr/$opt_value/;
    subtest $opt => sub {
        plan tests => 2;

        my $work_tree = File::Temp->newdir();
        Git::Repository->run(init => $work_tree);
        my $r = Git::Repository->new(work_tree => $work_tree);

        $r->run_exit_ok('gerrit', 'init', $opt, $opt_value, 'git-gerrit');

        chomp(my $origin_url = $r->run('config', 'remote.origin.url'));
        like($origin_url, $qr, 'origin set correctly');
    };
}
