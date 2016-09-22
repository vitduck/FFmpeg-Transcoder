package FFmpeg::Subtitle; 

use Moose::Role;  
use MooseX::Types::Moose qw( Str Int HashRef ); 
use File::Basename; 
use namespace::autoclean; 
use experimental qw( signatures ); 

has 'subtitle', ( 
    is       => 'ro', 
    isa      => HashRef, 
    traits   => [ 'Hash' ], 
    lazy     => 1, 
    init_arg => undef, 
    builder  => '_build_subtitle', 
    handles  => { get_subtitle_ids => 'keys' }
);   

has 'subtitle_id', ( 
    is        => 'ro', 
    isa       => Str, 
    lazy      => 1, 
    init_arg  => undef, 
    builder   => '_build_subtitle_id', 
);   

has 'ass', ( 
    is       => 'ro', 
    isa      => Str, 
    lazy     => 1, 
    init_arg => undef, 
    builder  => '_build_ass', 
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

1  
