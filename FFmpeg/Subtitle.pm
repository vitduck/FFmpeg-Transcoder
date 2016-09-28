package FFmpeg::Subtitle; 

use File::Basename; 

use Moose::Role;  
use MooseX::Types::Moose qw( Str Int HashRef ); 

use namespace::autoclean; 
use experimental qw( signatures ); 

requires qw( ffprobe ); 
requires qw( select_id ); 

has 'subtitle', ( 
    is       => 'ro', 
    isa      => HashRef, 
    traits   => [ 'Hash' ], 
    lazy     => 1, 
    init_arg => undef, 
    builder  => '_build_sub', 
    handles  => { 
        get_subtitle_ids => 'keys' 
    }
);   

has 'subtitle_id', ( 
    is        => 'ro', 
    isa       => Str, 
    lazy      => 1, 
    init_arg  => undef, 
    builder   => '_build_sub_id'
);   

has 'font_name', ( 
    is        => 'ro', 
    isa       => Str, 
    lazy      => 1, 
    default   => 'PF Armonia'
); 

has 'min_font_size', ( 
    is        => 'ro', 
    isa       => Int, 
    lazy      => 1, 
    init_arg  => undef,
    default   => 26, 
); 

has 'max_font_size',  ( 
    is        => 'ro', 
    isa       => Int, 
    lazy      => 1, 
    init_arg  => undef,
    default   => 32, 
); 

sub _build_sub ( $self ) { 
    return $self->ffprobe->{ 'subtitle' } 
}

sub _build_sub_id ( $self ) { 
    return $self->select_id( 'subtitle' ) 
}

sub clean_sub ( $self ) { 
    unlink $self->ass if $self->has_subtitle 
} 

1  
