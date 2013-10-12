use strict;
use warnings;

use Test::More tests => 2;
use Test::System import => [qw(exit_ok)];
use Test::GitGerrit;

exit_ok(['git-gerrit', '-h']);
exit_ok(['git-gerrit', '--help']);
