use strict;
use warnings;

use Github::Backup;
use Test::More;

if (! $ENV{AUTHOR_TESTING}){
    plan skip_all => "author test only";
}

my $mod = 'Github::Backup';

my $o = $mod->new(
    api_user => 'stevieb9',
    token => $ENV{GITHUB_TOKEN},
    dir => 't/backup',
    proxy => 'http://10.0.0.4:80'
);

print "$_\n" for @{ $o->repos };

done_testing();
