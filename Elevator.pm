#!/usr/bin/perl

package Elevator;

use warnings;
use strict;

use constant TOP_FLOOR => 9;
use constant FREE => 1;
use constant BUSY => 0;
use constant UP => 1;
use constant DOWN => 0;

sub new
{
   my $class = shift;
   my $self = {};
   bless($self, $class);
   $self->{state} = FREE;
   $self->{direct} = undef;
   $self->{current_floor} = 1;
   $self->{destination_floor} = 0;
}

sub get_current_floor
{
    my $self = shift;
    return $self->{cur_floor};
}

sub call_from_floor
{
    my ($self, $f) = @_;
    if ($self->{state} == FREE && _is_valid_floor($f))
    {
        $self->_move_to_floor($f);
    }
}

sub set_destination_floor
{
    my ($self, $f) = @_;
    if (_is_valid_floor($f))
        { $self->{destination_floor} = $f; }
}

sub _is_valid_floor
{
    my ($self, $f) = @_;
    ($f < TOP_FLOOR) && ($f >= 1) ? return 1 : return 0;
}

1;