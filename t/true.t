use common::sense;
use Class::Load qw(load_class);
use Test::More;

plan skip_all => 'true not installed' unless load_class 'true';

use_ok 't::True';

done_testing;
