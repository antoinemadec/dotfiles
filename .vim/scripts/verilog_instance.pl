#! /usr/bin/env perl

# this script is a basic script for doing verilog editing
# it parses the variables from stdin and generate a verilog name instantiation
# of the variables


use strict;
use warnings;

my $all_inputs;

while (<STDIN>)
{
  s/\/\/.*//;
  chop;
  $all_inputs .= "$_ ";
}

# remove /* */ comments
$all_inputs =~ s/\/\*.*?\*\///g;

# add , at the end for matching last parameter in v2k1 syntax
$all_inputs .= ",";

# remove input output ...

my $id;
foreach $id ("input", "output", "inout", "reg", "wire", "parameter", "unsigned", "integer", "localparam")
{
  $all_inputs =~ s/\b$id\b\s*/ /g;
}

# remove all []
$all_inputs =~ s/\[.*?]/ /g;

# remove  = <VALUE>; for Verilog95
$all_inputs =~ s/=.*?;/ /g;

# remove  = <VALUE>; for Verilog2k1
$all_inputs =~ s/=.*?,/ /g;

# remove , or ;
$all_inputs =~ s/[,;]/ /g;

# one space
$all_inputs =~ s/\s+/ /g;

my @list_of_port = split(/ /, $all_inputs);

my $l;
my $max_length = 0;
foreach $l (@list_of_port)
{
  $max_length = length "$l" if (length "$l" > $max_length);
}

$max_length+=2;


foreach $l (@list_of_port)
{
  next if ($l eq "");
  my $space = " " x ($max_length - length($l));
  print "  .$l" . $space . "($l" . $space . "),\n";
}

