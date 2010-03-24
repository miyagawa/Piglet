package Piglet::Response;
use parent qw(Plack::Response);

use Piglet::PSGI::App -app => 'as_psgi_app';

sub as_psgi_app {
    my $self = shift;
    sub { $self->finalize };
}

1;
