use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Exposer');

$t = $t->get_ok('/bigfoo?myquery=myvalue&hisquery=hisvalue')->status_is(200);

$t->get_ok('/')->status_is(200);
$t->get_ok('/a/b/c')->status_is(200);
$t->post_ok('/a/b/c')->status_is(200);
$t->put_ok('/a/b/c')->status_is(200);

$t->get_ok('/redirect')->status_is(200); # ->content_like(qr/redirected/);

$t = $t->get_ok('/foo');
$t = $t->get_ok('/foo' => {Accept => '*/*'} => 'Content!');
$t = $t->post_ok('/foo' => {Accept => '*/*', Other=>'header'} => form => {a => 'b'});
$t = $t->put_ok('/foo' => {Accept => '*/*'} => json => {a => 'b'});

$t->ua->server->url('https');

$t->get_ok('/secure')->status_is(200); # ->content_like(qr/secure/);

my $url = $t->ua->server->url->userinfo('sri:secr3t')->path('/secrets.json');

$t->post_ok($url => json => {limit => 10})
   ->status_is(200);
   # ->json_is('/1/content', 'Mojo rocks!');
    
done_testing();
