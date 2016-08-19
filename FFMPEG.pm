package FFMPEG; 

# cpan
use Moose; 
use namespace::autoclean; 

# pragma
use autodie; 
use warnings FATAL => 'all'; 
use experimental qw(signatures); 

with qw/Video Audio Subtitle/; 

has 'name', (
    is       => 'ro', 
    isa      => 'Str', 
    required => 1, 
); 

has 'ffprobe', ( 
    is       => 'ro', 
    traits   => ['Hash'], 
    lazy     => 1, 
    init_arg => undef, 

    default  => sub ( $self ) { 
        my $ffprobe = {}; 

        open my $pipe, "-|", "ffprobe ${\$self->name} 2>&1"; 
        while ( <$pipe> ) {  
            # video stream, width and height  
            if ( /Stream #0:(\d)(\(.+?\))?: Video:.+?(?<width>\d+)x(?<height>\d+)/ ) { 
                $ffprobe->{video}{$1}->@{qw/width height/} = ( $+{width}, $+{height} ); 
            } 

            # audio/subtitle stream
            if ( /Stream #0:(\d)(?:\((.+?)\))?: (?<stream>audio|subtitle)/i ) {  
                my ( $id, $lang ) = ( $1, $2); 
                my $stream         = $+{stream};  
            
                # default lang 
                $lang //= 'eng'; 

                $ffprobe->{lc($stream)}{$id} = $lang; 
            } 
        }            
        close $pipe; 

        return $ffprobe; 
    },  

    # currying delegation 
    handles => { map { $_ => [ get => $_ ] } qw/video audio subtitle/ },  
); 

sub select_stream ( $self, $stream, $table ) {  
    while (1) { 
        print "$stream:\n"; 
        for my $id ( sort { $a <=> $b } keys $table->%* ) { 
            print "[$id] $table->{$id}\n"; 
        } 
        print "-> "; 
        chomp ( my $choice = <STDIN> ); 
        
        if ( exists $table->{$choice} ) { return $choice }  
    } 
} 

sub BUILD ( $self, @args ) { 
    $self->ffprobe; 
    $self->video_id; 
    $self->audio_id; 
    $self->sub_id; 
} 

1; 
