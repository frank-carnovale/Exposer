use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Exposer');
my $SVR = $ENV{TEST_SERVER} || '';

$t = $t->get_ok("$SVR/healthz"  )->status_is(200)->json_is('/result'=>'healthy');
$t = $t->get_ok("$SVR/readiness")->status_is(200)->json_is('/result'=>'alive');

done_testing();
