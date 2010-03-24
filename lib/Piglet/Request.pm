package Piglet::Request;
use strict;
use parent qw(Plack::Request);

use Piglet::Response;

sub new_response {
    my $self = shift;
    Piglet::Response->new(@_);
}

1;

