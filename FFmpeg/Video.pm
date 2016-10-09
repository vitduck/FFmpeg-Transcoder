package FFmpeg::Video; 

use Moose::Role;  
use MooseX::Types::Moose qw( Str Int HashRef );
use namespace::autoclean; 
use experimental qw( signatures ); 

requires qw( _build_video );  

has 'video', ( 
    is        => 'ro', 
    isa       => HashRef, 
    traits    => [ 'Hash' ], 
    lazy      => 1, 
    init_arg  => undef, 
    default   => sub { $_[0]->_build_video }, 
    handles   => { 
        get_video_size => 'get', 
    }
);   

has 'video_id', ( 
    is        => 'ro', 
    isa       => Str, 
    lazy      => 1, 
    init_arg  => undef, 
    reader    => 'get_video_id', 
    default   => sub { ( keys $_[0]->video->%* )[0] }
);  

has 'video_size', ( 
    is        => 'ro', 
    isa       => HashRef,  
    traits    => [ 'Hash' ],  
    lazy      => 1, 
    init_arg  => undef, 
    default   => sub { $_[0]->get_video_size( $_[0]->get_video_id ) }, 
    handles   => { 
        get_video_height => [ get => 'height' ], 
        get_video_width  => [ get => 'width'  ]
    }
); 

has 'scaled_width', ( 
    is        => 'ro', 
    isa       => Int,  
    lazy      => 1, 
    init_arg  => undef, 
    reader    => 'get_scaled_width',
    default   => sub ( $self ) { 
        my $width  = $self->get_video_width; 
        my $height = $self->get_video_height; 
        my $swidth = $self->get_scaled_height; 

        return 16 * int( $swidth  * $width / $height / 16 ) 
    } 
); 

1  
