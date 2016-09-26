package FFmpeg::Audio; 

use Moose::Role;  
use MooseX::Types::Moose qw( Str HashRef ); 

use namespace::autoclean; 
use experimental qw( signatures );  

requires qw( probe select_id );  

has 'audio', ( 
    is        => 'ro', 
    isa       => HashRef, 
    traits    => [ 'Hash' ], 
    lazy      => 1, 
    init_arg  => undef, 
    default   => sub { $_[0]->probe( 'audio' ) },  
    handles   => { 
        get_audio     => 'get', 
        get_audio_ids => 'keys'  
    }
);   

has 'audio_id', ( 
    is        => 'ro', 
    isa       => Str, 
    lazy      => 1, 
    init_arg  => undef, 
    default   => sub { $_[0]->select_id( Audio => $_[0]->audio ) }, 
); 

1
