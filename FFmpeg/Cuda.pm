package FFmpeg::Cuda; 

use Moose::Role;  
use FFmpeg::Types qw( Hwaccel Hwdecoder Device ); 

use namespace::autoclean; 
use experimental 'signatures';  

has 'hwaccel' => ( 
    is        => 'rw', 
    isa       => Hwaccel, 
    init_arg  => undef, 
    predicate => '_has_hwaccel',
    coerce    => 1, 
    lazy      => 1, 
    default   => 'cuvid',
);   

has 'hwdecoder' => ( 
    is        => 'rw', 
    isa       => Hwdecoder,
    init_arg  => undef, 
    predicate => '_has_hwdecoder', 
    coerce    => 1, 
    lazy      => 1, 
    default   => sub { join('_', shift->decoder, 'cuvid') }
);   

has 'device' => ( 
    is        => 'rw', 
    isa       => Device,
    predicate => '_has_device',
    coerce    => 1, 
    default   => 0,
);   

1
