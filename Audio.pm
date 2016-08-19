package Audio; 

# pragma
use autodie; 
use warnings FATAL => 'all'; 

# cpan
use Moose::Role;  
use namespace::autoclean; 

# features
use experimental qw(signatures); 

requires 'select_stream'; 

has 'audio_id', ( 
    is       => 'ro', 
    isa      => 'Int', 
    lazy     => 1, 
    init_arg => undef, 

    default  => sub ( $self ) { 
        return $self->select_stream('Audio', $self->audio); 
    },  
);   

1;  
