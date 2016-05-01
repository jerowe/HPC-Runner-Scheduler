requires 'perl', '5.008005';
requires 'Carp';
requires 'Cwd';
requires 'Data::Dumper';
requires 'DateTime';
requires 'DateTime::Format::Duration';
requires 'File::Path';
requires 'File::Temp';
requires 'IO::File';
requires 'IO::Select';
requires 'IPC::Open3';
requires 'Log::Log4perl';
requires 'Moose';
requires 'MooseX::Getopt::Usage::Role::Man';
requires 'Moose::Util::TypeConstraints';
requires 'MooseX::Getopt';
requires 'MooseX::SimpleConfig';
requires 'Symbol';
requires 'Template';
requires 'HPC::Runner';

# requires 'Some::Module', 'VERSION';

on test => sub {
    requires 'Test::More', '0.96';
};
