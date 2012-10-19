use strict;
use warnings;

use Test::More tests => 2;

use Test::File::ShareDir
    -share => {
        -dist   => { 'My-Dist'    => 't/share' }
};

use File::ShareDir::Tarball qw/ dist_dir /;


my $dir = dist_dir('My-Dist');

ok -f "$dir/foo", 'foo';
ok -f "$dir/bar", 'bar';





