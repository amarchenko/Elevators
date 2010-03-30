#!/usr/bin/perl

use Elevator;

$e = Elevator->new();

print "Where are you? -> ";
$my_f = <STDIN>;
chomp($my_f);

$e->call_from_floor($my_f);

print "Where are we going? -> ";
$my_f = <STDIN>;
chomp($my_f);

$e->set_destination_floor($my_f);