#!/usr/bin/env perl
use Mojolicious::Lite;

use lib 'Mojominion/lib';

plugin 'Minion' => {Pg => 'postgresql://ubuntu@%2Fvar%2Frun%2Fpostgresql/test1'};
plugin 'Mojominion';

app->minion->add_task(test => sub { return });

get '/' => sub {
  my $c = shift;
  $c->minion->enqueue('test');
  $c->render(template => 'index');
};

app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title 'Welcome';
<h1>Welcome to the Mojolicious real-time web framework!</h1>
To learn more, you can browse through the documentation
<%= link_to 'here' => '/perldoc' %>.

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><%= content %></body>
</html>
