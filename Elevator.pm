package Elevator;

use warnings;
use strict;

use constant TOP_FLOOR => 9;

sub new
{
   my $class = shift;
   my $self = {};
   bless($self, $class);
   $self->{current_floor} = 1;
   $self->{finish_floor} = 0;
   return $self;
}

sub get_current_floor
{
    my $self = shift;
    return $self->{current_floor};
}

sub get_finish_floor
{
    my $self = shift;
    return $self->{finish_floor};
}

sub call_from
{
    my ($self, $f) = @_;
    $self->{finish_floor} = $f if ($f <= TOP_FLOOR);
    if ($self->{finish_floor} == $f)
        { return 1; }
    else
        { return 0; }
}

1;