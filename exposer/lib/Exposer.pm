package Exposer;
use Mojo::Base 'Mojolicious', -signatures;

# This method will run once at server start
sub startup ($self) {

  my $config = $self->plugin('NotYAMLConfig');

  $self->secrets($config->{secrets});

  my $r = $self->routes;

  $r->any($config->{health_url} => { json=>{result=>'healthy'} });
  $r->any($config->{ready_url } => { json=>{result=>'alive'} });

  $r->any('/')->to('main#echo');
  $r->any('/*')->to('main#echo');

  $self->log->info('Exposer is ready');
}

1;
