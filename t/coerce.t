use common::sense;
use Test::More;

use t::Enum ':all';
use t::User;

my $user = t::User->new;
is $user->foo(0),       Left,  'int coercion works';
is $user->foo('Right'), Right, 'str coercion works';

done_testing;
