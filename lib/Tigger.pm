package Tigger;
use strict;
use Exporter::Lite;
our @EXPORT = qw( get run );

use Piglet::Routes;
use Piglet::Decorator;

my $rs = Piglet::Routes->new;

sub get { $rs->get($_[0], { cb => Piglet::Decorator->psgify($_[1]) }, $_[2]) }

sub run {
    return sub {
        my $env = shift;
        if (my $match = $rs->match($env)) {
            return $match->{cb}->($env);
        } else {
            return [
                404,
                [ "Content-Type", "text/plain"],
                [ "Tigger doesn't know how to handle $env->{PATH_INFO} and gives it to Piglet." ],
            ]
        }
    };
}


1;
