package FFmpeg::Transcoder; 

use Moose; 
use MooseX::Types::Moose qw( Str );  

use namespace::autoclean; 
use experimental 'signatures'; 

with qw( 
    MooseX::Getopt::Usage
    FFmpeg::FFprobe FFmpeg::Audio FFmpeg::Video 
    FFmpeg::Opt FFmpeg::Cuda FFmpeg::Filter FFmpeg::Output 
); 

has  cmd => (
    is       => 'ro', 
    isa      => Str,
    init_arg => undef, 
    lazy     => 1, 
    default  => sub ($self) { 
        my @ffmpeg_opts = ( 'ffmpeg' ); 

        for my $opt ( qw( 
                          log_level stats overwrite
                          device hwaccel hwdecoder 
                          input 
                          filter video video_bitrate video_profile video_preset
                          audio audio_bitrate audio_profile 
                        ) 
                    ) { 
            my $has = join('_', '_has', $opt); 
            push @ffmpeg_opts, $self->$opt if $self->$has; 
        }

        push @ffmpeg_opts, $self->outfile; 

        join (' ', @ffmpeg_opts)
    }
); 

sub run ( $self ) { 
    system( $self->cmd ); 
} 

sub BUILD ( $self, @ ) { 
    $self->_ffprobe; 
    
    # cuvid decoder 
    if ( $self->decoder =~ /(h264|hevc|mpeg1|mpeg2|mpeg4|vc1|vp8|vp9)/ ) { 
        $self->hwaccel; 
        $self->hwdecoder; 
    } 
} 

sub getopt_usage_config {
    return (
       attr_sort => sub { $_[0]->name cmp $_[1]->name }
    );
}

__PACKAGE__->meta->make_immutable;

1
