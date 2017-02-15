use strict;
use warnings;

use Github::Backup;
use Test::More;

my $mod = 'Github::Backup';

my $o = $mod->new(
    api_user => 'stevieb9',
    token => $ENV{GITHUB_TOKEN},
    dir => 't/backup',
    proxy => 'http://10.0.0.4:80'
);

done_testing();
