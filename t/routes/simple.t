use strict;
use Piglet::Routes;
use Test::More;

use HTTP::Message::PSGI;
use HTTP::Request::Common;

sub env {
    HTTP::Message::PSGI::req_to_psgi(GET @_);
}

my $r = Piglet::Routes->new;
$r->connect("/users/list", { controller => "Users", action => "list" });
$r->connect("/{user:[a-z0-9_]+}", { controller => "Profile" });
$r->connect("/admin/{path_info:.*}", { app => "Admin" });

{
    my $m = $r->match( env "/users/list" );
    is_deeply $m, { controller => "Users", action => "list" };
}

{
    my $m = $r->match( env "/miyagawa" );
    is_deeply $m, { controller => "Profile", user => "miyagawa" };
}

{
    my $env = env "/admin/login/me";
    is $env->{SCRIPT_NAME}, '';
    is $env->{PATH_INFO}, '/admin/login/me';

    my $m = $r->match($env);
    is_deeply $m, { app => "Admin", path_info => "/login/me" };
    is $env->{SCRIPT_NAME}, '/admin';
    is $env->{PATH_INFO}, '/login/me';
}

{
    my $env = env "/admin/0";

    my $m = $r->match($env);
    is_deeply $m, { app => "Admin", path_info => "/0" };
    is $env->{SCRIPT_NAME}, '/admin';
    is $env->{PATH_INFO}, '/0';
}

done_testing;

