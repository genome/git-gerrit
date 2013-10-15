package Git::Repository::Plugin::Test;
use base 'Git::Repository::Plugin';
use base 'Test::Builder::Module';

sub _keywords { qw( run_exit_ok run_exit_is ) }

sub _run_exit {
    my $repo = shift;
    my $expected_exit = shift;
    my ($cmd, $opt) = split_args(@_);

    unshift @$opt, (quiet => !$ENV{TEST_VERBOSE});

    my $out = eval { $repo->run(@$cmd, { @$opt }) };
    my $exit = $? >> 8;

    my $test_name = sprintf('`%s` should exit %d',
        join(' ', 'git', @$cmd), $expected_exit);

    my $tb = __PACKAGE__->builder;

    $tb->level(2);
    my $rv = $tb->is_num($exit, $expected_exit, $test_name);

    if ($out && (!$rv || $ENV{TEST_VERBOSE})) {
        $tb->diag($out);
    }

    return $rv;
}

sub run_exit_ok {
    my $repo = shift;
    return _run_exit($repo, 0, @_);
}

sub run_exit_is {
    return _run_exit(@_);
}

sub split_args {
    # split the cmd and options like Git::Repository::Command::new does
    my @args = @_;
    my @opt;
    my @cmd = grep { !( ref eq 'HASH' ? push @opt, $_ : 0 ) } @args;
    return (\@cmd, \@opt);
}

1;
