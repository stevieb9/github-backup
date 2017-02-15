use strict;
use warnings;

use Github::Backup;
use Test::More;

my $mod = 'Github::Backup';

{ # class

    my $o = $mod->new;
    is ref $o, $mod, "object is in proper class ok";
}
{ # params

    my $o = $mod->new(
        api_user => 'stevieb9',
        token => 5,
        dir => '/tmp',
        proxy => 'http://10.0.0.4:80'
    );

    is $o->user, 'stevieb9', "user() ok";
    is $o->token, 5, "token() ok";
    is $o->dir, '/tmp', "dir() ok";
}

done_testing();
