package FFmpeg::x264; 

use Moose::Role;  
use FFmpeg::Types qw/x264_profile x264_preset x264_tune/;  
use namespace::autoclean; 
use experimental  qw/signatures/; 

with qw/FFmpeg::Video/; 

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

sub _build_filter ( $self ) { 
    my $scale_filter = "scale=${\$self->scaled_width}x${\$self->scaled_height}"; 
    my $ass_filter   = "ass=${\$self->ass}"; 

    return ( 
        $self->has_subtitle ? 
        join(',', $scale_filter, $ass_filter) : 
        $scale_filter 
    )
} 

1;  
