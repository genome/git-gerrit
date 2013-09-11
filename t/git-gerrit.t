use strict;
use warnings;

use Test::More tests => 2;
use Test::System import => [qw(run_ok)];
use Test::GitGerrit;

run_ok(['git-gerrit', '-h']);
run_ok(['git-gerrit', '--help']);
