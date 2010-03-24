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
$r->connect("/app/new_user", { controller => "NewUser" }, { method => "POST" });
$r->connect("/{user:[a-z0-9_]+}", { controller => "Profile" });
$r->connect("/admin/{path_info:.*}", { app => "Admin" });
$r->connect("/wiki/{page}", { controller => "Wiki" });

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
    is_deeply $m, { app => "Admin", path_info => "login/me" };
    is $env->{SCRIPT_NAME}, '/admin';
    is $env->{PATH_INFO}, '/login/me';
}

{
    my $env = env "/admin/0";

    my $m = $r->match($env);
    is_deeply $m, { app => "Admin", path_info => "0" };
    is $env->{SCRIPT_NAME}, '/admin';
    is $env->{PATH_INFO}, '/0';
}

{
    my $env = env "/wiki/%E3%83%A1%E3%82%A4%E3%83%B3";

    my $m = $r->match($env);
    is_deeply $m, { controller => "Wiki", page => "\x{30e1}\x{30a4}\x{30f3}" };
}

{
    my $env = env "/app/new_user";
    my $m = $r->match($env);
    is $m, undef;
}

done_testing;

