use warnings;
use strict;

use Pithub;

my $p = Pithub->new;

my $result = $p->repos->list( user => 'stevieb9' );
while ( my $row = $result->next ) {
    printf "%s\n", $row->{name};
}
