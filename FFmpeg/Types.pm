package FFmpeg::Types; 

use strict; 
use warnings FATAL => 'all'; 
use namespace::autoclean; 

use MooseX::Types::Moose qw( Str Int );  
use MooseX::Types -declare => [ qw( x264_profile x264_preset x264_tune ) ];   

use experimental qw( smartmatch ); 

my @profile = qw( baseline main high high10 high422 high44 ); 
my @preset  = qw( ultrafast superfast veryfast faster fast medium slow slower veryslow placebo );  
my @tune    = qw( film animation grain stillimage psnr ssim ); 

subtype x264_profile, as Str, where { $_ ~~ @profile }; 
subtype x264_preset , as Str, where { $_ ~~ @preset  }; 
subtype x264_tune   , as Str, where { $_ ~~ @tune    }; 
