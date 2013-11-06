package Class::Enum::Moose;
# ABSTRACT: Class::Enum with Moose integration

use Carp qw(croak);
use Class::Enum 0.04 ();
use Class::Load qw(load_optional_class);
use Import::Into ();
use List::MoreUtils qw(firstidx);
use Moose           ();
use Moose::Exporter ();
use Moose::Util::TypeConstraints;

use common::sense;    # Override warnings from M::U::TC

my ($moose_import) = Moose::Exporter->setup_import_methods(
    also             => ['Moose'],
    base_class_roles => ['Class::Enum::Moose::Role'],
);

my $has_true = load_optional_class 'true';

sub import {
    my $class = shift;

    # Remove moose options
    my $moose_opts;
    if ((my $i = firstidx { $_ eq '-moose_opts' } @_) != -1) {
        (undef, $moose_opts) = splice @_, $i, 2;
    }

    $moose_opts ||= [];
    croak '-moose_opts must be an array ref' unless ref $moose_opts eq 'ARRAY';

    # Get target package
    my $into = _get_into_hash($moose_opts);
    my $target = $into->{into} // caller $into->{into_level};

    $into->{into_level}++ unless defined $into->{into};

    # Setup Moose
    $class->$moose_import(@$moose_opts);

    # Setup coercion
    class_type $target;
    coerce $target, from 'Int', via { $target->from_ordinal($_) };
    coerce $target, from 'Str', via { $target->value_of($_) };

    # Setup enum
    # Note: Class::Enum uses caller() as its only source of target package.
    Class::Enum->import::into($target, @_);

    # use true;
   	$target->true::import if $has_true;
}

sub _get_into_hash {
    my $args = shift;

    for (my $i = 0; $i < @$args; $i += 2) {

        # Ignore the MX params.
        next if $args->[$i] =~ /^-/;

        # The first argument is it if it's a hash.
        return $args->[$i] if ref $args->[$i] eq 'HASH';

        last;
    }

    # Not present, so add a blank hash.
    push @$args, my $params = {};
    return $params;
}

0x6B63;

=SYNOPSIS
	
	package Direction;
	use Class::Enum::Moose qw(Left Right);

	package User;
	use Direction ':all';

	has [qw(foo bar)], is => 'rw', isa => 'Direction', coerce => 1;
	
	my $user = User->new(foo => 0, bar => 'Right');
	$user->foo == Left;
	$user->bar == Right;

=head1 DESCRIPTION

L<Class::Enum::Moose> is a L<Class::Enum> wrapper that adds L<Moose>
integration.

=head2 Enum Role

The role L<Class::Enum::Moose::Role> is applied to the importing module to
allow generic identification of enums.

=head2 Modern Perl

L<Class::Enum::Moose> imports C<strict> and C<warnings> into your enum module.
If L<true> is installed, it is imported as well. To use this you must add
L<true> to your C<dzil.ini>/C<Build.PL>/etc dependencies.

=head2 Moose import options

	use Class::Enum::Moose -moose_opts => [ meta_name => 'foo' ];

Options to L<Moose>'s importer can be placed anywhere in the import list.

=head2 Type coercion

Type coercions are setup from C<Int> via L<Class::Enum/from_ordinal> and C<Str>
via L<Class::Enum/by_value>.

=head1 SEE ALSO

L<Class::Enum>
