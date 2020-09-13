use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Exposer');
my $SVR = $ENV{TEST_SERVER} || '';

$t->get_ok("$SVR/")->status_is(200);
$t->get_ok("$SVR/a/b/c")->status_is(200);
$t->post_ok("$SVR/a/b/c")->status_is(200);
$t->put_ok("$SVR/a/b/c")->status_is(200);

$t = $t->get_ok("$SVR/bigfoo?myquery=myvalue&hisquery=hisvalue")
            ->status_is(200);

my $body = 'some random data';
$t = $t->get_ok("$SVR/foo" => {Accept => '*/*'} => $body);

$t = $t->post_ok("$SVR/foo" => {Accept => '*/*', Other=>'header'} => form => {a => 'b'});
$t = $t->put_ok("$SVR/foo" => {Accept => '*/*'} => json => {a => 'b'});

done_testing();
