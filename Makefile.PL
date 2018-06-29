use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Mojolicious::Plugin::Mojominion',
  VERSION_FROM => 'lib/Mojolicious/Plugin/Mojominion.pm',
  AUTHOR       => 'A Good Programmer <nospam@cpan.org>',
  PREREQ_PM    => {'Mojolicious' => '7.85'},
  test         => {TESTS => 't/*.t'}
);
