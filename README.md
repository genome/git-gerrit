# Install

    cmake .
    make install

# Test

## Install Test Depedencies

    cpanm Git::Repository Git::Repository::Plugin::Test IPC::System::Simple Params::Validate

## Run Tests

    prove -r -I t/lib
