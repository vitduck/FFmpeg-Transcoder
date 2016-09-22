package FFmpeg::Video; 

use Moose::Role;  
use namespace::autoclean; 
use experimental qw( signatures ); 

has 'video', ( 
    is        => 'ro', 
    isa       => 'HashRef', 
    traits    => [ 'Hash' ], 
    lazy      => 1, 
    builder   => '_build_video',
    handles   => { 
        get_video_ids  => 'keys', 
        get_video_size => 'get', 
    }
);   

has 'video_id', ( 
    is        => 'ro', 
    isa       => 'Str', 
    lazy      => 1, 
    init_arg  => undef, 
    builder   => '_build_video_id'
);  

has 'video_size', ( 
    is        => 'ro', 
    isa       => 'HashRef',  
    traits    => [ 'Hash' ],  
    lazy      => 1, 
    init_arg  => undef, 
    builder   => '_build_video_size',
    handles   => { 
        get_video_height => [ get => 'height' ], 
        get_video_width  => [ get => 'width'  ]
    }
); 

has 'scaled_height', ( 
    is        => 'ro', 
    isa       => 'Int', 
    lazy      => 1, 
    default   => 304, 
); 

has 'scaled_width', ( 
    is        => 'ro', 
    isa       => 'Int',  
    lazy      => 1, 
    init_arg  => undef, 
    builder   => '_build_scaled_width'
); 

1;  
