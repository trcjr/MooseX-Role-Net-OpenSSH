{
package Tests::MooseX::Role::Net::OpenSSH::DummyThing;
use Moose;
with 'MooseX::Role::Net::OpenSSH';
}

package Tests::MooseX::Role::Net::OpenSSH;
use Test::Class::Most parent => 'Tests::MooseX::Role::Net::OpenSSH::Base';
use strict;
use warnings;
use Test::MockObject::Extends;
use Data::Dumper;

sub setup : Tests(setup) {
    my $self = shift;
    $self->SUPER::setup;
}

sub theo : Tests {
    my $self = shift;

    ok 1;

    my $thing = Tests::MooseX::Role::Net::OpenSSH::DummyThing->new;

    warn Dumper $thing;

}

1;
