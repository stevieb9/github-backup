package Github::Backup;

use strict;
use warnings;

use Git::Repository;
use File::Copy;
use File::Path;
use LWP::UserAgent;
use Moo;
use Pithub;

use namespace::clean;

our $VERSION = '0.01';

# external

has api_user => (
    is => 'rw',
);
has dir => (
    is => 'rw',
);
has forks => (
    is => 'rw',
);
has token => (
    is => 'rw',
);
has proxy => (
    is => 'rw',
);
has user => (
    is => 'rw',
);

# internal

has gh => (
    # Pithub object
    is => 'rw',
);
has stg => (
    is => 'rw',
);

sub BUILD {
    my ($self) = @_;

    my $ua = LWP::UserAgent->new;

    if ($self->proxy){
        $ENV{http_proxy} = $self->proxy;
        $ENV{https_proxy} = $self->proxy;

        $ua->env_proxy;
    }

    my $gh = Pithub->new(
        ua => $ua,
        user => $self->api_user,
        token => $self->token
    );

    $self->stg($self->dir . '.stg');
    $self->gh($gh);

    $self->user($self->api_user) if ! defined $self->user;

    if (-d $self->stg){
        rmtree $self->stg or die "can't remove the old staging directory...";
    }

    mkdir $self->stg or die "can't create the backup staging directory...\n";

}
sub repos {
    my ($self) = @_;

    my $repo_list = $self->gh()->repos->list(user => $self->user);

    my @repos;

    while (my $repo = $repo_list->next){
        push @repos, $repo->{name};
    }

    for my $repo (@repos){
        my $content = $gh->repos()->get(user $self->user, repo => $repo);

        my $stg = $self->stg . "/$content->{name}";

        if (! $self->forks){
            if (! exists $content->{parent}){
                Git::Repository->run(
                    clone => $content->{clone_url} => $stg,
                    { quiet => 1}
                );
            }
        }
        else {
             Git::Repository->run(
                clone => $content->{clone_url} => $stg,
                { quiet => 1}
            );
        }
    }
}
sub DESTROY {
    my $self = shift;

    if (-d $self->dir){
        rmtree $self->dir or die "can't remove the old backup directory...";
    }

    move $self->stg, $self->dir or die "can't rename the staging directory...";
}

1;
__END__

=head1 NAME

Github::Backup - Back up your repositories, issues, gists and more

=head1 DESCRIPTION

This distribution provides the ability to backup your Github information easily
and quickly.

=head1 SYNOPSIS

=head1 METHODS

=head1 AUTHOR

Steve Bertrand, C<< <steveb at cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2017 Steve Bertrand.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.

