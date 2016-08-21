package FFmpeg::Subtitle; 

# core 
use File::Basename; 

# cpan
use Moose::Role;  
use namespace::autoclean; 

# pragma
use autodie; 
use warnings FATAL => 'all'; 
use experimental qw(signatures); 

requires 'select_stream'; 

# Moose attributes 
has 'sub_id', ( 
    is        => 'ro', 
    isa       => 'Str', 
    lazy      => 1, 
    init_arg  => undef, 

    default   => sub ( $self ) { 
        $self->has_subtitle ? 
        $self->select_stream('Subtitle', $self->subtitle) : 
        'none'; 
    },  
);   

has 'ass', ( 
    is       => 'ro', 
    isa      => 'Str', 
    lazy     => 1, 
    init_arg => undef, 

    default  => sub ( $self ) { 
        my $ass = basename($self->input) =~ s/(.*)\..+?$/$1.ass/r;  
    },  
); 

sub extract_sub ( $self ) { 
    system 'ffmpeg', 
           '-y', '-loglevel', 'fatal', 
           '-i', $self->input, 
           '-map', $self->sub_id, $self->ass; 
} 

sub clean_sub ( $self ) { 
    if ( $self->has_subtitle ) { 
        unlink $self->ass; 
    }
} 

1;  
