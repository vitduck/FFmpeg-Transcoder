package FFmpeg::Video; 

use Moose::Role;  
use MooseX::Types::Moose qw( Str Int HashRef ); 
use namespace::autoclean; 
use experimental qw( signatures ); 

requires qw( probe ); 

has 'video', ( 
    is        => 'ro', 
    isa       => HashRef, 
    traits    => [ qw( Hash ) ], 
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
    traits    => [ qw( Hash ) ],  
    lazy      => 1, 
    init_arg  => undef, 
    default   => sub { $_[0]->get_video_size( $_[0]->video_id ) }, 
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
    default   => sub ( $self ) { 
        my $width  = $self->get_video_width; 
        my $height = $self->get_video_height; 

        return 16 * int( $self->scaled_height * $width / $height / 16 ) 
    } 
); 

1  
