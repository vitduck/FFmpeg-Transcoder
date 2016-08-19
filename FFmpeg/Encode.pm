package FFmpeg::Encode; 

# cpan
use Moose; 
use namespace::autoclean; 

# pragma
use autodie; 
use warnings FATAL => 'all'; 
use experimental qw(signatures); 

with 'FFmpeg::FFprobe', 
     'FFmpeg::Video', 
     'FFmpeg::Audio', 
     'FFmpeg::Subtitle'; 

has 'name', (
    is       => 'ro', 
    isa      => 'Str', 
    required => 1, 
); 

has 'scaled_height', ( 
    is       => 'ro', 
    isa      => 'Int', 
    required => 1, 
); 

has 'scaled_width', ( 
    is       => 'ro', 
    isa      => 'Int', 
    lazy     => 1, 
    init_arg => undef, 

    default  => sub ( $self ) { 
        return int($self->scaled_height * $self->width / $self->height);   
    },  
); 

sub BUILD ( $self, @args ) { 
    $self->ffprobe; 
} 

1; 
