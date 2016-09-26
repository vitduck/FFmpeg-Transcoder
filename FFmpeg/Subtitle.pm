package FFmpeg::Subtitle; 

use File::Basename; 

use Moose::Role;  
use MooseX::Types::Moose qw( Str Int HashRef ); 

use namespace::autoclean; 
use experimental qw( signatures ); 

requires qw( probe select_id ); 

has 'subtitle', ( 
    is       => 'ro', 
    isa      => HashRef, 
    traits   => [ 'Hash' ], 
    lazy     => 1, 
    init_arg => undef, 
    default  => sub { $_[0]->probe( 'subtitle' ) },  
    handles  => { 
        get_subtitle_ids => 'keys' 
    }
);   

has 'subtitle_id', ( 
    is        => 'ro', 
    isa       => Str, 
    lazy      => 1, 
    init_arg  => undef, 
    default   => sub { $_[0]->select_id( Subtitle => $_[0]->subtitle ) }
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

sub clean_sub ( $self ) { 
    unlink $self->ass if $self->has_subtitle;  
} 

1  
