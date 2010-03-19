package Piglet;

use strict;
use 5.008_001;
our $VERSION = '0.01';

1;
__END__

=encoding utf-8

=for stopwords

=head1 NAME

Piglet - PSGI micro web framework toolkit

=head1 DESCRIPTION

Piglet is a DIY toolkit for web application and web framework
developers. Piglet is a collection of modules, utilities and helpers
to make it easier than ever to create a new micro web framework, or
add new features to existing frameworks.

Piglet has helpers and modules to quickly create a PSGI application, a
quick DSL helper to write a micro web router and adapters for existing
web frameworks to use these features.

Piglet is built on top of the PSGI standard, which means it works well
with most of PSGI supported web servers and Plack.

=head1 MOTIVATIONS

Rack is sexy and WSGI is cool. So is PSGI.

Plack solves the problem of "how to deploy Perl web applications" by
making the PSGI interface standard.

Now most Perl web frameworks support PSGI and can run on any of the
existing web servers via CGI, FastCGI, mod_perl as well as directly on
shiny new Perl web servers such as L<Starman>, L<Twiggy> and
L<Corona>.

PSGI made web framework developers happy.

However, now application developers keep asking questions I<What's the
best framework to use with Plack>? The answer has been always I<well,
whatever you like the most>, but it doesn't seem to satisfy most
people.

Turns out, these web application developers want to use Plack to make
sure their application runs on any PSGI compatible web severs (check),
to benefit from Plack::Middleware features with tools such as
L<Plack::App::URLMap> or L<Plack::Builder> (check) and quickly build a
very simple web application handlers using L<Plack::Request> or alike.

In the end they pretty much inlined their web application in C<.psgi>
file using L<Plack::Builder> and L<Plack::Request>, which feels a bit
chunky.

Writing a new web application without the learning cost of web
application frameworks is tricky, since most frameworks are
featureful, to reduce the amount of things you need to care about in
the future. This contradicts with the need of starting with something
simple without learning I<anything> but with the possiblity of
gradually upgrading the application from simple to complex.

Exsiting solutions to this dilemma include things called I<micro web
frameworks> such as L<Mojolicious::Lite>, L<Squatting> and L<Dancer>:
they are excellent frameworks you should take a look at. They all
support PSGI so you can use Plack middleware with them as well :)

However Mojolicious and Dancer are also featureful, which is obviously
a great thing later, but we wanted something as thin, or in other
words, as I<dumb> as possible, to start writing a new application.

So, Piglet is basically a toolkit to write a framework-less
application, or your I<own micro web framework> for an application
with more raw-ish access to Plack middleware components with simple OO
API or fancy DSL syntax.

Because it's built on top of PSGI, it's easy to later migrate or
upgrade to more featureful I<real web frameworks> such as L<Catalyst>
or L<Jifty>.

Read more about the idea of framework-less WSGI web application on
L<Ian Bicking's blog
post|http://blog.ianbicking.org/2010/03/12/a-webob-app-example/> which
is an inspiration for this project.

=head1 AUTHOR

Tatsuhiko Miyagawa

Tokuhiro Matsuno

Piglet is inpired by Sinatra, Merb, routes, Ruby on Rails, WebOb,
juno, bottle, Dancer and Mojolicious.

=head1 COPYRIGHT

Copyright 2010- Tatsuhiko Miyagawa

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Plack>

=cut
