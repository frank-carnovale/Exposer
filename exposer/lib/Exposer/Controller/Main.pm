package Exposer::Controller::Main;
use Mojo::Base 'Mojolicious::Controller', -signatures;

sub echo ($c) {

    my $log = $c->app->log;
    my $req = $c->req;
    my $url = $req->url;

    $log->info("START REQUEST DETAILS..");

    $log->info("URL: " . $url->to_string);

    my ($call,$params,$body,$bundle);

    $call->{method} = $req->method;
    $log->info("method: " . $call->{method});

    if (my $base = $url->base) {
        for my $part (qw/host port scheme/) {
            my $value = $base->$part || next;
            $call->{$part} = $value;
            $log->info("$part: " . $value)
        }
    }

    for my $part (qw/scheme userinfo host port path fragment/) {
        my $value = $url->$part || next;
        $call->{$part} = $value;
        $log->info("$part: " . $value)
    }
    $bundle->{call} = $call;

    $params = $url->query->to_hash;
    if (keys %$params) {
        $log->info("params: " . $c->dumper($params));
        $bundle->{params} = $params;
    }

    my $headers = $req->headers->to_hash;
    $log->info("headers: " . $c->dumper($headers));
    $bundle->{headers} = $headers;

    if ($body = $req->body) {
        $log->info("__start_body_____");
        $log->info($body);
        $log->info("__end___body_____");
        $bundle->{body} = $body;
    } else {
        $log->info("no body");
    }
    $log->info("END REQUEST DETAILS.");

    $c->render(json=>$bundle)

}

1;
