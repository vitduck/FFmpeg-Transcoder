package FFmpeg::Font; 

use Moose::Role;  
use namespace::autoclean; 

has 'font_name', ( 
    is        => 'ro', 
    isa       => 'Str', 
    lazy      => 1, 
    default   => 'PF Armonia'
); 

has 'min_font_size', ( 
    is        => 'ro', 
    isa       => 'Int', 
    lazy      => 1, 
    init_arg  => undef,
    default   => 26, 
); 

has 'max_font_size',  ( 
    is        => 'ro', 
    isa       => 'Int', 
    lazy      => 1, 
    init_arg  => undef,
    default   => 32, 
); 

1  
