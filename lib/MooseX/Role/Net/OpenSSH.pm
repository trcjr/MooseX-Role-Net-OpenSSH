package MooseX::Role::Net::OpenSSH;
use MooseX::Role::Parameterized;
use namespace::clean -except => 'meta';
use MooseX::AttributeShortcuts;
use MooseX::Types::Moose qw{ Str Bool };
use Net::OpenSSH;

# VERSION

parameter name => ( is => 'ro', isa => Str, default => 'ssh' );

# traits, if any, for our attributes
parameter traits => (
    traits  => [ 'Array' ],
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    default => sub { [] },
    handles => { all_traits => 'elements' },
);

role {
    my $p = shift @_;

    my $name = $p->name;

    my $traits = [ Shortcuts, $p->all_traits ];
    my @defaults = ( traits => $traits, is => 'rw', lazy_build => 1 );

    # generate our attribute & builder names... nicely sequential tho :)
    my $a = sub { $name . '_' . shift @_ };
    my $b = sub { '_build_' . $name . '_' . shift @_ };

    if ( $p->login_info ) {

        has $a->( 'username' ) => ( @defaults, isa => Str );

        requires $b->( 'username' );
    }

    has $a->( 'hostname' ) => ( @defaults, isa => Str );

    # if we have a uri, use it; otherwise require its builder
    #if ( $p->has_ssh_hostname ) {
    #    method $b->( 'uri' ) => sub { $p->uri }
    #} else {
    #    requires $b->( 'uri' );
    #}

    has $a->( 'ssh' ) => ( @defaults, isa => 'Net::OpenSSH' );

    my $hostname_method = $a->( 'hostname' );

    # create our RPC::XML::Client appropriately
    method $b->( 'ssh' ) => sub {
        my $self = shift @_;

        return Net::OpenSSH->new( $self->$hostname_method, %{ $self->ssh_options } );

    };
};

1;
