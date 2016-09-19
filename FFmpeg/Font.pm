package FFmpeg::Font; 

use strict; 
use warnings FATAL => 'all';  
use namespace::autoclean; 

use Moose::Role;  
use MooseX::Types::Moose qw( Str Int ); 

has 'font_name', ( 
    is       => 'ro', 
    isa      => Str, 
    lazy     => 1, 
    default  => 'PF Armonia'
); 

has 'min_font_size', ( 
    is       => 'ro', 
    isa      => Int, 
    lazy     => 1, 
    init_arg => undef,
    default  => 26, 
); 

has 'max_font_size',  ( 
    is       => 'ro', 
    isa      => Int, 
    lazy     => 1, 
    init_arg => undef,
    default  => 32, 
); 

1;  
