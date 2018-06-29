package Mojominion::Command::mojominion;
use Mojo::Base 'Mojolicious::Command';

has description => 'Mojolicious built-in Minion processor';
has usage => sub { shift->extract_usage };

use Mojo::IOLoop;

sub run {
  my $self = shift;
  # if -s print the systemd entry that one should install in an actual systemd
  #       print a hypnotoad one for the app, too
}

1;
