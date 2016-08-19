package FFmpeg::Subtitle; 

# pragma
use autodie; 
use warnings FATAL => 'all'; 

# core 
use File::Basename; 

# cpan
use Moose::Role;  
use namespace::autoclean; 

# features
use experimental qw(signatures); 

requires 'select_stream'; 

has 'sub_id', ( 
    is       => 'ro', 
    isa      => 'Int', 
    lazy     => 1, 
    init_arg => undef, 

    default  => sub ( $self ) { 
        return $self->select_stream('Subtitle', $self->subtitle); 
    },  
);   

has 'ass', ( 
    is       => 'ro', 
    isa      => 'Str', 
    lazy     => 1, 
    init_arg => undef, 

    default  => sub ( $self ) { 
        return my $ass = $self->name =~ s/(.*)\..+?$/$1.ass/r; 
    },  
); 

sub extract_sub ( $self ) { 
    system "ffmpeg -y -loglevel fatal  -i ${\$self->name} -map 0:${\$self->sub_id} ${\$self->ass}"; 
} 

1;  
