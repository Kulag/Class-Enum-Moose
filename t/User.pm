package t::User;
use Moose;
use t::Enum;

has 'foo', is => 'rw', isa => 't::Enum', coerce => 1;

0x6B63;
