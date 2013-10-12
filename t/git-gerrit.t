use strict;
use warnings;

use Test::More tests => 6;
use Test::System import => [qw(exit_ok exit_is)];
use Test::GitGerrit;

exit_ok(['git-gerrit', '-h']);
exit_ok(['git-gerrit', '--help']);

# 128 in Git is fatal error.  For now we are going to treat non-existing
# sub-commands as fatal until I can figure out a better way to test.
exit_is(128, ['git-gerrit', 'doesnt-exist', '-h']);

# 129 in Git is usage message
exit_is(129, ['git-gerrit', 'change-ids', '-h']);
exit_is(129, ['git-gerrit', 'init', '-h']);
exit_is(129, ['git-gerrit', 'push', '-h']);
