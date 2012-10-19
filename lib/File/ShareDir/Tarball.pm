package File::ShareDir::Tarball;
# ABSTRACT: Deal transparently with shared files distributed as tarballs

=head1 SYNOPSIS

    use File::ShareDir::Tarball ':ALL';

    # use exactly like File::ShareDir
    $dir = dist_dir('File-ShareDir');

=head1 DESCRIPTION

If the shared files of a distribution are contained in a
tarball (see L<Dist::Zilla::Plugin::ShareDir::Tarball> for
why you would want to do that), automatically 
extract the archive in a temporary
directory and return the path to that directory. In other words,
from the consumer point of view, it'll behave just like L<File::ShareDir>.

NOTE: for now, only C<dist_dir()> is supported. The other functions will soon
come.

=cut

use strict;
use warnings;

use parent qw/ Exporter /;

use Carp;

use File::ShareDir;
use Archive::Tar;
use File::Temp qw/ tempdir /;
use File::chdir;

our @EXPORT_OK   = qw{
    dist_dir
};
our %EXPORT_TAGS = (
    ALL => [ @EXPORT_OK ],
);

my $shared_files_tarball = 'shared-files.tar.gz';

sub dist_dir {
    my $dir = File::ShareDir::dist_dir(@_);

    croak "archive '$shared_files_tarball' not found in $dir"
        unless -f "$dir/$shared_files_tarball";

    my $archive = Archive::Tar->new;
    $archive->read("$dir/$shared_files_tarball");

    # because that would be a veeery bad idea
    croak "archive '$shared_files_tarball' contains files with absolute path, aborting"
        if grep { m#^/# } $archive->list_files;

    my $tmpdir = tempdir( CLEANUP => 1 );
    local $CWD = $tmpdir;

    $archive->extract;

    return $tmpdir;
}

1;
