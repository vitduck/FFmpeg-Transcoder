package FFmpeg::Video; 

# cpan
use Moose::Role;  
use namespace::autoclean; 

# pragma
use autodie; 
use warnings FATAL => 'all'; 
use experimental qw(signatures); 

# Moose attributes 
has 'video_id', ( 
    is       => 'ro', 
    isa      => 'Str', 
    lazy     => 1, 
    init_arg => undef, 

    default  => sub ( $self ) { 
        (keys $self->video->%*)[0]; 
    },  
);   

has 'width', ( 
    is       => 'ro', 
    isa      => 'Int', 
    lazy     => 1, 
    init_arg => undef, 

    default => sub ( $self ) { 
        $self->video
             ->{$self->video_id}
             ->{width}; 
    },   
); 

has 'height', ( 
    is       => 'ro', 
    isa      => 'Int', 
    lazy     => 1, 
    init_arg => undef, 

    default => sub ( $self ) { 
        $self->video
             ->{$self->video_id}
             ->{height}; 
    }
); 

1;  
