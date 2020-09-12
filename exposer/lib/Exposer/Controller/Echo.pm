package Exposer::Controller::Echo;
use Mojo::Base 'Mojolicious::Controller', -signatures;

sub main ($c) {

  my $log = $c->app->log;
  my $req = $c->req;
  my $url = $req->url;

  $log->debug("REQUEST RECIEVED.");
  
  $log->debug("URL: " . $url->to_string);

  if (my $base = $url->base) {
      for my $part (qw/host port scheme/) {
          $log->debug("$part: " . $base->$part) if $base->$part;
      }
  }

  for my $part (qw/scheme userinfo host port path fragment/) {
      $log->debug("$part: " . $url->$part) if $url->$part;
  }

  if (my $query = $url->query) {
      my $params = $query->to_hash;
      for my $param (sort keys %$params) {
          $log->debug("param: $param = " . $params->{$param});
      }
  }

  $log->debug("headers: " . $c->dumper($req->headers->to_hash));

  if (my $body = $req->body) {
      $log->debug("body follows..");
      $log->debug("____start_____");
      $log->debug($body);
      $log->debug("_____end______");
  } else {
      $log->debug("no body");
  }

  $c->render(text=>'yeah');

}

1;
