#!/usr/bin/perl
open(INPUT, "< input.csv")
       or die "Couldn't open file for reading: $!\n";
open(OUTPUT, "> use_cases_mediawiki_table.txt")
       or die "Couldn't open file for writing: $!\n";   

while (<INPUT>) {
       @fields = split(",");
       printf OUTPUT ("\|$fields[0]\n\|$fields[1]\n\|$fields[2]\n\|$fields[3]\|-\n");
}
close INPUT;
close OUTPUT;
