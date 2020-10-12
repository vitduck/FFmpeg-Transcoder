package FFmpeg::Transcoder; 

use Moose; 
use MooseX::Types::Moose qw( Str ); 
use File::Basename; 
use Data::Printer; 

use FFmpeg::Types qw(Input Stats Log_Level Overwrite); 

use namespace::autoclean; 
use experimental qw( signatures ); 

with qw( 
    FFmpeg::FFprobe FFmpeg::Filter 
    FFmpeg::Cuda FFmpeg::Video FFmpeg::Audio );  

has 'input', (
    is            => 'rw', 
    isa           => Input,   
    predicate     => '_has_input',
    coerce        => 1,
); 

has 'output', ( 
    is            => 'rw', 
    isa           => Str, 
    predicate     => '_has_output',
    default       => sub { 
        mkdir 'output'; 
        join('/', 'output', basename((split ' ', shift->input)[1])) 
    },  
); 

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
    default   => '0' 
); 

has 'overwrite' => ( 
    is        => 'rw', 
    isa       => Overwrite, 
    predicate => '_has_overwrite',
    coerce    => 1,
    default   => 1
); 

sub BUILD ( $self, @ ) { 
    $self->_ffprobe; 

    # cuvid decoder 
    if ( $self->decoder =~ /(h264|hevc|mpeg1|mpeg2|mpeg4|vc1|vp8|vp9)/ ) { 
        $self->hwaccel; 
        $self->hwdecoder; 
    } 
} 

sub transcode ( $self ) { 
    my @cmd = ('ffmpeg'); 

    
    for my $opt ( qw( hwaccel hwdecoder device input filter
                      video video_bitrate video_profile video_preset
                      audio audio_bitrate audio_profile 
                      log_level stats overwrite
                      output ) ) { 
        my $has = join('_', '_has', $opt); 
        push @cmd, $self->$opt if $self->$has; 
    }

    p @cmd; 
    # system(join ' ', @cmd);
} 

# sub extract_sub ( $self ) { 
    # system 
        # 'ffmpeg', 
        # '-y', '-loglevel', 'fatal', 
        # '-i', $self->get_input, 
        # '-map', $self->get_subtitle_id, 
        # $self->get_ass; 
# } 

__PACKAGE__->meta->make_immutable;

1
