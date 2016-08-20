package FFmpeg::Subtitle; 

# core 
use File::Basename; 

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
    is        => 'ro', 
    isa       => 'Str', 
    lazy      => 1, 
    init_arg  => undef, 
    predicate => 'has_sub_id', 

    default   => sub ( $self ) { 
        return ( 
            $self->has_subtitle ? 
            $self->select_stream('Subtitle', $self->subtitle) : 
            'none'
        ) 
    },  
);   

has 'ass', ( 
    is       => 'ro', 
    isa      => 'Str', 
    lazy     => 1, 
    init_arg => undef, 

    default  => sub ( $self ) { 
        return my $ass = basename($self->input) =~ s/(.*)\..+?$/$1.ass/r; 
    },  
); 

sub extract_sub ( $self ) { 
    system 'ffmpeg', '-y', '-loglevel', 'fatal',  
                     '-i', $self->input, '-map', $self->sub_id, $self->ass; 
} 

1;  
