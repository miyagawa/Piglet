package Piglet::Routes;
use strict;
use Router::Simple;

sub new {
    my $class = shift;
    bless { rs => Router::Simple->new }, $class;
}

sub connect { shift->{rs}->connect(@_) }

sub match {
    my($self, $env) = @_;

    my $m = $self->{rs}->match($env) or return;

    # magic path_info
    if ($m->{path_info}) {
        if ($env->{PATH_INFO} =~ s!^(.*?)(/?)\Q$m->{path_info}\E$!!) {
            $m->{path_info}      = $2 . $m->{path_info};
            $env->{SCRIPT_NAME} .= $1;
            $env->{PATH_INFO}    = $m->{path_info};
        } else {
            # Hmm what should it do?
        }
    }

    return $m;
}

1;

__END__

=head1 NAME

Piglet::Routes - Define routes and register web handlers

=head1 SYNOPSIS

  use Piglet::Routes;

=head1 DESCRIPTION

Piglet::Routes is a simple wrapper around L<Router::Simple> that adds
more integration with PSGI application environment.

=head1 FEATURES

=head2 Magic path_info

  $r->connect('/foo/{path_info:.*}', { app => $app });

  my $match = $r->match($env); # /foo/bar/baz

  # $env->{SCRIPT_NAME} = "/foo"
  # $env->{PATH_INFO}   = "/bar/baz"

If the matched parameter contains the special key C<path_info>, it
rewrites C<SCRIPT_NAME> and C<PATH_INFO> so the delegated PSGI
application behaves like it's mounted under the path, similarly to
L<Plack::App::URLMap>.

Note that in the example, route is defined as C</foo/{path_info:.*}>
and B<NOT> C</foo{path_info:.*}>. The latter also works but it would
also match with C</foobar/baz> which would result in an unwanted
behavior.

Inspired by routes.rb's magic path_info
handling. L<http://routes.groovie.org/setting_up.html#magic-path-info>

=head1 SEE ALSO

L<Piglet> L<Router::Simple>

=cut
