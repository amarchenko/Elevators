#!/usr/bin/perl

use Elevator;
use Interface;

$i = Interface->new(9, 1);
#print $i, "\n";
print $i->get_top_floor(), "\n";
print $i->get_elevators_num(), "\n";
$i->draw_base();

=comment
$e = Elevator->new();

print "Where are you? -> ";
$my_f = <STDIN>;
chomp($my_f);

$e->call_from_floor($my_f);

print "Where are we going? -> ";
$my_f = <STDIN>;
chomp($my_f);

$e->set_destination_floor($my_f);

print "Finished!\n";
=cut
