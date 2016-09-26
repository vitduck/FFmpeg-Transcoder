package FFmpeg::FFprobe; 

use autodie; 

use Moose::Role; 
use MooseX::Types::Moose qw( HashRef ); 

use namespace::autoclean; 
use experimental qw( signatures smartmatch );  

requires qw( _build_ffprobe );  

has 'ffprobe', ( 
    is        => 'ro', 
    isa       => HashRef, 
    traits    => [ 'Hash' ], 
    lazy      => 1, 
    init_arg  => undef, 
    builder   => '_build_ffprobe', 
    handles   => { 
        has_subtitle => [ exists => 'subtitle' ]
    }
); 


1 
