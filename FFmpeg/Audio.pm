package FFmpeg::Audio; 

use strict; 
use warnings FATAL => 'all'; 

use Moose::Role;  
use MooseX::Types::Moose qw( Str HashRef ); 

use namespace::autoclean; 
use experimental qw(signatures); 

requires 'select_id'; 

has 'audio', ( 
    is       => 'ro', 
    isa      => HashRef, 
    traits   => [ 'Hash' ], 
    lazy     => 1, 
    init_arg => undef, 

    default  => sub ( $self ) { 
        return $self->probe( 'audio' )  
    },  

    handles  => { 
        get_audio     => 'get', 
        get_audio_ids => 'keys' 
    }
);   

has 'audio_id', ( 
    is       => 'ro', 
    isa      => Str, 
    lazy     => 1, 
    init_arg => undef, 
    
    default  => sub ( $self ) { 
        return $self->select_id( Audio => $self->audio )
    }
); 

1;  
