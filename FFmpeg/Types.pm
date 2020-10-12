package FFmpeg::Types; 

use MooseX::Types::Moose qw( Str Int ); 
use MooseX::Types -declare => [ qw( Input Hwaccel Hwdecoder Device 
                                    Audio Audio_Bitrate Audio_Profile
                                    Video Video_Bitrate Video_Profile Video_Preset
                                    Filter 
                                    Log_Level Stats Overwrite ) 
                              ]; 

subtype Input,         as Str, where { /^-/ };  
subtype Hwaccel,       as Str, where { /^-/ };  
subtype Hwdecoder,     as Str, where { /^-/ };  
subtype Device,        as Str, where { /^-/ };  
subtype Audio,         as Str, where { /^-/ };  
subtype Audio_Bitrate, as Str, where { /^-/ };  
subtype Audio_Profile, as Str, where { /^-/ };  
subtype Video,         as Str, where { /^-/ };  
subtype Video_Bitrate, as Str, where { /^-/ };  
subtype Video_Profile, as Str, where { /^-/ };  
subtype Video_Preset,  as Str, where { /^-/ };  
subtype Filter,        as Str, where { /^-/ }; 
subtype Log_Level,     as Str, where { /^-/ }; 
subtype Overwrite,     as Str, where { /^-/ }; 
subtype Stats,         as Str, where { /^-/ }; 

coerce  Input,         from Str, via { join(' ', '-i',              shift) };  
coerce  Hwaccel,       from Str, via { join(' ', '-hwaccel',        shift) };  
coerce  Hwdecoder,     from Str, via { join(' ', '-c:v',            shift) };  
coerce  Device,        from Str, via { join(' ', '-hwaccel_device', shift) };  
coerce  Audio,         from Str, via { join(' ', '-c:a',            shift) }; 
coerce  Audio_Bitrate, from Str, via { join(' ', '-b:a',            shift) }; 
coerce  Audio_Profile, from Str, via { join(' ', '-profile:a',      shift) }; 
coerce  Video,         from Str, via { join(' ', '-c:v',            shift) }; 
coerce  Video_Bitrate, from Str, via { join(' ', '-b:v',            shift) }; 
coerce  Video_Profile, from Str, via { join(' ', '-profile:v',      shift) }; 
coerce  Video_Preset,  from Str, via { join(' ', '-preset',         shift) }; 
coerce  Filter,        from Str, via { join(' ', '-vf',             shift) };  
coerce  Log_Level,     from Str, via { join(' ', '-loglevel',       shift) };  
coerce  Overwrite,     from Str, via { shift ? '-y'     : '-n'       };  
coerce  Stats,         from Str, via { shift ? '-stats' : '-nostats' };  

1
