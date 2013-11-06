use common::sense;
use Test::More;

use t::Enum ':all';

ok(t::Enum->does('Class::Enum::Moose::Role'), 'role applied');
ok(t::Enum->can('name'),                      'Class::Enum setup');
ok Left->is_left, 'imported okay';

done_testing;
