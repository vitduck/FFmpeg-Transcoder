package Subtitle; 

# pragma
use autodie; 
use warnings FATAL => 'all'; 

# cpan
use Moose::Role;  
use namespace::autoclean; 

# features
use experimental qw(signatures); 

requires 'select_stream'; 

has 'sub_id', ( 
    is       => 'ro', 
    isa      => 'Int', 
    lazy     => 1, 
    init_arg => undef, 

    default  => sub ( $self ) { 
        return $self->select_stream('Subtitle', $self->subtitle); 
    },  
);   

1;  
