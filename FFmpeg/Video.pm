package FFmpeg::Video; 

use namespace::autoclean; 
use experimental qw( signatures ); 

use Moose::Role;  
use FFmpeg::Types qw(Video Video_Bitrate Video_Profile Video_Preset); 

has 'video', ( 
    is        => 'rw', 
    isa       => Video, 
    predicate => '_has_video',
    coerce    => 1, 
    default   => 'hevc_nvenc'
); 

has 'video_bitrate', ( 
    is        => 'rw', 
    isa       => Video_Bitrate, 
    predicate => '_has_video_bitrate',
    coerce    => 1, 
    default   => '400K'
); 

has 'video_profile', ( 
    is        => 'rw', 
    isa       => Video_Profile, 
    predicate => '_has_video_profile',
    coerce    => 1, 
    default   => 'main10'
); 

has 'video_preset', ( 
    is        => 'rw', 
    isa       => Video_Preset, 
    predicate => '_has_video_preset',
    coerce    => 1, 
    default   => 'slow'
); 

1  
