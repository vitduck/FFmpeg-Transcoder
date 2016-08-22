package FFmpeg::Audio; 

# cpan
use Moose::Role;  
use namespace::autoclean; 

# pragma
use autodie; 
use warnings FATAL => 'all'; 
use experimental qw(signatures); 

requires 'select_stream'; 

has 'audio_id', ( 
    is       => 'ro', 
    isa      => 'Str', 
    lazy     => 1, 

    default  => sub ( $self ) { 
        keys $self->audio->%* == 1 ? 
        (keys $self->video->%*)[0] :
        $self->select_stream('Audio', $self->audio); 
    } 
);   

1;  
