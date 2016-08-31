package Net::DRI::Protocol::EPP::Extensions::FI::Domain;

use strict;
use warnings;

use Net::DRI::Exception;
use Net::DRI::Util;
use Net::DRI::Protocol::EPP::Util;

=pod

=head1 NAME

Net::DRI::Protocol::EPP::Extensions::FI::Domain - FI EPP Domain extension commands for Net::DRI

=cut


####################################################################################################


sub register_commands
{
	my ($class,$version)=@_;
	
	my %tmp=(
				delete => [ \&delete ],
				transfer_request => [ \&transfer_request, undef ]
         );
	
	return { 'domain' => \%tmp };
}

####################################################################################################

sub transfer_request
{
 my ($epp,$domain,$rd)=@_;
 my $mes=$epp->message();
 my @d=Net::DRI::Protocol::EPP::Util::domain_build_command($mes,['transfer',{'op'=>'request'}],$domain);
 push @d,Net::DRI::Protocol::EPP::Util::build_period($rd->{duration}) if Net::DRI::Util::has_duration($rd);
 push @d,Net::DRI::Protocol::EPP::Util::domain_build_authinfo($epp,$rd->{auth}) if Net::DRI::Util::has_auth($rd);
 ## Nameservers, OPTIONAL
 push @d,Net::DRI::Protocol::EPP::Util::build_ns($epp,$rd->{ns},$domain) if Net::DRI::Util::has_ns($rd);
 $mes->command_body(\@d);
}

sub delete
{
 my ($epp,$domain,$rd)=@_;
 my $mes=$epp->message();
 
 my @dom=(ref($domain))? @$domain : ($domain);
 Net::DRI::Exception->die(1,'protocol/EPP',2,'Domain name needed') unless @dom;
 foreach my $d (@dom)
 {
  Net::DRI::Exception->die(1,'protocol/EPP',2,'Domain name needed') unless defined($d) && $d;
  Net::DRI::Exception->die(1,'protocol/EPP',10,'Invalid domain name: '.$d) unless Net::DRI::Util::is_hostname($d);
 }

 $mes->command(['delete','obj:delete','xmlns:obj="urn:ietf:params:xml:ns:obj"']);

 my @d=map { ['domain:name',$_] } @dom;
 
 
 my @dd;
 push(@dd, ['domain:delete', @d, {'xmlns:domain'=>sprintf('%s', $mes->nsattrs('domain')), 'xsi:schemaLocation'=>sprintf('%s %s', $mes->nsattrs('domain'))}]);
 $mes->command_body(\@dd);
}

1;
