# Testing

Rough plan for testing...

    source env.sh
    tmp=$(mktemp --tmpdir --directory gerrit.XXX)
    git init $tmp
    cd $tmp

    git commit --allow-empty -m 'initial commit'
    git tag -m '' initial-commit
    git commit --allow-empty -m 'commit 1'
    git commit --allow-empty -m 'commit 2'

    git-gerrit-setup git-gerrit-test

    # check that origin is correct
    git config remote.origin.url

    # check that commit hook got installed
    head $(git rev-parse --git-dir)/hooks/commit

    git-gerrit-add-change-ids initial-commit

    # check for Change-Id on 'commit 1' and 'commit 2'
    git log

    git commit --allow-empty -m 'commit 3'
    # check for Change-Id on 'commit 3'
    git log
