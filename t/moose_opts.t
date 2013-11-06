use common::sense;
use Test::More;
use Test::Fatal;

use Class::Enum::Moose (
    'Left',
    -install_exporter => 0,
    -moose_opts       => [
        -meta_name => 'meta',
        { into => 't::Moose' }, -metaclass => 'Moose::Meta::Class',
    ],
    'Right',
);

like exception { Class::Enum::Moose->import(-moose_opts => {}) },
    qr/must be an array ref/, 'moose opts must be an array';

ok(t::Moose->can('name'), 't::Moose setup works');
ok !t::Moose->can('import'), 'Class::Enum options untouched';

done_testing;
