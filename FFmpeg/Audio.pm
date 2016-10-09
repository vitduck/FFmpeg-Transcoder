package FFmpeg::Audio; 

use Moose::Role;  
use MooseX::Types::Moose qw( Str HashRef ); 
use namespace::autoclean; 
use experimental qw( signatures );  

requires qw( _build_audio _select_id );  

has 'audio', ( 
    is        => 'ro', 
    isa       => HashRef, 
    traits    => [ 'Hash' ], 
    lazy      => 1, 
    init_arg  => undef, 
    default   => sub { $_[0]->_build_audio }, 
);   

has 'audio_id', ( 
    is        => 'ro', 
    isa       => Str, 
    lazy      => 1, 
    init_arg  => undef, 
    reader    => 'get_audio_id', 
    default   => sub { $_[0]->_select_id( 'audio' ) } 
); 

1
