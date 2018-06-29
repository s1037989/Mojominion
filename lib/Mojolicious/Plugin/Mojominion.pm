package Mojolicious::Plugin::Mojominion;
use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.01';

use Mojominion;
use Scalar::Util 'weaken';

sub register {
  my ($self, $app, $conf) = @_;

  $app->log->warn("Not development mode; remember to install your minion commands in your system's init system") and return
    unless $app->mode eq 'development' || $app->mode eq delete $conf->{allow};

  my $mojominion = Mojominion->new(each %$conf);
  weaken $mojominion->app($app)->{app};
  $app->helper(mojominion => sub {$mojominion});

  eval { $app->minion };
  $app->log->warn("Minion not installed in this app; make sure your app loads the Minion plugin before the Mojominion plugin") and return $self
    if $@ || ref $app->minion ne 'Minion';

  $app->hook(before_server_start => sub { $mojominion->server(shift)->start });
}

1;
__END__

=encoding utf8

=head1 NAME

Mojolicious::Plugin::Mojominion - Mojolicious Plugin

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('Mojominion');

  # Mojolicious::Lite
  plugin 'Mojominion';

=head1 DESCRIPTION

L<Mojolicious::Plugin::Mojominion> is a L<Mojolicious> plugin.

=head1 METHODS

L<Mojolicious::Plugin::Mojominion> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<https://mojolicious.org>.

=cut
