package FFmpeg::Video; 

# pragma
use autodie; 
use warnings FATAL => 'all'; 

# cpan
use Moose::Role;  
use namespace::autoclean; 

# features
use experimental qw(signatures); 

has 'video_id', ( 
    is       => 'ro', 
    isa      => 'Str', 
    lazy     => 1, 
    init_arg => undef, 

    default  => sub ( $self ) { 
        return (keys $self->video->%*)[0]; 
    },  
);   

has 'width', ( 
    is       => 'ro', 
    isa      => 'Int', 
    lazy     => 1, 
    init_arg => undef, 

    default => sub ( $self ) { 
        my $id = $self->video_id;  

        return $self->video->{$id}->{width}; 
    },   
); 

has 'height', ( 
    is       => 'ro', 
    isa      => 'Int', 
    lazy     => 1, 
    init_arg => undef, 

    default => sub ( $self ) { 
        my $id = $self->video_id;  

        return $self->video->{$id}->{height}; 
    },   
); 

1;  
