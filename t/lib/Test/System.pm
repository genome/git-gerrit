use strict;
use warnings;

package Test::System;
use base 'Test::Builder::Module';
our @EXPORT_OK = qw(
    exit_ok
    exit_is
);

use Test::More import => [qw(diag)];

use IPC::System::Simple qw(capture);

sub exit_ok {
    return _exit_is(0, @_);
}

sub exit_is {
    return _exit_is(@_);
}

sub _exit_is {
    my ($expected_exit, $command, $test_name) = @_;

    my $tb = __PACKAGE__->builder;
    $tb->level(2);

    my @command = ref $command ? @$command : $command;
    $test_name //= @command > 1 ? join(' ', @command) : $command[0];

    # using capture because I like not having to escape arguments and I would
    # like to only show output on failure
    my $output = eval { capture(@command) } || 'NO OUTPUT';
    my $exit = $? >> 8;

    $tb->ok($exit == $expected_exit, $test_name)
        or diag sprintf("exit code: %d\noutput: %s\n", $exit, $output);
}
