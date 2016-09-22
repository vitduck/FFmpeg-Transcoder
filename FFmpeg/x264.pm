package FFmpeg::x264; 

use Moose::Role;  
use Moose::Util::TypeConstraints;
use namespace::autoclean; 
use experimental qw( signatures smartmatch ); 

my @profile = qw( baseline main high high10 high422 high44 );  
my @preset  = qw( ultrafast superfast veryfast faster fast medium slow slower veryslow placebo );  
my @tune    = qw( film animation grain stillimage psnr ssim );  

subtype 'x264_profile' => as Str => where { $_ ~~ @profile }; 
subtype 'x264_preset'  => as Str => where { $_ ~~ @preset  }; 
subtype 'x264_tune'    => as Str => where { $_ ~~ @tune    };

has 'profile', ( 
    is       => 'ro', 
    isa      => 'x264_profile', 
    lazy     => 1, 
    default  => 'main', 
); 

has 'preset', ( 
    is       => 'ro',
    isa      => 'x264_preset', 
    lazy     => 1, 
    default  => 'fast', 
); 

has 'tune', ( 
    is       => 'ro', 
    isa      => 'x264_tune', 
    lazy     => 1, 
    default  => 'film', 
); 

has 'crf', ( 
    is       => 'ro', 
    isa      => 'Int', 
    lazy     => 1, 
    default  => '25', 
); 

has 'filter', ( 
    is       => 'ro', 
    isa      => 'Str', 
    lazy     => 1, 
    init_arg => undef, 
    builder  => '_build_filter', 
); 

1;  
