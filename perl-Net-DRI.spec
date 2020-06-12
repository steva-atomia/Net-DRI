# $Id$
# Authority: dries
# Upstream: Patrick Mevzek <netdri$dotandco,com>

%define perl_vendorlib %(eval "`%{__perl} -V:installvendorlib`"; echo $installvendorlib)
%define perl_vendorarch %(eval "`%{__perl} -V:installvendorarch`"; echo $installvendorarch)

%define sourcedir perl-Net-DRI

Summary: Interface to Domain Name Registries/Registrars/Resellers
Name: perl-Net-DRI
Version: 0.96
Release: 68atomia
License: Artistic/GPL
Group: Applications/CPAN
URL: http://search.cpan.org/dist/Net-DRI/

Source: perl-Net-DRI.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

BuildArch: noarch
BuildRequires: perl
# From yaml requires
BuildRequires: perl(Carp)
BuildRequires: perl(Class::Accessor)
BuildRequires: perl(Class::Accessor::Chained)
BuildRequires: perl(DateTime)
BuildRequires: perl(DateTime::Duration)
BuildRequires: perl(DateTime::Format::ISO8601) >= 0.06
BuildRequires: perl(DateTime::Format::Strptime)
BuildRequires: perl(DateTime::TimeZone)
BuildRequires: perl(Email::Valid)
BuildRequires: perl(IO::Socket::INET)
BuildRequires: perl(IO::Socket::SSL) >= 0.90
BuildRequires: perl(Test::More)
BuildRequires: perl(Time::HiRes)
BuildRequires: perl(UNIVERSAL::require)
BuildRequires: perl(XML::LibXML)


%description
Net::DRI is a Perl library which offers a uniform API to access services
from domain name registries, registrars, and resellers. It is an
object-oriented framework that can be easily extended to handle various
protocols (such as RRP, EPP, or custom protocols) and various transports
methods (such as TCP, TLS, SOAP, or email).

%prep
%setup -n %{sourcedir}

%build
%{__perl} Makefile.PL INSTALLDIRS="vendor" PREFIX="%{buildroot}%{_prefix}"
%{__make} %{?_smp_mflags}

%install
%{__rm} -rf %{buildroot}
%{__make} pure_install

### Clean up buildroot
find %{buildroot} -name .packlist -exec %{__rm} {} \;

### Clean up docs
find eg/ -type f -exec %{__chmod} a-x {} \;

%clean
%{__rm} -rf %{buildroot}

%files
%defattr(-, root, root, 0755)
%doc Changes INSTALL LICENSE MANIFEST META.yml README TODO eg/
%doc %{_mandir}/man3/Net::DRI.3pm*
%doc %{_mandir}/man3/Net::DRI::*.3pm*
%dir %{perl_vendorlib}/Net/
%{perl_vendorlib}/Net/DRI/
%{perl_vendorlib}/Net/DRI.pm

%changelog
* Fri Jun 12 2020 Stevan Kostic <stevan.kostic@atomia.com> - 0.96-68atomia
- Update domain-ext to 2.4 for EUrid.

* Thu Apr 23 2020 Sasa Mladenovic <sasa.mladenovic@atomia.com> - 0.96-67atomia
- Updated to version 0.96-67atomia.

* Mon Oct 28 2019 Sasa Mladenovic <sasa.mladenovic@atomia.com> - 0.96-66atomia
- Updated to version 0.96-66atomia.

* Thu Jun 12 2019 Stefan Stankovic <stefan.stankovic@atomia.com> - 0.96-65atomia
- Updated to version 0.96-65atomia.

* Thu Feb 21 2019 Stefan Stankovic <stefan.stankovic@atomia.com> - 0.96-64atomia
- Fixed EURid EPP connection issues

* Wed Aug 08 2018 Igor Jocic <igor@atomia.com> - 0.96-63atomia
- Updated to version 0.96-63atomia.

* Fri Jun 01 2018 Igor Jocic <igor@atomia.com> - 0.96-62atomia
- Updated to version 0.96-62atomia.

* Fri Apr 20 2018 Igor Jocic <igor@atomia.com> - 0.96-61atomia
- Updated to version 0.96-61atomia.

* Tue Mar 06 2018 Igor Jocic <igor@atomia.com> - 0.96-60atomia
- Updated to version 0.96-60atomia.

* Wed Dec 06 2017 Igor Jocic <igor@atomia.com> - 0.96-59atomia
- Updated to version 0.96-59atomia.

* Tue Nov 14 2017 Igor Jocic <igor@atomia.com> - 0.96-58atomia
- Updated to version 0.96-58atomia.

