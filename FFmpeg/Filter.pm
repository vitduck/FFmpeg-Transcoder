package FFmpeg::Filter; 

use Moose::Role; 
use MooseX::Types::Moose qw( Str ArrayRef );  
use FFmpeg::Types 'Filter'; 

use namespace::autoclean; 
use experimental qw( signatures ); 

has 'filter' => ( 
    is        => 'rw', 
    isa       => Filter, 
    predicate => '_has_filter', 
    coerce    => 1, 
); 

has 'scale' => ( 
    is        => 'rw', 
    isa       => Str, 
    predicate => '_has_scale', 
);  

1
