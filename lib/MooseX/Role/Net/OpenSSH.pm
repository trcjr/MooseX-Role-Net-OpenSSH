package MooseX::Role::Net::OpenSSH;
use Moose::Role;
use namespace::clean -except => 'meta';
use Net::OpenSSH;
use Data::Dumper;

# ABSTRACT: A Moose role that provides a Net::OpenSSH Object
# VERSION

has 'ssh' => (
    isa        => 'Net::OpenSSH',
    is         => 'ro',
    lazy_build => 1,
);

for my $name ( qw/ ssh_hostname ssh_username / ) {
    my $builder = '_build_' . $name;
    my $writer  = '_set_' . $name;
    has $name => (
        is         => 'ro',
        isa        => 'Str',
        builder    => $builder,
        writer     => $writer,
        lazy_build => 1,
    );
}

has 'ssh_options' => (
    isa        => 'HashRef',
    is         => 'ro',
    lazy_build => 1,
);

sub _build_ssh {
    my $self = shift;
    Net::OpenSSH->new( $self->ssh_hostname, %{ $self->ssh_options } );
}

1;
