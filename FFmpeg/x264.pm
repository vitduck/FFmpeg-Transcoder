package FFmpeg::x264; 

# pragma
use autodie; 
use warnings FATAL => 'all'; 

# cpan
use Moose::Role;  
use MooseX::Types; 
use namespace::autoclean; 

# features
use experimental qw/signatures/; 

# Moose attributes 
has 'profile', ( 
    is       => 'rw', 
    isa      => enum([ qw/baseline main high high10 high422 high44]/ ]), 
    lazy     => 1, 

    default  => 'main', 
); 

has 'preset', ( 
    is       => 'rw',
    isa      => enum([ qw/ultrafast superfast veryfast faster fast 
                          medium slow slower veryslow placebo/ ]), 
    lazy     => 1, 
    
    default  => 'fast', 
); 

has 'tune', ( 
    is       => 'rw', 
    isa      => enum([ qw/film animation grain 
                          stillimage psnr ssim/ ]), 
    lazy     => 1, 

    default  => 'film', 
); 

has 'crf', ( 
    is       => 'rw', 
    isa      => 'Int', 
    lazy     => 1, 

    default  => '25', 
); 

1;  
