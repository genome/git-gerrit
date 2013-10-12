use strict;
use warnings;

use Test::GitGerrit;

use Test::More tests => 5;
use Test::System import => [qw(exit_ok exit_is)];

use IPC::System::Simple qw(capture);

subtest 'single reviewer' => sub {
    plan tests => 1;
    my $reviewer = 'my_reviewer';
    my @lines = capture('git', 'gerrit', 'push', '--test', '-r', $reviewer, 'local_branch');
    chomp @lines;
    like($lines[1], qr/r=$reviewer/, "found '$reviewer' in refspec");
};

subtest 'single CC' => sub {
    plan tests => 1;
    my $cc = 'my_cc';
    my @lines = capture('git', 'gerrit', 'push', '--test', '-c', $cc, 'local_branch');
    chomp @lines;
    like($lines[1], qr/cc=$cc/, "found '$cc' in refspec");
};

subtest 'topic' => sub {
    plan tests => 1;
    my $topic = 'my_topic';
    my @lines = capture('git', 'gerrit', 'push', '--test', '-t', $topic, 'local_branch');
    chomp @lines;
    like($lines[1], qr/topic=$topic/, "found '$topic' in refspec");
};

subtest 'remote name' => sub {
    plan tests => 1;
    my $remote = 'not-origin';
    my @lines = capture('git', 'gerrit', 'push', '--test', '--remote', $remote, 'local_branch');
    chomp @lines;
    like($lines[0], qr/$remote/, "found $remote in remote name");
};

subtest 'branch + target_branch' => sub {
    plan tests => 2;
    my @lines = capture('git', 'gerrit', 'push', '--test', 'local_branch', 'target_branch');
    chomp @lines;
    like($lines[1], qr/local_branch/, 'found local_branch in refspec');
    like($lines[1], qr/target_branch/, 'found target_branch in refspec');
};
