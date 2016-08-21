package FFmpeg::x264; 

# cpan
use Moose::Role;  
use MooseX::Types; 
use namespace::autoclean; 

# pragma
use autodie; 
use warnings FATAL => 'all'; 
use experimental qw/signatures/; 

# Moose attributes 
has 'profile', ( 
    is       => 'ro', 
    isa      => enum([ qw/baseline main high high10 high422 high44]/ ]), 
    lazy     => 1, 
    default  => 'main', 
); 

has 'preset', ( 
    is       => 'ro',
    isa      => enum([ qw/ultrafast superfast veryfast faster fast 
                          medium slow slower veryslow placebo/ ]), 
    lazy     => 1, 
    default  => 'fast', 
); 

has 'tune', ( 
    is       => 'ro', 
    isa      => enum([ qw/film animation grain 
                          stillimage psnr ssim/ ]), 
    lazy     => 1, 
    default  => 'film', 
); 

has 'crf', ( 
    is       => 'ro', 
    isa      => 'Int', 
    lazy     => 1, 
    default  => '25', 
); 

1;  
