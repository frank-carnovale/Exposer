use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Exposer');
my $SVR = $ENV{TEST_SERVER} || '';

$t->get_ok ("$SVR/")->status_is(200)->json_has('/call')->json_has('/call/port');
$t->get_ok ("$SVR/a/b/c")->status_is(200)->json_has('/headers')->json_has('/call/method'=>'GET');
$t->post_ok("$SVR/a/b/c")->status_is(200)->json_has('/call/method'=>'POST');
$t->put_ok ("$SVR/a/b/c")->status_is(200)->json_has('/call/path' => '/a/b/c');

$t = $t->get_ok("$SVR/bigfoo?myquery=myvalue&hisquery=hisvalue")
            ->status_is(200)
            ->json_is('/params/myquery' =>'myvalue')
            ->json_is('/params/hisquery'=>'hisvalue');

my $body = 'some random data';
$t = $t->put_ok("$SVR/foo" => {CrazyHeader => 'SomeVal'} => $body)
            ->json_is('/body' => $body)
            ->json_is('/headers/CrazyHeader' => 'SomeVal');

done_testing();
