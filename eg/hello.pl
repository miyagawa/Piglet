#!/usr/bin/perl
use Piglet::Helpers qw(:routes);
use Piglet::Helpers::View qw(micro haml);

get '/' => sub {
    "Hello World";
};

get '/time' => sub {
    my $req = shift;
    micro {
        my $time = time;
    };
}, 'now';

get '/hi/:name' => sub {
    my $req = shift;
    haml +{ name => $req->capture('name') };
};

psgi_app;

__DATA__

@@ now.html.micro
<html>
 <body>Hello current time is <?= $time ?></body>
</html>

@@ hi.html.haml
%p Hello =name