* Tue Oct 24 2017 Igor Jocic <igor@atomia.com> - 0.96-57atomia
- Updated to version 0.96-57atomia.

* Tue Oct 10 2017 Igor Jocic <igor@atomia.com> - 0.96-56atomia
- Updated to version 0.96-56atomia. 

* Tue Aug 08 2017 Igor Jocic <igor@atomia.com> - 0.96-55atomia
- Updated to version 0.96-55atomia.

* Wed Jul 05 2017 Igor Jocic <igor@atomia.com> - 0.96-54atomia
- Updated to version 0.96-54atomia.

* Wed May 24 2017 Igor Jocic <igor@atomia.com> - 0.96-53atomia
- Updated to version 0.96-53atomia.

* Thu Apr 27 2017 Jimmy Bergman <jimmy@atomia.com> - 0.96-52atomia
- Updated to version 0.96-52atomia.

* Mon Feb 06 2017 Jimmy Bergman <jimmy@atomia.com> - 0.96-51atomia
- Updated to version 0.96-51atomia.

* Tue Jan 24 2017 Jimmy Bergman <jimmy@atomia.com> - 0.96-50atomia
- Updated to version 0.96-50atomia.

* Fri Dec 02 2016 Jimmy Bergman <jimmy@atomia.com> - 0.96-49atomia
- Updated to version 0.96-49atomia.

* Thu Sep 01 2016 Jimmy Bergman <jimmy@atomia.com> - 0.96-47atomia
- Updated to version 0.96-47atomia.

* Mon May 23 2016 Jimmy Bergman <jimmy@atomia.com> - 0.96-46atomia
- Updated to version 0.96-46atomia.

* Mon Dec 11 2015 Jimmy Bergman <jimmy@atomia.com> - 0.96-45atomia
- Updated to version 0.96-45atomia.

* Mon Oct 12 2015 Jimmy Bergman <jimmy@atomia.com> - 0.96-44atomia
- Updated to version 0.96-44atomia.

* Fri Sep 11 2015 Jimmy Bergman <jimmy@atomia.com> - 0.96-43atomia
- Updated to version 0.96-43atomia.

* Tue Aug 13 2015 Jimmy Bergman <jimmy@atomia.com> - 0.96-42atomia
- Updated to version 0.96-42atomia.

* Tue Aug 09 2015 Jimmy Bergman <jimmy@atomia.com> - 0.96-41atomia
- Updated to version 0.96-41atomia.

* Mon Jun 09 2015 Jimmy Bergman <jimmy@atomia.com> - 0.96-40atomia
- Updated to version 0.96-40atomia.

* Thu Apr 09 2015 Jimmy Bergman <jimmy@atomia.com> - 0.96-39atomia
- Updated to version 0.96-39atomia.

* Mon Mar 23 2015 Jimmy Bergman <jimmy@atomia.com> - 0.96-38atomia
- Updated to version 0.96-38atomia.

* Tue Oct 18 2012 Jimmy Bergman <jimmy@atomia.com> - 0.96-22atomia
- Updated to version 0.96-22atomia.

* Tue Sep  8 2009 Christoph Maser <cmr@financial.com> - 0.95-1
- Updated to version 0.95.

* Sat Jul  4 2009 Christoph Maser <cmr@financial.com> - 0.92-1
- Updated to version 0.92.

* Wed Feb 20 2008 Dag Wieers <dag@wieers.com> - 0.85-1
- Updated to release 0.85.

* Thu Nov 15 2007 Dag Wieers <dag@wieers.com> - 0.81-1
- Updated to release 0.81.

* Fri Apr 20 2007 Dries Verachtert <dries@ulyssis.org> - 0.80-1
- Updated to release 0.80.

* Tue Sep 26 2006 Dries Verachtert <dries@ulyssis.org> - 0.40-1
- Updated to release 0.40.

* Mon Sep 18 2006 Dries Verachtert <dries@ulyssis.org> - 0.30-1
- Updated to release 0.30.

* Sat May 20 2006 Dries Verachtert <dries@ulyssis.org> - 0.22-1
- Updated to release 0.22.

* Tue Mar 14 2006 Dries Verachtert <dries@ulyssis.org> - 0.21-1
- Updated to release 0.21.

* Tue Nov 15 2005 Dries Verachtert <dries@ulyssis.org> - 0.19-1
- Updated to release 0.19.

* Tue Nov 08 2005 Dries Verachtert <dries@ulyssis.org> - 0.18-1
- Initial package.
