#!/usr/bin/perl -w

##############################################################################
###
### input:
###       checkArchives.pl MinimumNumberOfFiles /path/to/directory
### 1. Finding oldest file in directory
### 2. Finding newest file in directory
###    - if they are same, then ALARM!
###    - if nothing, then ALARM!
### 3. Remove all oldest files and keep MinimumNumberOfFiles
###
### ilya@arviol.ru, 2017
###
##############################################################################

use strict;
use warnings;

my $debug = 0;


my ( $totalFiles , $numFiles , $pathArch , $isArchiveExist , $isArchiveLatest , $isArchiveOldest , $isOnlyOneArchive );
my ( $oldestFile , $oldestAge , $curFile , $result , $temp );


my ( $k , $i ) = 0;
my ( @pathArch , @filesArray ) = [];

print "Debug is online\n" if( $debug == 1 );

$numFiles = $ARGV[0];
$pathArch = $ARGV[1];

usage() if(( $numFiles == 1 ) || ( $numFiles == 0 ) );
usage() if(( $numFiles eq "-h" ) || ( $numFiles eq "--help" ) || ( $numFiles eq "/?" ) || ( $numFiles eq "h" ));

chdir( $pathArch ) or die "Cant change dir to $!\n";

if( $debug == 1 ){
        print " MinNumOfFiles: $numFiles\n Path: $pathArch\n";
}

opendir DIR , $pathArch or die "Cant open $pathArch!\n";
@pathArch = readdir( DIR );
close DIR;

$i = 0;

foreach( @pathArch ){
        if( -f $pathArch . "/" . $_ ){
        print "$_\n" if( $debug == 1 );
                $i++;
                if ( -z $_ ){
                        print "File $_ is empty! Delaying... May be we got transferring here?\n" if( $debug == 1 );
                        sleep( 10 );
                        if( -z $_ ){
                                print "File $_ seems to be empty. Deleting\n" if( $debug == 1 );
                                if ( -e $_ ) {
                                unlink( $_ ) or die "Error: $_ $!\n";
                            }
                        }
                }
        }
}

$totalFiles = $i;

die "Everything good!\n" if $totalFiles <= $numFiles;

print "Total files in $pathArch:\t$totalFiles\n" if $debug == 1;
die "There is $totalFiles in $pathArch and you want to keep $numFiles in this dir. $totalFiles == $numFiles \nExiting\n" if $totalFiles == $numFiles;
$result = findOldest();
print "Oldest file is $result\n" if $debug == 1;
$temp = $totalFiles - $numFiles;
$i = 0;
$k = 0;

if( $totalFiles > $numFiles ){
        print "Total files ( $totalFiles ) more than you want to keep ( $numFiles ). Cleaning $temp files\n" if( $debug == 1 );
        for( $k = 1 ; $k <= $temp ; $k++ ){
                $curFile = findOldest();
#                next if( -d $curFile );
                print "Trying to delete file $curFile\n" if $debug == 1;
                unlink( $curFile );
                print "Deleted $curFile\n" if $debug == 1;
        }
}

sub usage{
        print "Usage:\n";
        die "checkArchives.pl MinimumNumberOfFiles /path/to/directory\n";
        return 0;
}

sub countFiles{
        my $i = 0;
        foreach( @pathArch ){
                $i++ if( -f $pathArch . "/" . $_ )
        }
        return $i;
}

sub findOldest{
my $oAge; my $oFile; my $cFile;
        foreach $cFile ( <$pathArch/*> ){
            next if -d $cFile;
            if( !defined( $oFile ) or ( -M $cFile > $oAge ) ){
                $oFile = $cFile;
                $oAge = -M $cFile;
            }
        }
        print "Old file: $oFile\n" if $debug == 1;
        return $oFile;
}
