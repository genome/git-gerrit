# Install

Coming soon...

# Test

## Install Test Depedencies

    cpanm Git::Repository IPC::System::Simple Params::Validate

## Run Tests

    prove -r -I $(git rev-parse --show-toplevel)/t/lib
