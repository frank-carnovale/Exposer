package Exposer::Controller::Main;
use Mojo::Base 'Mojolicious::Controller', -signatures;

sub echo ($c) {

    my $log = $c->app->log;
    my $req = $c->req;
    my $url = $req->url;

    $log->debug("REQUEST RECIEVED.");

    $log->debug("URL: " . $url->to_string);

    my ($call,$params,$body);

    $call->{method} = $req->method;
    $log->debug("method: " . $call->{method});

    if (my $base = $url->base) {
        for my $part (qw/host port scheme/) {
            my $value = $base->$part || next;
            $call->{$part} = $value;
            $log->debug("$part: " . $value)
        }
    }

    for my $part (qw/scheme userinfo host port path fragment/) {
        my $value = $url->$part || next;
        $call->{$part} = $value;
        $log->debug("$part: " . $value)
    }

    if (my $query = $url->query) {
        $params = $query->to_hash;
        for my $param (sort keys %$params) {
            $log->debug("param: $param = " . $params->{$param});
        }
        undef $params unless keys %$params;
    }

    my $headers = $req->headers->to_hash;
    $log->debug("headers: " . $c->dumper($headers));

    if ($body = $req->body) {
        $log->debug("body follows..");
        $log->debug("____start_____");
        $log->debug($body);
        $log->debug("_____end______");
    } else {
        $log->debug("no body");
    }

    my $bundle = {
        call    => $call,
        headers => $headers
    };
    $bundle->{params} = $params if $params;
    $bundle->{body}   = $body   if $body;

    $c->render(json=>$bundle)

}

1;
