use strict;
use Test::More;
use Piglet::Decorator;
use Plack::Test;
use HTTP::Request::Common;

sub MyHTTPException::throw { die(bless [ $_[1] ], $_[0]) }
sub MyHTTPException::code  { $_[0]->[0] }

my @app = (
    # return a string
    sub {
        my $req = shift;
        return "Hello World";
    },
    sub {
        is $_[0]->content_type, 'text/html';
        is $_[0]->content_length, 11;
        is $_[0]->content, "Hello World";
    },
    # Piglet::Response
    sub {
        my $req = shift;
        my $res = $req->new_response(200);
        $res->content("Hello " . ref $req);
    },
    sub {
        is $_[0]->content, "Hello Piglet::Request";
    },
    # new PSGI application
    sub {
        return Piglet::PSGI::App->new(sub {
            my $env = shift;
            [ 200, [ "Content-Type", "text/plain" ], [ "Hello PSGI App" ] ];
        });
    },
    sub {
        is $_[0]->content_type, 'text/plain';
        is $_[0]->content, "Hello PSGI App";
    },
    # PSGI streaming app
    sub {
        return sub {
            $_[0]->([ 200, [ "Content-Type", "text/plain" ], [ "Streaming App" ] ]);
        };
    },
    sub {
        is $_[0]->content_type, 'text/plain';
        is $_[0]->content, "Streaming App";
    },
    # throws an exception
    sub {
        MyHTTPException->throw(403);
    },
    sub {
        is $_[0]->code, 403;
        is $_[0]->content, 'Forbidden';
    },
);

while (@app) {
    my($app, $test) = splice @app, 0, 2;
    $app = Piglet::Decorator->psgify($app);
    test_psgi $app, sub {
        my $cb = shift;
        my $res = $cb->(GET "/");
        $test->($res);
    };
}

done_testing;
