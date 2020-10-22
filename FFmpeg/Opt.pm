package FFmpeg::Opt; 

use Moose::Role; 
use FFmpeg::Types qw( Stats Log_Level Overwrite ); 

has 'log_level' => ( 
    is        => 'rw', 
    isa       => Log_Level, 
    predicate => '_has_log_level',
    lazy      => 1, 
    coerce    => 1,
    default   => '32' 
); 

has 'stats' => ( 
    is        => 'rw', 
    isa       => Stats, 
    predicate => '_has_stats',
    lazy      => 1, 
    coerce    => 1,
    default   => '1' 
); 

has 'overwrite' => ( 
    is        => 'rw', 
    isa       => Overwrite, 
    predicate => '_has_overwrite',
    coerce    => 1,
    default   => 1
); 

1
