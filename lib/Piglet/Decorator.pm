package Piglet::Decorator;
use strict;
use warnings;

use Scalar::Util qw(blessed);
use Piglet::Request;
use Try::Tiny;
use Plack::Middleware::HTTPExceptions;

sub psgify {
    my($self, $app) = @_;

    if (blessed($app) && $app->isa('Piglet::PSGI::App')) {
        return $app;
    }

    my $wrapped = sub {
        my $env = shift;
        my $req = Piglet::Request->new($env);

        my $res = try {
            $app->($req);
        } catch {
            $env->{'piglet.exception.caught'} = $_;
            return $_;
        };

        $self->psgi_response($res, $req, $env);
    };

    Plack::Middleware::HTTPExceptions->wrap($wrapped);
}

sub psgi_response {
    my($self, $res, $req, $env) = @_;

    if (blessed($res) && $res->isa('Piglet::PSGI::App')) {
        return $res->($env);
    } elsif (ref $res eq 'ARRAY' or ref $res eq 'CODE') {
        return $res;
    } elsif ($env->{'piglet.exception.caught'}) {
        die $res;
    } elsif (!ref $res) {
        my $body = $res;
        $res = $req->new_response(200);
        $res->content_type('text/html');
        $res->content_length(length $body);
        $res->content($body);
        return $res->finalize;
    }
}

1;

__END__

=head1 NAME

Piglet::Decorator - Turns subs into PSGI application

=head1 SYNOPSIS

  my $app = Piglet::Decorator->psgify($sub);

  # $sub can be ...

  # returns a string
  sub {
      my $req = shift; # Piglet::Request
      return "Hello World";
  };

  # returns a PSGI response array ref
  sub { [ 200, [ "Content-Type" => 'text/plain' ], [ "Hello" ] ] };

  # returns a PSGI streaming response
  sub {
      my $req = shift;
      return sub {
          my $respond = shift;
          $respond->([ 200, [...], [...] ]);
      };
  };

  # returns a new PSGI application
  sub {
      my $req = shift;
      return Piglet::PSGI::App->new(sub {
          my $env = shift;
          return [ 200, [...], [...] ];
      });
  };

  # returns Piglet::Response
  sub {
      my $req = shift;
      my $res = $req->new_response(200);
      $res->content("Hello");
      $res;
  }

  # throws an exception that has ->code and optionally ->message
  sub { HTTP::Exception::NOT_FOUND->throw }

