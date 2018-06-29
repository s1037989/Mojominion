package Mojominion;
use Mojo::Base -base;

use Mojo::IOLoop;
use Mojo::Server;
use Mojo::Util 'camelize';

use Time::Piece;

has app => sub { shift->server->build_app('Mojo::HelloWorld') };
has server => sub { Mojo::Server->new };

sub start {
  my ($self) = @_;
  my $mojominion_subprocess = Mojo::IOLoop->subprocess->run(
    sub {
      my $mojominion_subprocess = shift;
      $self->_set_process_name(sprintf '%s mojominion worker', $self->app->moniker);
      my $worker = $self->app->minion->worker;
      $self->app->log->info("Mojominion worker $$ started");
      $worker->on(dequeue => sub { pop->once(spawn => \&_spawn) });
      $worker->run;
      $self->app->log->info("Mojominion worker $$ stopped");
      return 1;
    },
    sub {
      $self->app->log->error("I've never seen this: $_[1]");
    }
  );
  $self->app->log->info(sprintf 'Started mojominion subprocess %s', $mojominion_subprocess->pid);
  return $self;
}

sub _set_process_name { $0 = pop }

sub _spawn {
  my ($job, $pid) = @_;
  my ($id, $task) = ($job->id, $job->task);
  $job->app->log->debug(qq{Process $pid is performing job "$id" with task "$task"});
}

1;
