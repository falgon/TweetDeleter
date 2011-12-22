#!/usr/bin/perl
use utf8;
use strict;
use warnings;
use Try::Tiny;
use Encode::DoubleEncodedUTF8;
use Encode::Guess;
use Net::Twitter::Lite;
use Data::Dumper;

sub main{
        my $file="keys.csv";
        open(IN,$file)or die"$!";
        my @filekeydata;
        while(<IN>){
                chomp($_);
                @filekeydata=split(/,/,$_);
        }
        
        my %Consumer_Token=(
                consumer_key=>$filekeydata[0],
                consumer_secret=>$filekeydata[1],
        );
        my $Access_Token=$filekeydata[2];
        my $Access_Token_Secret=$filekeydata[3];
        my $tweet=Net::Twitter::Lite->new(%Consumer_Token);
        my $argv=defined ($_[0])? $_[0]:0;


        $tweet->access_token($Access_Token);
        $tweet->access_token_secret($Access_Token_Secret);
        #&Send_Post($tweet);
        while(1){
                sleep(1);
                &DeleteTweet($tweet,$argv,$filekeydata[4]);
        }
}

=pod
sub Send_Post{
        my $tweet=shift;

        my $statues=$tweet->update({status=>'test tweet'});
        print Dumper $statues;
}
=cut
sub DeleteTweet{
        my $tweet=$_[0];
        my $argv=$_[1];
        my $user_name=$_[2];

        my $stat=$tweet->user_timeline({screen_name=>$user_name,count=>100,page=>1});
        for my $st(@$stat){
                my $dspstr="Date: $st->{created_at}<$st->{user}{screen_name}>\nDeleting Tweet: $st->{text}\n";
                $dspstr=Encode::encode('utf-8',$dspstr)if utf8::is_utf8($dspstr);
                print &toSHIFTJIS($dspstr);
                if($argv eq '-d'){
                        $tweet->destroy_status($st->{id});
                }else{
                        while(1){
                                print 'OK? (y/n)>> ';
                                chomp(my $input=<STDIN>);
                                if($input eq 'y'){
                                        $tweet->destroy_status($st->{id});
                                        print 'Deleted';
                                        exit;
                                }elsif($input eq 'n'){
                                        print 'Didn\'t delete';
                                        exit;
                                }
                        }
                }
        }
}

sub toSHIFTJIS{ 
    my $sTxt=shift; 
    my $dec=Encode::Guess->guess($sTxt); 
    if (ref $dec) { 
        $sTxt=Encode::encode('cp932', Encode::decode($dec->name, $sTxt)); 
    }elsif(($dec=~ /shiftjis/) or ($dec=~ /utf/)){ 
        $sTxt=Encode::encode('cp932', Encode::decode_utf8($sTxt)); 
    }

    $sTxt; 
}

&main($ARGV[0]);
