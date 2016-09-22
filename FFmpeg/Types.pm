package FFmpeg::Types; 

use strict; 
use warnings; 

use MooseX::Types::Moose qw( Str ); 
use MooseX::Types -declare => [ qw( Profile Preset Tune ) ]; 
use experimental qw( smartmatch ); 

my @profile = qw( baseline main high high10 high422 high44 );  
my @preset  = qw( ultrafast superfast veryfast faster fast medium slow slower veryslow placebo );  
my @tune    = qw( film animation grain stillimage psnr ssim );  

subtype Profile, as Str, where { $_ ~~ @profile }; 
subtype Preset,  as Str, where { $_ ~~ @preset  }; 
subtype Tune,    as Str, where { $_ ~~ @tune    };

1
