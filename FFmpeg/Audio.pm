package FFmpeg::Audio; 

use namespace::autoclean; 
use experimental qw( signatures );  

use Moose::Role;  
use FFmpeg::Types qw(Audio Audio_Bitrate Audio_Profile); 

has 'audio' => ( 
    is        => 'rw', 
    isa       => Audio, 
    predicate => '_has_audio',
    coerce    => 1, 
    default   => 'libfdk_aac',
);   

has 'audio_bitrate' => ( 
    is        => 'rw', 
    isa       => Audio_Bitrate, 
    predicate => '_has_audio_bitrate',
    coerce    => 1, 
    default   => '128K',
);   

has 'audio_profile' => ( 
    is        => 'rw', 
    isa       => Audio_Profile, 
    predicate => '_has_audio_profile',
    coerce    => 1, 
    default   => 'aac_he',
);   

1
