#!/usr/bin/perl

package Elevator;

use warnings;
use strict;

use constant TOP_FLOOR => 9;
use constant ST_FREE => 2;
use constant ST_QUEUED => 1;
use constant ST_BUSY => 0;
use constant UP => 1;
use constant DOWN => 0;

sub new
{
   my $class = shift;
   my $self = {};
   bless($self, $class);
   $self->{state} = ST_FREE;
   $self->{direct} = undef;
   $self->{current_floor} = 1;
   $self->{destination_floor} = 0;
   return $self;
}

sub get_current_floor
{
    my $self = shift;
    return $self->{cur_floor};
}

sub call_from_floor
{
    my ($self, $f) = @_;
    if ($self->{state} == ST_FREE && $self->_is_valid_floor($f))
    {
        $self->{destination_floor} = $f;
        $self->{state} = ST_QUEUED;
        $self->_move_to_destination(); # is it propper place fro move?
    }
}

sub set_destination_floor
{
    my ($self, $f) = @_;
    if ($self->{state} == ST_QUEUED && $self->_is_valid_floor($f))
    { 
        $self->{destination_floor} = $f;
        $self->{state} = ST_BUSY;
        $self->_move_to_destination(); # is it propper place fro move?
    }
}

sub _is_valid_floor
{
    my ($self, $f) = @_;
    ($f < TOP_FLOOR) && ($f >= 1) ? return 1 : return 0;
}

sub _move_to_destination
{
    my $self = shift;
    print "Moving: $self->{current_floor} -> $self->{destination_floor}\n";
    while ($self->{current_floor} < $self->{destination_floor})
    {
        $self->{current_floor}++;
        print "Now at: $self->{current_floor}\n";
        sleep 1;
    }
    while ($self->{destination_floor} < $self->{current_floor})
    {
        $self->{current_floor}--;
        print "Now at: $self->{current_floor}\n";
        sleep 1;
    }
    if ($self->{destination_floor} == $self->{current_floor} && $self->{state} == ST_BUSY)
        { $self->{state} == ST_FREE; }
}

1;