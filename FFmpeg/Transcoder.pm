package FFmpeg::Transcoder; 

use Moose; 
use MooseX::Types::Moose 'Str'; 
use Data::Printer; 
use File::Basename; 
use FFmpeg::Types qw(Input Overwrite); 

use namespace::autoclean; 
use experimental 'signatures'; 

with qw( FFmpeg::FFprobe FFmpeg::Cuda FFmpeg::Filter );  

has 'input', (
    is            => 'rw', 
    isa           => Input,   
    predicate     => '_has_input',
    coerce        => 1,
); 

sub BUILD ( $self, @ ) { 
    $self->_ffprobe; 
    
    # cuvid decoder 
    if ( $self->decoder =~ /(h264|hevc|mpeg1|mpeg2|mpeg4|vc1|vp8|vp9)/ ) { 
        $self->hwaccel; 
        $self->hwdecoder; 
    } 
} 

__PACKAGE__->meta->make_immutable;

1
