#!/usr/bin/perl

use Elevator;
use Interface;

$e = Elevator->new();
print "Finish floor: ".$e->get_finish_floor()."\n";
print "Calling from 6th floor\n";
die "Can't call an elevator\n" if (!$e->call_from(6));
print "Finish floor: ".$e->get_finish_floor()."\n";