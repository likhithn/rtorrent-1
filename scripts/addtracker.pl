#!/usr/bin/perl
use Convert::Bencode_XS qw(bencode bdecode);
use warnings;
use strict;
$/ = undef;
my @list = ($ARGV[0], $ARGV[0].'.libtorrent_resume');
my $tracker = $ARGV[1];
for (@list) {
open my $fh, '<', $_;
my $torrent = bdecode(scalar <$fh>);
if ($torrent->{'trackers'}) {
$torrent->{'trackers'}->{$tracker} = {enabled => 1};
}
if ($torrent->{'announce-list'}) {
push @{$torrent->{'announce-list'}}, [$tracker];
} elsif ($torrent->{'announce'}) {
push @{$torrent->{'announce-list'}}, [$torrent->{'announce'}];
push @{$torrent->{'announce-list'}}, [$tracker];
}
close $fh;
open my $fhw, '>', $_;
print $fhw bencode($torrent);

close $fhw;
}
