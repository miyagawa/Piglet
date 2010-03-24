package Piglet::PSGI::App;
use strict;
use Carp ();

sub new { bless $_[1], $_[0] }

sub import {
    my $class = shift;
    my %args  = @_;

    if ($args{'-app'}) {
        my $app  = $args{'-app'};
        my $pkg  = caller(0);
        my $code = join "\n",
            "package $pkg;",
            "use overload '&{}' => sub { \$_[0]->$app }, fallback => 1;",
            "sub isa {",
            "    return 1 if \$_[1] eq 'Piglet::PSGI::App';",
            "    shift->SUPER::isa(\@_);",
            "}";

        eval $code;
        Carp::croak( "Failed to create isa method: $@" ) if $@;
    }
}

1;

__END__

=head1 NAME

Piglet::PSGI::App - Marker class to bless a code reference as a PSGI application

=head1 SYNOPSIS

  my $app = Piglet::PSGI::App->new(sub {
      my $env = shift;
      return [ 200, [ ... ], [ ... ] ];
  });

  # Or in your class
  package MyApplication::Class;
  use Plack::PSGI::App -app => 'as_psgi_app';

  sub as_psgi_app {
      my $self = shift;
      return sub {
          my $env = shift;
          ...
      }
  }

=head1 DESCRIPTION

This class is an empty class to bless PSGI subs into, to indicate that
the given code reference is a PSGI application.

Or you can C<use> this module as a mixin in your class to override
C<isa> to return true on C<< ->isa("Plack::PSGI::App") >> and then
overload the C<&{}> to return PSGI application code reference.

=head1 SEE ALSO

L<Piglet>

=cut


