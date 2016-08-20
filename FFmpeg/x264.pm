package FFmpeg::x264; 

# pragma
use autodie; 
use warnings FATAL => 'all'; 

# cpan
use Moose::Role;  
use namespace::autoclean; 

# features
use experimental qw(signatures); 

# Moose attributes 
has 'profile', ( 
    is       => 'ro', 
    isa      => 'Str', 
    lazy     => 1, 
    init_arg => undef, 

    default  => 'main', 
); 

has 'preset', ( 
    is       => 'ro',
    isa      => 'Str', 
    lazy     => 1, 
    init_arg => undef, 

    default  => 'fast', 
); 

has 'tune', ( 
    is       => 'ro', 
    isa      => 'Str', 
    lazy     => 1, 
    init_arg => undef, 

    default  => 'film', 
); 

has 'crf', ( 
    is       => 'ro', 
    isa      => 'Int', 
    lazy     => 1, 
    init_arg => undef, 

    default  => '25', 
); 

1;  
