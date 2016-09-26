package FFmpeg::Video; 

use Moose::Role;  
use MooseX::Types::Moose qw( Str Int HashRef ); 

use FFmpeg::Types qw( Profile Preset Tune ); 

use namespace::autoclean; 
use experimental qw( signatures ); 

requires qw( probe select_id ); 

has 'video', ( 
    is        => 'ro', 
    isa       => HashRef, 
    traits    => [ 'Hash' ], 
    lazy      => 1, 
    init_arg  => undef, 
    default   => sub { $_[0]->probe( 'video' ) },  
    handles   => { 
        get_video_ids  => 'keys', 
        get_video_size => 'get', 
    }
);   

has 'video_id', ( 
    is        => 'ro', 
    isa       => Str, 
    lazy      => 1, 
    init_arg  => undef, 
    default   => sub { ( $_[0]->get_video_ids )[0] }
);  

has 'video_size', ( 
    is        => 'ro', 
    isa       => HashRef,  
    traits    => [ 'Hash' ],  
    lazy      => 1, 
    init_arg  => undef, 
    default   => sub { $_[0]->get_video_size( $_[0]->video_id ) }, 
    handles   => { 
        get_video_height => [ get => 'height' ], 
        get_video_width  => [ get => 'width'  ]
    }
); 

has 'scaled_height', ( 
    is        => 'ro', 
    isa       => Int, 
    lazy      => 1, 
    default   => 304, 
); 

has 'scaled_width', ( 
    is        => 'ro', 
    isa       => Int,  
    lazy      => 1, 
    init_arg  => undef, 
    builder   => '_build_scaled_width'
); 

has 'profile', ( 
    is       => 'ro', 
    isa      => Profile, 
    lazy     => 1, 
    default  => 'main', 
); 

has 'preset', ( 
    is       => 'ro',
    isa      => Preset,  
    lazy     => 1, 
    default  => 'fast', 
); 

has 'tune', ( 
    is       => 'ro', 
    isa      => Tune, 
    lazy     => 1, 
    default  => 'film', 
); 

has 'crf', ( 
    is       => 'ro', 
    isa      => Int, 
    lazy     => 1, 
    default  => '25', 
); 

has 'filter', ( 
    is       => 'ro', 
    isa      => Str, 
    lazy     => 1, 
    init_arg => undef, 
    builder  => '_build_filter', 
); 

sub _build_scaled_width ( $self ) { 
    my $width  = $self->get_video_width; 
    my $height = $self->get_video_height; 

    return 16 * int( $self->scaled_height * $width / $height / 16 ) 
} 

1;  
