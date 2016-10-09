package FFmpeg::Getopt; 

use Moose; 
use MooseX::Types::Moose qw( Str Int );  
use FFmpeg::Types qw( Profile Preset Tune ); 
use namespace::autoclean; 

with qw( MooseX::Getopt::Usage );  

has 'input', (
    is        => 'ro', 
    isa       => Str,   
    reader    => 'get_input', 
    required  => 1, 
    documentation => 'Source file' 
); 

has 'scaled_height', ( 
    is        => 'ro', 
    isa       => Int, 
    lazy      => 1, 
    reader    => 'get_scaled_height', 
    default   => 304, 
    documentation => 'Rescaled height'
); 

has 'font_name', ( 
    is        => 'ro', 
    isa       => Str, 
    lazy      => 1, 
    reader    => 'get_font_name', 
    default   => 'PF Armonia', 
    documentation => 'Replaced font forsubtitle'
); 

has 'profile', ( 
    is        => 'ro', 
    isa       => Profile, 
    lazy      => 1, 
    reader    => 'get_profile', 
    default   => 'main', 
    documentation => 'x264 profile'
); 

has 'preset', ( 
    is        => 'ro',
    isa       => Preset,  
    lazy      => 1, 
    reader    => 'get_preset', 
    default   => 'fast', 
    documentation => 'x264 preset'
); 

has 'tune', ( 
    is        => 'ro', 
    isa       => Tune, 
    lazy      => 1, 
    reader    => 'get_tune', 
    default   => 'film', 
    documentation => 'x264 tune'
); 

has 'crf', ( 
    is        => 'ro', 
    isa       => Int, 
    lazy      => 1, 
    reader    => 'get_crf', 
    default   => '25', 
    documentation => 'x264 crt'
); 

1
