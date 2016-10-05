package FFmpeg::FFprobe; 

use Moose::Role; 
use MooseX::Types::Moose qw( HashRef ); 
use autodie; 
use namespace::autoclean; 
use experimental qw( signatures smartmatch );  

requires qw( _build_ffprobe );  

has 'ffprobe', ( 
    is        => 'ro', 
    isa       => HashRef, 
    traits    => [ qw( Hash ) ], 
    lazy      => 1, 
    init_arg  => undef, 
    builder   => '_build_ffprobe', 

    handles   => { 
        probe        => 'get', 
        has_subtitle => [ exists => 'subtitle' ]
    }
); 

1 
