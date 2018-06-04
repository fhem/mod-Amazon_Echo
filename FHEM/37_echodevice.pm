# $Id: 37_echodevice.pm 15724 2017-12-29 22:59:44Z michael.winkler $
##############################################
#
# 2018.05.30 v0.0.37
# - BUGFIX:  ReLogin bei "COOKIE ERROR"
# - FEATURE: Neues Attribut "browser_language"
#
# 2018.05.17 v0.0.36
# - CHANGE:  Accept-Language: de,en-US
#
# 2018.05.17 v0.0.35
# - BUGFIX:  Attribut "cookie"
#
# 2018.05.07 v0.0.34
# - BUGFIX:  Attribut "intervalsettings"
#            ReLogin bei "COOKIE ERROR"
#
# 2018.04.09 v0.0.33
# - CHANGE:  get "help" zusätzliche Anleitung MP3 Streamserver & IceCast2
#            TTS_Nachrichten werden mindestens mit der Laustärke von Reading "volume_alarm" abgespielt.
#            Zwei Faktor Authentifizierung (set login2FACode) Danke Benutzer JoWiedmann https://forum.fhem.de/index.php/topic,82631.msg787815.html#msg787815
#            Verstecken von Helper "CUSTOMER","COMMSID","COOKIE","DIRECTID","PASSWORD","USER","HTTP_CONNECTION" und "SERIAL"
#            Verstecken von Readings "COOKIE","AWS_Access_Key" und "aws_secret_key"
# - FEATURE: Neues Reading "currentTuneInID"
#            set "tts_translate" Übersetzung von der Webseite http://www.online-translator.com/ Reading="tts_translate_result"
#            Neues Attribut "TTS_Translate_From"
#            TTS Translate unterstützt folgende Sprachen:dutch,english,french,german,italian,japanese,korean,portuguese,russian,spanish und turkish
#            TTS MP3 Länge ermitteln. Reading = "tts_lenght"
#            TTS Nachrichte abspielen wenn schon ein TuneIn Sender läuft.
# - BUGFIX:  Log Eintrag bei TTS & Attribut: "TTS_normalize" entfernt
#            Name Attribut "TTS_Voice" WelshEnglish_Female_Gwyneth
#            get settings
#            Verzeichnis "echodevice" wurde nicht automatisch angelegt
#
# 2018.03.20 v0.0.32
# - FEATURE: Neues Attribut: "TTS_normalize" (only mp3 Outputformat!)
# - BUGFIX:  remove sleep 0.5
#
# 2018-03-19 v0.0.31
# - BUGFIX:  Amazone TTS Nachrichten < 3 Zeichen
#            File "cache/pollyspeech.py", line 4, in <module>
#            get "devices" https://forum.fhem.de/index.php/topic,82631.msg783487.html#msg783487
#
# 2018-03-18 v0.0.30
# - FEATURE: Text2Speech (TTS) inkl. Google und Amazon Stimmen
#            Musik aus dem eigenen LAN abspielen
#            Neue Attribute:   ALLE     "TTS_Voice" und "TTS_IgnorPlay"
#            Neue Set Befehle: ACCOUNT  "AWS_Access_Key","AWS_OutputFormat","AWS_Secret_Key","POM_Filename","POM_IPAddress","POM_TuneIn","TTS_Filename","TTS_IPAddress" und "TTS_TuneIn"
#            Neue Set Befehle: Nur ECHO "tts", "playownmusic", "playownplaylist", "deleteownplaylist", und "saveownplaylist"
# - CHANGE:  get "help"
#            Reihenfolge get settings https://forum.fhem.de/index.php/topic,82631.msg781731.html#msg781731
#
# v0.0.29
# - FEATURE: Zwei Faktor Authentifizierung (set login2FACode) Danke Benutzer JoWiedmann https://forum.fhem.de/index.php/topic,82631.msg780848.html#msg780848
#
# v0.0.28
# - CHANGE:  get "Conversations" auf nonBlocking
#            get "tunein" auf nonBlocking & move to Echo Device & play link
#            get "tracks" auf nonBlocking
#            get "devices" auf nonBlocking
#            set "autocreat_devices" auf nonBlocking
#            httpversion = "1.1"
# - FEATURE: get "actions"
#            get "primeplayeigene_albums"
#            get "primeplayeigene_tracks"
#            get "primeplayeigene_artists"
#            get "primeplayeigeneplaylist"
#            get "help"
#            Multiroom add get settings & tunein
# - BUGFIX:  primeplayeigene 
#
# v0.0.27
# - BUGFIX:  Not an ARRAY reference at ./FHEM/37_echodevice.pm line 1610
#
# v0.0.26
# - BUGFIX:  read readings if amazon device is connected
#
# v0.0.25
# - BUGFIX:  set reminder_normal
#            Attribut disable
#            no Internet connect
# - FEATURE: Attribut browser_useragent_random (Standard=1)
#            Attribut intervallogin (Standard=60)
#
# v0.0.24
# - BUGFIX:  Timer Readings
#
# v0.0.23
# - BUGFIX:  Nested quantifiers in regex
# - CHANGE:  Reading version
#
# v0.0.22
# - FEATURE: Attribut browser_useragent https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Attribute
#
# v0.0.21
# - CHANGE:  Header
#
# v0.0.20
# - CHANGE:  Cookie erstellen auf nonBlocking
#            Cookie erstellen Timeout 10 sekunden
# - BUGFIX:  div.
#
# v0.0.19
# - BUGFIX:  Fehlt bei "get" der Punkt "conversations"
#            Fehlt bei "set" der Punkt "textmessage"
#
# v0.0.18
# - FEATURE: autocreate Standard Raum "Amazon"
# - CHANGE:  COOKIE wird nicht mehr erneuert!
#
# v0.0.17
# - FEATURE: refresh ECHO devices (Attribut autocreate_refresh)
#            define icon to echo
# - CHANGE:  Header
#
# v0.0.16
# - FEATURE: autocreate ECHO Spot
#
# v0.0.15
# - CHANGE:  deletereading auf FHEM Command umgestellt
# - BUGFIX:  MausicAlarm
#
# v0.0.14
# - FEATURE: autocreate ECHO Multiroom
#            autocreate Sonos One
#            autocreate Reverb
# - CHANGE:  model im Klartext z.B. Echo Dot
#
# v0.0.13
# - BUGFIX:  Cookie
#
# v0.0.12
# - FEATURE: Support Musicalarm
#
# v0.0.11.2
# - FEATURE: neue Readings timer_XX, reminder_X und alarm_xx
#            neue Readings deviceAddress, timeZoneId
#            Zeigt den Status für Mikrofon Reading = microphone
#            Zeigt den Status ob der ECHO online ist. Reading = online
# - BUGFIX:  Reading voice leer
#            Div. Logeinträge wenn Variablen leer sind
# - CHANGE : Reading active entfernt
#
# v0.0.10
# - BUGFIX:  Einkaufsliste und ToDo Liste (Fehler beim hinzufügen und entfernen von Einträgen)
#
# v0.0.9
# - BUGFIX:  ECHO Devices Readings wurden nicht aktualisiert
#
# v0.0.8
# - FEATURE: Attribut tuneid_default (Hier kann ein Standard TuneIn Sender angegeben werden)
#            set notifications_delete (löschen von Erinnerungen, Timer und Wecker)
#            autocreate ECHO Show Geräte
#            löschen und hinzufügen von Einkauflisten- und Task Einträgen
#
# v0.0.7
# - FEATURE: Interval Anpassung beim abspielen eines Songs
# - CHANGE:  set reminder_normal ohne Datumsangabe (Reminder sofort ausgeführt))
#
# v0.0.6
# - CHANGE : Log Einträge reduziert
#            Reading "voice" zum Echo Device verschoben
# - BUGFIX:  set reminder_normal Text (Reminder sofort ausgeführt))
#            ACCOUNT DEVICE macht jetzt die abfragen für wakeword, volume_alarm, dnd, active, bluetooth
#            Standard Interval 60 Sekunden
#
# v0.0.5
# - CHANGE : set reminder_normal (durch weglassen der Uhrzeit wird der Reminder sofort ausgeführt)
# - FEATURE: Attribut reminder_delay (wird für reminder_normal benötigt. Standardwert = 10 sekunden)
#
# v0.0.4
# - CHANGE:  set reminder vom ACCOUNT DEVICE entfernt
#            set reminder zum Echo DEVICE hinzugefügt
# - FEATURE: set reminder_normal
#            set reminder_repeat
#
# v0.0.3
# - BUGFIX:  Anzeige set befehle primeplayeigene,primeplayeigeneplaylist,primeplaylist und primeplaysender
#
# v0.0.2
# - FEATURE: set primeplayeigene
#            set primeplayeigeneplaylist
#            set primeplaylist
#            set primeplaysender
#
# v.0.0.1
# - BUGFIX:  blocking restart fhem
#            readings
#
#  Copyright by Michael Winkler
#  e-mail: michael.winkler at online.de
#
#  This file is part of fhem.
#
#  Fhem is free software: you can redistribute it andor modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  Fhem is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with fhem.  If not, see <http://www.gnu.org/licenses/>.
#
#  https://forum.fhem.de/index.php/topic,82631.0.html
#
##############################################################################

package main;

use strict;
use Time::Local;
use Encode;
use Encode qw/from_to/;
use URI::Escape;
use Data::Dumper;
use JSON;
use utf8;
use Date::Parse;
use Time::Piece;
use lib ('./FHEM/lib', './lib');
use MP3::Info;

my $ModulVersion     = "0.0.37";
my $AWSPythonVersion = "0.0.3";

##############################################################################
sub echodevice_Initialize($) {
	my ($hash) = @_;
	my $name = $hash->{NAME};

	$hash->{DefFn}        = "echodevice_Define";
	$hash->{UndefFn}      = "echodevice_Undefine";
	$hash->{NOTIFYDEV}    = "global";
	$hash->{NotifyFn}     = "echodevice_Notify";
	$hash->{GetFn}        = "echodevice_Get";
	$hash->{SetFn}        = "echodevice_Set";
	$hash->{AttrFn}       = "echodevice_Attr";
	$hash->{AttrList}     = "disable:0,1 ".
							"IODev ".
							"TTS_Voice:AustralianEnglish_Female_Nicole,AustralianEnglish_Male_Russell,BrazilianPortuguese_Female_Vitoria,BrazilianPortuguese_Male_Ricardo,BritishEnglish_Female_Amy,BritishEnglish_Female_Emma,BritishEnglish_Male_Brian,CanadianFrench_Female_Chantal,CastilianSpanish_Female_Conchita,CastilianSpanish_Male_Enrique,Danish_Female_Naja,Danish_Male_Mads,Dutch_Female_Lotte,Dutch_Male_Ruben,French_Female_Celine,French_Male_Mathieu,German_Female_Google,German_Female_Marlene,German_Female_Vicki,German_Male_Hans,Icelandic_Female_Dora,Icelandic_Male_Karl,IndianEnglish_Female_Aditi,IndianEnglish_Female_Raveena,Italian_Female_Carla,Italian_Male_Giorgio,Japanese_Female_Mizuki,Japanese_Male_Takumi,Korean_Female_Seoyeon,Norwegian_Female_Liv,Polish_Female_Ewa,Polish_Female_Maja,Polish_Male_Jacek,Polish_Male_Jan,Portuguese_Female_Ines,Portuguese_Male_Cristiano,Romanian_Female_Carmen,Russian_Female_Tatyana,Russian_Male_Maxim,Swedish_Female_Astrid,Turkish_Female_Filiz,USEnglish_Female_Ivy,USEnglish_Female_Joanna,USEnglish_Female_Kendra,USEnglish_Female_Kimberly,USEnglish_Female_Salli,USEnglish_Male_Joey,USEnglish_Male_Justin,USEnglish_Male_Matthew,USSpanish_Female_Penelope,USSpanish_Male_Miguel,WelshEnglish_Female_Gwyneth,WelshEnglish_Male_Geraint ".
							"TTS_IgnorPlay:0,1 ".
							"TTS_normalize:slider,5,1,40 ".
							"TTS_Translate_From:dutch,english,french,german,italian,japanese,korean,portuguese,russian,spanish,turkish ".
							"intervalsettings ".
							"intervallogin ".
							"server ".
							"cookie ".
							"reminder_delay ".
							"tunein_default ".
							"autocreate_refresh:0,1 ".
							"browser_useragent ".
							"browser_language ".
							"browser_useragent_random:0,1 ".
							$readingFnAttributes;
}

sub echodevice_Define($$$) {
	my ($hash, $def) = @_;
	my @a = split("[ \t][ \t]*", $def);
	my ($found, $dummy);

	return "syntax: define <name> echodevice <account> <password>" if(int(@a) != 4 );
	my $name = $hash->{NAME};

	$attr{$name}{server} = "layla.amazon.de" if( defined($attr{$name}) && !defined($attr{$name}{server}) );

	RemoveInternalTimer($hash);

	if($a[2] =~ /crypt/ || $a[2] =~ /@/ || $a[2] =~ /^\+/) {
    
		$hash->{model} = "ACCOUNT";
		
		my $user = $a[2];
		my $pass = $a[3];
		
		my $username = echodevice_encrypt($user);
		my $password = echodevice_encrypt($pass);
		$hash->{DEF} = "$username $password";

		$hash->{helper}{".USER"}     = $username;
		$hash->{helper}{".PASSWORD"} = $password;
		$hash->{helper}{TWOFA}      = "";
		$hash->{helper}{SERVER}   = $attr{$name}{server};
		$hash->{helper}{SERVER}   = "layla.amazon.de" if(!defined($hash->{helper}{SERVER}));
		$hash->{helper}{RUNLOGIN} = 0;
		$modules{$hash->{TYPE}}{defptr}{"account"} = $hash;
		
		$hash->{STATE} = "INITIALIZED";

		# set default settings on first define
		if ($init_done) {
			$attr{$name}{icon} = 'echo';
			$attr{$name}{room} = 'Amazon';
		}
		
		InternalTimer(gettimeofday() + 5  , "echodevice_FirstStart" , $hash, 0);
		InternalTimer(gettimeofday() + 10 , "echodevice_GetSettings", $hash, 0);
	}
	else {
  
		$hash->{STATE} = "INITIALIZED";

		$hash->{model} = echodevice_getModel($a[2]);#$a[2];
		
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "model", $hash->{model}, 1);
		readingsBulkUpdateIfChanged($hash, "state", "INITIALIZED", 1);
		readingsEndUpdate($hash,1);
		
		$hash->{helper}{DEVICETYPE} = $a[2];
		$hash->{helper}{".SERIAL"} = $a[3];

		$modules{$hash->{TYPE}}{defptr}{$a[3]} = $hash;

		my $account = $modules{$hash->{TYPE}}{defptr}{"account"};
		
		
		 Log3( "", 3, "[$name] DEV account!!=" . $account);
		
		$hash->{IODev} = $account;
		$attr{$name}{IODev} = $account->{NAME} if( !defined($attr{$name}{IODev}) && $account);
		
		if ($hash->{model} ne "THIRD_PARTY_AVS_MEDIA_DISPLAY") {
			InternalTimer(gettimeofday() + 1, "echodevice_GetSettings", $hash, 0);
		}

	}
  
	Log3 $name, 4, "[$name] [echodevice_Define] Getting auth URL return";
	return undef;
}

sub echodevice_Undefine($$) {
	my ($hash, $arg) = @_;
	my $name = $hash->{NAME};
	RemoveInternalTimer($hash);
	delete( $modules{$hash->{TYPE}}{defptr}{"ACCOUNT"} ) if($hash->{model} eq "ACCOUNT");
	delete( $modules{$hash->{TYPE}}{defptr}{$hash->{helper}{".SERIAL"}} ) if($hash->{model} ne "ACCOUNT");
	return undef;
}

sub echodevice_Notify($$) {
	my ($hash,$dev) = @_;
	my $name = $hash->{NAME};
	return if($dev->{NAME} ne "global");
	return if(!grep(m/^INITIALIZED|REREADCFG$/, @{$dev->{CHANGED}}));
	
	Log3 "echodevice", 4, "[$name] [echodevice_Notify] echodevice: notify reload";

	return undef;
}

sub echodevice_Get($@) {
	my ($hash, @a) = @_;
	shift @a;
	my $command = shift @a;
	my $parameter = join(' ',@a);
	my $name = $hash->{NAME};

	my $usage = "Unknown argument $command, choose one of ";

	return $usage if ($hash->{model} eq 'unbekannt');
	return $usage if ($hash->{model} eq 'Sonos One');
	
	if ($hash->{model} eq "Reverb") {
		$usage .= "help:noArg  " ;
	}
	elsif ($hash->{model} eq "ACCOUNT") {
		$usage .= "settings:noArg devices:noArg actions:noArg tracks:noArg help:noArg conversations:noArg ";
	}
	else {
		$usage .= "tunein settings:noArg primeplayeigene_albums primeplayeigene_tracks primeplayeigene_artists primeplayeigeneplaylist:noArg help:noArg ";
	}
	
	#return "no get" if ($hash->{model} eq "Echo Multiroom");
	return $usage if $command eq '?';
	
	if(IsDisabled($name) && $command ne "help") {
		$hash->{STATE} = "disabled";
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "state", "disabled", 1);
		readingsEndUpdate($hash,1);
		return "$name is disabled. Aborting...";
	}
	
	my $ConnectState = "";
	if($hash->{model} eq "ACCOUNT") {$ConnectState = $hash->{STATE}} else {$ConnectState = $hash->{IODev}->{STATE}}
	
	if ($ConnectState ne "connected" && $command ne "help") {
		return "$name is not connected. Aborting...";
	}

	if($command eq "settings") {
		echodevice_GetSettings($hash);
		return "OK" if($hash->{model} ne "ACCOUNT");
	}
		
	elsif($command eq "actions") {
		echodevice_SendCommand($hash,"getcards","");
	} 
	
	elsif($command eq "devices") {
		echodevice_SendCommand($hash,"devices","");
	}
	
	elsif($command eq "conversations") {
		echodevice_SendCommand($hash,"conversations","");
	} 
  
	elsif($command eq "tunein") {
		echodevice_SendCommand($hash,"searchtunein",$parameter);
	}
	elsif($command eq "tracks") {
		echodevice_SendCommand($hash,"searchtracks",$parameter);
	}
	elsif($command eq "primeplayeigene_albums") {
		echodevice_SendCommand($hash,"primeplayeigene_Albums",$parameter);
	}
	elsif($command eq "primeplayeigene_tracks") {
		echodevice_SendCommand($hash,"primeplayeigene_Tracks",$parameter);
	}
	elsif($command eq "primeplayeigene_artists") {
		echodevice_SendCommand($hash,"primeplayeigene_Artists",$parameter);
	}
	elsif($command eq "primeplayeigeneplaylist") {
		echodevice_SendCommand($hash,"getprimeplayeigeneplaylist","");
	}	
	elsif($command eq "help") {

		my $return = '<html><table align="" border="0" cellspacing="0" cellpadding="3" width="100%" height="100%" class="mceEditable"><tbody>';
		$return   .= "<p><strong>Hilfe:</strong></p>";
		$return   .= "<tr><td><strong>Dokumentation Modul&nbsp;&nbsp;&nbsp</strong></td><td><strong></strong></td></tr>";			
		$return .= "<tr><td>"."Beschreibung"."&nbsp;&nbsp;&nbsp;</td><td><a target=" . "_blank" . " href=" .'"' . 'https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice' .'"'. "</a>https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice</td></tr>";
		$return .= "<tr><td>"."Readings"."&nbsp;&nbsp;&nbsp;</td><td><a target=" . "_blank" . " href=" .'"' . 'https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Readings' .'"'. "</a>https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Readings</td></tr>";
		$return .= "<tr><td>"."Attribute"."&nbsp;&nbsp;&nbsp;</td><td><a target=" . "_blank" . " href=" .'"' . 'https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Attribute' .'"'. "</a>https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Attribute</td></tr>";
		$return .= "<tr><td>"."Set"."&nbsp;&nbsp;&nbsp;</td><td><a target=" . "_blank" . " href=" .'"' . 'https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Set' .'"'. "</a>https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Set</td></tr>";
		$return .= "<tr><td>"."Get"."&nbsp;&nbsp;&nbsp;</td><td><a target=" . "_blank" . " href=" .'"' . 'https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Get' .'"'. "</a>https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Get</td></tr>";
		$return .= "<tr><td>"."Medieninformationen ermitteln"."&nbsp;&nbsp;&nbsp;</td><td><a target=" . "_blank" . " href=" .'"' . 'https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Medieninformationen_ermitteln' .'"'. "</a>https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Medieninformationen_ermitteln</td></tr>";
		$return .= "<tr><td>"."Cookie_ermitteln"."&nbsp;&nbsp;&nbsp;</td><td><a target=" . "_blank" . " href=" .'"' . 'https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Cookie_ermitteln' .'"'. "</a>https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Cookie_ermitteln</td></tr>";
		$return .= "<tr><td>"."MP3 Playlisten"."&nbsp;&nbsp;&nbsp;</td><td><a target=" . "_blank" . " href=" .'"' . 'https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#MP3_Playlisten' .'"'. "</a>https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#MP3_Playlisten</td></tr>";
		$return .= "<tr><td>"."Amazon Stimmen"."&nbsp;&nbsp;&nbsp;</td><td><a target=" . "_blank" . " href=" .'"' . 'https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#AWS_Konfiguration' .'"'. "</a>https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#AWS_Konfiguration</td></tr>";
		$return .= "<tr><td>&nbsp</td><td> </td></tr>";

		$return .= "<tr><td><strong>Diverse Anleitungen</strong></td><td></td></tr>";
		$return .= "<tr><td></td><td></td></tr>";
		$return .= "<tr><td>"."Amazon ECHO TTS/POM"."&nbsp;&nbsp;&nbsp;</td><td><a target=" . "_blank" . " href=" .'"' . 'https://mwinkler.jimdo.com/smarthome/sonstiges/amazon-echo-tts-mp3s' .'"'. "</a>https://mwinkler.jimdo.com/smarthome/sonstiges/amazon-echo-tts-mp3s</td></tr>";
		$return .= "<tr><td>"."MPD Streamserver"."&nbsp;&nbsp;&nbsp;</td><td><a target=" . "_blank" . " href=" .'"' . 'https://mwinkler.jimdo.com/smarthome/sonstiges/mpd-streamserver' .'"'. "</a>https://mwinkler.jimdo.com/smarthome/sonstiges/mpd-streamserver</td></tr>";
		$return .= "<tr><td>"."MPD Web Frontend"."&nbsp;&nbsp;&nbsp;</td><td><a target=" . "_blank" . " href=" .'"' . 'https://mwinkler.jimdo.com/smarthome/sonstiges/mpd-webfrontend' .'"'. "</a>https://mwinkler.jimdo.com/smarthome/sonstiges/mpd-webfrontend</td></tr>";
		$return .= "<tr><td>"."IceCast2"."&nbsp;&nbsp;&nbsp;</td><td><a target=" . "_blank" . " href=" .'"' . 'https://mwinkler.jimdo.com/smarthome/sonstiges/icecast2' .'"'. "</a>https://mwinkler.jimdo.com/smarthome/sonstiges/icecast2</td></tr>";
		$return .= "<tr><td>&nbsp</td><td> </td></tr>";
		
		$return .= "<tr><td><strong>Forum</strong></td><td></td></tr>";
		$return .= "<tr><td></td><td></td></tr>";
		$return .= "<tr><td>"."Forums Thread"."&nbsp;&nbsp;&nbsp;</td><td><a target=" . "_blank" . " href=" .'"' . 'https://forum.fhem.de/index.php/topic,82631.0.html' .'"'. "</a>https://forum.fhem.de/index.php/topic,82631.0.html</td></tr>";
		$return .= "<tr><td>&nbsp</td><td> </td></tr>";
		
		$return .= "</tbody></table></html>";

		return $return;
	}	
	
  return undef;
}

sub echodevice_Set($@) {
	my ($hash, @a) = @_;

	shift @a;
	my $command       = shift @a;
	my $parameter     = join(' ',@a);
	my $name          = $hash->{NAME};
	my $ShoppingListe = ReadingsVal($name, "list_SHOPPING_ITEM", "");
	my $TaskListe     = ReadingsVal($name, "list_TASK", "");
	my $tracks        = AttrVal($name, 'tracks', AttrVal(AttrVal($name, 'IODev', $name), 'tracks', undef));
	my $usage         = 'Unknown argument $command, choose one of ';

	return $usage if ($hash->{model} eq 'unbekannt');
	
	if($hash->{model} eq "ACCOUNT") {
		$usage .= 'login:noArg autocreate_devices:noArg item_shopping_add item_task_add login2FACode ';
		$usage .= 'AWS_Access_Key AWS_Secret_Key TTS_IPAddress TTS_Filename TTS_TuneIn POM_TuneIn POM_IPAddress POM_Filename AWS_OutputFormat:mp3,ogg_vorbis,pcm textmessage ' if(defined($hash->{helper}{".COMMSID"}));
		
		# Einkaufsliste
		my $ShoppingListe = ReadingsVal($name, "list_SHOPPING_ITEM", "");
		my $TaskListe = ReadingsVal($name, "list_TASK", "");
		$ShoppingListe =~ s/ /&nbsp;/g;
		$TaskListe =~ s/ /&nbsp;/g;
		$usage .= ' item_shopping_delete:'.$ShoppingListe;
		$usage .= ' item_task_delete:'.$TaskListe;
	}
	
	elsif ($hash->{model} eq "Echo Multiroom" || $hash->{model} eq "Sonos Display") {
		$usage .= 'volume:slider,0,1,100 play:noArg pause:noArg next:noArg previous:noArg forward:noArg rewind:noArg shuffle:on,off repeat:on,off ';
		$usage .= 'tunein primeplaylist primeplaysender primeplayeigene primeplayeigeneplaylist tts tts_translate:textField-long playownmusic:textField-long saveownplaylist:textField-long ';
		
		if(defined($tracks)) {
				$tracks =~ s/ /_/g;
				$tracks =~ s/:/,/g;
				$usage .= 'track:'.$tracks.' ';
			} 
			else {
				$usage .= 'track ';
		}
		# startownplaylist
		$usage .= echodevice_GetOwnPlaylist($hash);
	}
		
	else {
	
		if ($hash->{model} eq "Reverb" || $hash->{model} eq "Sonos One") {
			$usage .= 'reminder_normal reminder_repeat ';
		}
		else {
			$usage .= 'volume:slider,0,1,100 play:noArg pause:noArg next:noArg previous:noArg forward:noArg rewind:noArg shuffle:on,off repeat:on,off dnd:on,off volume_alarm:slider,0,1,100 ';
			$usage .= 'tunein primeplaylist primeplaysender primeplayeigene primeplayeigeneplaylist reminder_normal reminder_repeat tts tts_translate:textField-long playownmusic:textField-long saveownplaylist:textField-long ';
			
			# startownplaylist
			$usage .= echodevice_GetOwnPlaylist($hash);
			
			if(defined($tracks)) {
				$tracks =~ s/ /_/g;
				$tracks =~ s/:/,/g;
				$usage .= 'track:'.$tracks.' ';
			} 
			else {
				$usage .= 'track ';
			}
			$usage .= 'bluetooth_connect:'.$hash->{helper}{bluetooth}.' bluetooth_disconnect:'.$hash->{helper}{bluetooth}.' ' if(defined($hash->{helper}{bluetooth}));
		}
		
		# Reminder auslesen
		my @ncstrings = ();

		my $NotifiResult ;
		foreach my $NotifiID (sort keys %{$hash->{IODev}->{helper}{"notifications"}{$hash->{helper}{".SERIAL"}}}) {
				if ($hash->{IODev}->{helper}{"notifications"}{$hash->{helper}{".SERIAL"}}{$NotifiID} ne "") {
					$NotifiResult = $hash->{IODev}->{helper}{"notifications"}{$hash->{helper}{".SERIAL"}}{$NotifiID} ;
					$NotifiResult =~s/ /_/g;
					$NotifiResult =~s/,/_/g;
					$NotifiResult =~s/@/_/g;
					$NotifiResult .= "@" . $NotifiID ;
					
					push @ncstrings, $NotifiResult;				
				}
		}
		if (@ncstrings) {
			@ncstrings = sort @ncstrings;
			$usage .= 'notifications_delete:' . join(",", @ncstrings). ' ';
		}

	}

	return $usage if $command eq '?';

	if(IsDisabled($name)) {
		$hash->{STATE} = "disabled";
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "state", "disabled", 1);
		readingsEndUpdate($hash,1);
		return "$name is disabled. Aborting...";
	}
	
	return echodevice_SendLoginCommand($hash,"cookielogin1","") if($command eq "login");

	my $ConnectState = "";
	if($hash->{model} eq "ACCOUNT") {$ConnectState = $hash->{STATE}} else {$ConnectState = $hash->{IODev}->{STATE}}
	
	if ($ConnectState ne "connected" && $command ne "login" && $command ne "login2FACode") {
		return "$name is not connected. Aborting...";
	}
	
	# Allgemeine Einstellungen
	if($command eq "bluetooth_connect"){
		return "No argument given." if ( !defined($a[0]) );

		my @parameters = split("/",$a[0]);
		$parameters[0] =~ s/-/:/g;
  
		my $json = encode_json( { bluetoothDeviceAddress => $parameters[0] } );
		
		echodevice_SendCommand($hash,"bluetooth_connect",$json);
	}
	
	elsif($command eq "autocreate_devices") {
		readingsSingleUpdate ( $hash, "autocreate_devices", "running", 0 );
		echodevice_SendCommand($hash,"autocreate_devices","");
	}
	
	elsif($command eq "bluetooth_disconnect"){
		return "No argument given." if ( !defined($a[0]) );

		my @parameters = split("/",$a[0]);
		$parameters[0] =~ s/-/:/g;
  
		my $json = encode_json( { bluetoothDeviceAddress => $parameters[0] } );
		
		echodevice_SendCommand($hash,"bluetooth_disconnect",$json);
	}
	
	elsif($command eq "dnd"){
		return "No argument given." if ( !defined($a[0]) );
		
		my $json = encode_json( { deviceSerialNumber => $hash->{helper}{".SERIAL"},
                                          deviceType => $hash->{helper}{DEVICETYPE},
                                             enabled => ($a[0] eq "on")?"true":"false" } );
  
		$json =~s/\"true\"/true/g;
		$json =~s/\"false\"/false/g;
	
		echodevice_SendCommand($hash,"dnd",$json);
	}
	
	elsif($command eq "volume") {
		return "No argument given" if ( !defined( $a[0] ) );
	
		# Voluemeangabe prüfen
		if ($a[0] >= 0 && $a[0] <= 100 ) {
			readingsBeginUpdate($hash);
			readingsBulkUpdateIfChanged($hash, "volume", $a[0], 1);
			readingsEndUpdate($hash,1);
			echodevice_SendMessage($hash,"volume",$a[0]);
   		}
		else {
			return "Argument $a[0] does not seem to be a valid integer between 0 and 100";
		}
	}

	elsif($command eq "volume_alarm") {
		return "No argument given" if ( !defined( $a[0] ) );
		# Voluemeangabe prüfen
		if ($a[0] >= 0 && $a[0] <= 100 ) {
		
			my $json = encode_json( { deviceSerialNumber => $hash->{helper}{".SERIAL"},
											  deviceType => $hash->{helper}{DEVICETYPE},
										 softwareVersion => $hash->{helper}{VERSION},
											 volumeLevel => int($a[0]) } );
			readingsBeginUpdate($hash);
			readingsBulkUpdateIfChanged($hash, "volume_alarm", $a[0], 1);
			readingsEndUpdate($hash,1);
			echodevice_SendCommand($hash,"volume_alarm",$json);
   		}
		else {
			return "Argument $a[0] does not seem to be a valid integer between 0 and 100";
		}
	} 
	
	# Listen
	elsif($command eq "item_task_delete" ) {
		return "No argument given." if ( !defined($parameter) );
		
		my $json = JSON->new->utf8(1)->encode( { 'type' => "TASK",
												 'text' => decode_utf8($parameter),
										  'createdDate' => int(time),
											   'itemId' => $hash->{helper}{"ITEMS"}{"TASK"}{"$parameter"},
											 'complete' => "true",
											 'deleted' => "true" } );

		$json =~ s/\"true\"/true/g;
		$json =~ s/\"false\"/false/g;
		
		my @TaskList = split(",",$TaskListe);
		my $Result;
		foreach my $TaskName (@TaskList) {if ($TaskName ne $parameter) {
				if ($Result eq "" ){$Result = $TaskName;} else {$Result .= "," .$TaskName;}}
		}
		readingsBeginUpdate($hash);
		
		if ($Result eq "") {readingsBulkUpdateIfChanged($hash, "list_SHOPPING_ITEM", "" , 1);}
		else {readingsBulkUpdateIfChanged($hash, "list_TASK", $Result , 1);}

		readingsEndUpdate($hash,1);
		
		echodevice_SendCommand($hash,"item_task_delete",$json)
	} 

	elsif($command eq "item_shopping_delete" ) {
		return "No argument given." if ( !defined($parameter) );

		my $json = JSON->new->utf8(1)->encode( { 'type' => "SHOPPING_ITEM",
												 'text' => decode_utf8($parameter),
										  'createdDate' => int(time),
											   'itemId' => $hash->{helper}{"ITEMS"}{"SHOPPING_ITEM"}{"$parameter"},
											 'complete' => "true",
											 'deleted' => "true" } );

		$json =~ s/\"true\"/true/g;
		$json =~ s/\"false\"/false/g;
		
		my @ShoppList = split(",",$ShoppingListe);
		my $Result;
		foreach my $ShopName (@ShoppList) {
			if ($ShopName ne $parameter) {if ($Result eq "" ){$Result = $ShopName;} else {$Result .= "," .$ShopName;}}
		}

		readingsBeginUpdate($hash);
		
		if ($Result eq "") {readingsBulkUpdateIfChanged($hash, "list_SHOPPING_ITEM", "" , 1);}
		else {readingsBulkUpdateIfChanged($hash, "list_SHOPPING_ITEM", $Result , 1);}

		readingsEndUpdate($hash,1);
		
		echodevice_SendCommand($hash,"item_shopping_delete",$json)
	} 

	elsif($command eq "item_task_add" ) {
		return "No argument given." if ( !defined($a[0]) );
		my $json = JSON->new->utf8(1)->encode( { 'type' => "TASK",
												 'text' => decode_utf8($parameter),
										  'createdDate' => int(time),
											   'itemId' => $hash->{helper}{"ITEMS"}{"TASK"}{"$parameter"},
											 'complete' => "false",
											 'deleted' => "false" } );

		$json =~ s/\"true\"/true/g;
		$json =~ s/\"false\"/false/g;
		
		$parameter =~ s/ /_/g;
		
		readingsBeginUpdate($hash);
		if ($TaskListe eq "") {readingsBulkUpdateIfChanged($hash, "list_TASK", $parameter , 1);}
		else {readingsBulkUpdateIfChanged($hash, "list_TASK", $parameter . "," . $TaskListe , 1); }
		readingsEndUpdate($hash,1);
		
		echodevice_SendCommand($hash,"item_task_add",$json)
	} 

	elsif($command eq "item_shopping_add" ) {
		return "No argument given." if ( !defined($parameter) );

		my $json = JSON->new->utf8(1)->encode( { 'type' => "SHOPPING_ITEM",
												 'text' => decode_utf8($parameter),
										  'createdDate' => int(time),
											   'itemId' => $hash->{helper}{"ITEMS"}{"SHOPPING_ITEM"}{"$parameter"},
											 'complete' => "false",
											 'deleted' => "false" } );

		$json =~ s/\"true\"/true/g;
		$json =~ s/\"false\"/false/g;

		$parameter =~ s/ /_/g;
		
		readingsBeginUpdate($hash);
		if ($ShoppingListe eq "") {readingsBulkUpdateIfChanged($hash, "list_SHOPPING_ITEM", $parameter , 1);}
		else {readingsBulkUpdateIfChanged($hash, "list_SHOPPING_ITEM", $parameter . "," . $ShoppingListe , 1); }
		readingsEndUpdate($hash,1);
		
		echodevice_SendCommand($hash,"item_shopping_add",$json)
	} 
		
	# Erinnerungen
	elsif($command eq "reminder_normal") {
		return "No argument given." if ( !defined($a[0]) );
		
		my $reminder_delay = AttrVal($name, "reminder_delay", 10);
		my $ReminderText ;
		my $ReminderDate ;

		# Reading festhalten
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "reminder_normal", join(' ',@a), 1);
		readingsEndUpdate($hash,1);
	
		my ($Tsec, $Tmin, $Thour, $Tmday, $Tmon, $Tyear, $Twday, $Tyday, $Tisdst) = localtime();
	
		# Prüfen es sich um ein Datum handelt
		if (index($a[0], "-") != -1){
			$ReminderDate = str2time($a[0] . " " . $a[1]);
			splice @a, 0, 1;
			splice @a, 0, 1;
			$ReminderText = join(' ',@a);

		}
		elsif (index($a[0], ":") != -1){
			$ReminderDate = str2time(sprintf("%04d",$Tyear+1900)."-".sprintf("%02d",$Tmon+1)."-".sprintf("%02d",$Tmday)." ". $a[0]);
			splice @a, 0, 1;
			$ReminderText = join(' ',@a);
		}
		else {
			$ReminderText = $parameter;
			$ReminderDate = time + $reminder_delay;
		}
		
		my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime($ReminderDate);
		
		my $json = encode_json( { alarmTime => $ReminderDate*1000,	
								  createdDate => int(time)*1000,
								  deviceSerialNumber => $hash->{helper}{".SERIAL"},
								  deviceType => $hash->{helper}{DEVICETYPE},							  
								  id => "createReminder",
								  isRecurring => "false",
								  isSaveInFlight => "true",
								  originalDate => sprintf("%04d",$year+1900)."-".sprintf("%02d",$mon+1)."-".sprintf("%02d",$mday),
								  originalTime => sprintf("%02d",$hour).":".sprintf("%02d",$min).":".sprintf("%02d",$sec).".000",
								  reminderLabel => decode_utf8($ReminderText),
								  status => "ON",
								  type => "Reminder"});	
								  
		$json =~ s/\"true\"/true/g;
		$json =~ s/\"false\"/false/g;		

		echodevice_SendCommand($hash,"reminderitem",$json);
		
	} 
  
	elsif($command eq "reminder_repeat") {
		return "There are some arguments missing. [Zeitangabe] [Wiederholumgsmode] nachrichtentext " if ( !defined($a[0]) );
		return "There are some arguments missing. [Zeitangabe] [Wiederholumgsmode] nachrichtentext " if ( !defined($a[0]) );
		return "There are some arguments missing. [Zeitangabe] [Wiederholumgsmode] nachrichtentext " if ( !defined($a[0]) );
		
		# Reading festhalten
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "reminder_repeat", join(' ',@a), 1);
		readingsEndUpdate($hash,1);
		
		# Vorbereitungen
		my @parameters = split(":",$a[0]);
		my $ReminderRecc = $a[1];
		splice @a, 0, 1;
		splice @a, 0, 1;
		my $ReminderText = join(' ',@a);
		my $recurringPattern = "";

		if    ($ReminderRecc eq "1")  {$recurringPattern = "P1D";}
		elsif ($ReminderRecc eq "2")  {$recurringPattern = "XXXX-WD";}
		elsif ($ReminderRecc eq "3")  {$recurringPattern = "XXXX-WE";}
		elsif ($ReminderRecc eq "4")  {$recurringPattern = "XXXX-WXX-1";}
		elsif ($ReminderRecc eq "5")  {$recurringPattern = "XXXX-WXX-2";}
		elsif ($ReminderRecc eq "6")  {$recurringPattern = "XXXX-WXX-3";}
		elsif ($ReminderRecc eq "7")  {$recurringPattern = "XXXX-WXX-4";}
		elsif ($ReminderRecc eq "8")  {$recurringPattern = "XXXX-WXX-5";}
		elsif ($ReminderRecc eq "9")  {$recurringPattern = "XXXX-WXX-6";}
		elsif ($ReminderRecc eq "10") {$recurringPattern = "XXXX-WXX-7";}
		else  {$recurringPattern = "P1D";}

		my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime();
	 
		my $json = encode_json( { alarmTime => int(time)*1000,	
								  createdDate => int(time)*1000 ,
								  deviceSerialNumber => $hash->{helper}{".SERIAL"},
								  deviceType => $hash->{helper}{DEVICETYPE},							  
								  id => "createReminder",
								  isRecurring => "true",
								  isSaveInFlight => "true",
								  recurringPattern => $recurringPattern,
								  originalDate => sprintf("%04d",$year+1900)."-".sprintf("%02d",$mon+1)."-".sprintf("%02d",$mday),
								  originalTime => sprintf("%02d",$parameters[0]).":".sprintf("%02d",$parameters[1]).":00.000",
								  status => "ON",
								  reminderLabel => decode_utf8($ReminderText),
								  type => "Reminder"});	
								  
		$json =~ s/\"true\"/true/g;
		$json =~ s/\"false\"/false/g;
		
		Log3( $name, 5, "[$name] set reminder_repeat $parameters[0]:$parameters[1] $ReminderRecc Message = $ReminderText");
		
		echodevice_SendCommand($hash,"reminderitem",$json);
		
	} 
    
	elsif($command eq "notifications_delete"){

		return "No argument given" if ( !defined($a[0]));

		my @parameters = split("@",$parameter);
		
		# Reminder aus dem hash entfernen
		$hash->{IODev}->{helper}{"notifications"}{$hash->{helper}{".SERIAL"}}{$parameters[1]} = "";
		
		echodevice_SendCommand($hash,"notifications_delete",$parameters[1]);
	}
	
	# Nachrichten
	elsif($command eq "textmessage"){
		return "No argument given." if ( !defined($a[0]) );
		return "There are some arguments missing. [conversationId] nachrichtentext " if ( !defined($a[1]) );
	
		echodevice_SendCommand($hash,$command,join(' ',@a));
	} 
 
	elsif($command eq "message_delete"){

		#return "No argument given" if ( !defined($a[0]));

		#my @parameters = split("@",$parameter);
		
		# Reminder aus dem hash entfernen
		#$hash->{IODev}->{helper}{"notifications"}{$hash->{helper}{".SERIAL"}}{$parameters[1]} = "";
	
	
		echodevice_SendCommand($hash,"message_delete","");
	}

	# Medien
	elsif($command eq "tunein" || $command eq "ttstunein"){

		my $tuneinID ;
		if ( !defined($a[0]) && AttrVal($name,"tunein_default","none") eq "none" ) {
			return "No argument given. You can set attribut tunein_default!";
		}
		elsif (!defined($a[0]))	{$tuneinID = AttrVal($name,"tunein_default","none");}
		else 					{$tuneinID = $a[0];}
	
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "tunein", $tuneinID, 1);
		echodevice_SendCommand($hash,"tunein",$tuneinID);
		
		# Player aktualisieren
		readingsBulkUpdateIfChanged($hash, "playStatus", "playing", 1);
		readingsEndUpdate($hash,1);
		InternalTimer( gettimeofday() + 10, "echodevice_GetSettings", $hash, 0);
	}
  
	elsif($command eq "primeplaylist"){
		return "No argument given." if ( !defined($a[0]) );
		
		# Reading festhalten
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "primeplaylist", $a[0], 1);
		
		my $json = encode_json( {  asin => $a[0] } );
		
		echodevice_SendCommand($hash,$command,$json);
		
		# Player aktualisieren
		
		readingsBulkUpdateIfChanged($hash, "playStatus", "playing", 1);
		readingsEndUpdate($hash,1);
		InternalTimer( gettimeofday() + 5, "echodevice_GetSettings", $hash, 0);
	}
	
	elsif($command eq "primeplayeigeneplaylist"){
		return "No argument given." if ( !defined($a[0]) );
		
		# Reading festhalten
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "primeplayeigeneplaylist", $a[0], 1);
		
		my $json = encode_json( {  playlistId => $a[0] } );
		
		echodevice_SendCommand($hash,$command,$json);
		
		# Player aktualisieren
		readingsBulkUpdateIfChanged($hash, "playStatus", "playing", 1);
		readingsEndUpdate($hash,1);
		InternalTimer( gettimeofday() + 3, "echodevice_GetSettings", $hash, 0);
	} 

	elsif($command eq "primeplaysender"){
		return "No argument given." if ( !defined($a[0]) );
		
		# Reading festhalten
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "primeplaysender", $a[0], 1);
		
		my $json = encode_json( {  seed => '{"type":"KEY","seedId":"' . $a[0] .'"}' ,stationName => $a[0],seedType => "KEY" } );
		
		echodevice_SendCommand($hash,$command,$json);
		
		# Player aktualisieren
		readingsBulkUpdateIfChanged($hash, "playStatus", "playing", 1);
		readingsEndUpdate($hash,1);
		InternalTimer( gettimeofday() + 3, "echodevice_GetSettings", $hash, 0);
	} 
	
	elsif($command eq "primeplayeigene"){
		return "No argument given." if ( !defined($a[0]) );
	
		# Reading festhalten
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "primeplayeigene", $a[0], 1);

		my @PlayItem = split (/@/s, $parameter);
		my $json = encode_json( {  albumArtistName => $PlayItem[0],albumName => $PlayItem[1]} );
		 
		echodevice_SendCommand($hash,$command,$json);
		
		# Player aktualisieren
		readingsBulkUpdateIfChanged($hash, "playStatus", "playing", 1);
		readingsEndUpdate($hash,1);
		InternalTimer( gettimeofday() + 3, "echodevice_GetSettings", $hash, 0);
	} 

	elsif($command eq "track"){
		
		return "No argument given." if ( !defined($a[0]) );
		
		# Reading festhalten
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "track", $a[0], 1);
		
		my $json = encode_json( { trackId => $a[0],
                            playQueuePrime => "false"} );

		$json =~s/\"true\"/true/g;
		$json =~s/\"false\"/false/g;
		
		echodevice_SendCommand($hash,$command,$json);

		# Player aktualisieren
		readingsBulkUpdateIfChanged($hash, "playStatus", "playing", 1);
		readingsEndUpdate($hash,1);
		InternalTimer( gettimeofday() + 3, "echodevice_GetSettings", $hash, 0);
	}
 	
	elsif($command eq "login2FACode"){
		
		return "No argument given." if ( !defined($a[0]) );
		
		$hash->{helper}{TWOFA} = $a[0];
		
        echodevice_SendLoginCommand($hash,"cookielogin4","");		
	}

	elsif($command eq "AWS_Access_Key" || $command eq "AWS_Secret_Key" ) {
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, lc(".$command"), echodevice_encrypt($parameter), 1);
		readingsEndUpdate($hash,1);	
	}

	elsif($command eq "TTS_Filename" || $command eq "POM_Filename" || $command eq "TTS_TuneIn" || $command eq "POM_TuneIn" || $command eq "AWS_OutputFormat" || $command eq "TTS_IPAddress" || $command eq "POM_IPAddress" ) {
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, lc($command), $parameter, 1);
		readingsEndUpdate($hash,1);		
	}	
	
	elsif($command eq "tts") {

		return "No argument given." if ( !defined($a[0]) );
		
		return "TTS can not play. The ECHO device $name is playing other media." if (AttrVal($hash->{IODev}->{NAME},"TTS_IgnorPlay",1) == 0 && ReadingsVal( $name, "playStatus", "stopped") eq "playing" && ReadingsVal($name , "currentTuneInID", "-") eq "-");
		return "TTS can not play. The ECHO device $name is playing other media." if (AttrVal($name,"TTS_IgnorPlay",1) == 0 && ReadingsVal( $name, "playStatus", "stopped") eq "playing" && ReadingsVal($name , "currentTuneInID", "-") eq "-");
		return "TTS can not play. Please define TTS_IPAdrees at the ECHO ACCOUNT DEVICE " . $hash->{IODev}->{NAME} if (ReadingsVal($hash->{IODev}->{NAME} , lc("TTS_IPAddress"), "none") eq "none");
		
		my $TTS_Voice  = AttrVal($name,"TTS_Voice","German_Female_Google"); 
		
		if ($TTS_Voice eq "German_Female_Google") {
			echodevice_Google($hash,$parameter,$command);
		}
		else {
			echodevice_Amazon($hash,$parameter,$command);
		}

	}

	elsif($command eq "tts_translate") {

		return "No argument given." if ( !defined($a[0]) );
		
		return "TTS can not play. The ECHO device $name is playing other media." if (AttrVal($hash->{IODev}->{NAME},"TTS_IgnorPlay",1) == 0 && ReadingsVal( $name, "playStatus", "stopped") eq "playing" && ReadingsVal($name , "currentTuneInID", "-") eq "-");
		return "TTS can not play. The ECHO device $name is playing other media." if (AttrVal($name,"TTS_IgnorPlay",1) == 0 && ReadingsVal( $name, "playStatus", "stopped") eq "playing" && ReadingsVal($name , "currentTuneInID", "-") eq "-");
		return "TTS can not play. Please define TTS_IPAdrees at the ECHO ACCOUNT DEVICE " . $hash->{IODev}->{NAME} if (ReadingsVal($hash->{IODev}->{NAME} , lc("TTS_IPAddress"), "none") eq "none");
		
		my $TTS_Voice           = AttrVal($name,"TTS_Voice","German_Female_Google"); 
		my $TTS_Translate_From  = AttrVal($name,"TTS_Translate_From","german"); 
		my $TTS_CodeOutput      = "en"; 
		my $TTS_CodeInput       = "de"; 
		
		# Output
		if (index(lc($TTS_Voice), 'english') >= 0) {
			$TTS_CodeOutput  = "en"; 
		}
		elsif (index(lc($TTS_Voice), 'french') >= 0) {
			$TTS_CodeOutput  = "fr"; 
		}
		elsif (index(lc($TTS_Voice), 'portuguese') >= 0) {
			$TTS_CodeOutput  = "pt"; 
		}
		elsif (index(lc($TTS_Voice), 'spanish') >= 0) {
			$TTS_CodeOutput  = "es"; 
		}		
		elsif (index(lc($TTS_Voice), 'dutch') >= 0) {
			$TTS_CodeOutput  = "nl"; 
		}
		elsif (index(lc($TTS_Voice), 'italian') >= 0) {
			$TTS_CodeOutput  = "it"; 
		}
		elsif (index(lc($TTS_Voice), 'japanese') >= 0) {
			$TTS_CodeOutput  = "ja"; 
		}
		elsif (index(lc($TTS_Voice), 'korean') >= 0) {
			$TTS_CodeOutput  = "ko"; 
		}
		elsif (index(lc($TTS_Voice), 'russian') >= 0) {
			$TTS_CodeOutput  = "ru"; 
		}
		elsif (index(lc($TTS_Voice), 'turkish') >= 0) {
			$TTS_CodeOutput  = "tr"; 
		}
		elsif (index(lc($TTS_Voice), 'german') >= 0) {
			$TTS_CodeOutput  = "de"; 
		}
		else {
			return "TTS can not play. Please define other TTS_Voice. Language not supported. Supported languages are:dutch,english,french,german,italian,japanese,korean,portuguese,russian,spanish and turkish";		
		}

		# Input
		if ($TTS_Translate_From eq "dutch")         {$TTS_CodeInput = "nl"}
		elsif ($TTS_Translate_From eq "english")    {$TTS_CodeInput = "en"}
		elsif ($TTS_Translate_From eq "french")     {$TTS_CodeInput = "fr"}
		elsif ($TTS_Translate_From eq "german")     {$TTS_CodeInput = "de"}
		elsif ($TTS_Translate_From eq "italian")    {$TTS_CodeInput = "it"}
		elsif ($TTS_Translate_From eq "japanese")   {$TTS_CodeInput = "ja"}
		elsif ($TTS_Translate_From eq "portuguese") {$TTS_CodeInput = "pl"}
		elsif ($TTS_Translate_From eq "russian")    {$TTS_CodeInput = "ru"}
		elsif ($TTS_Translate_From eq "spanish")    {$TTS_CodeInput = "es"}
		elsif ($TTS_Translate_From eq "turkish")    {$TTS_CodeInput = "tr"}
		
		if ($TTS_CodeInput eq $TTS_CodeOutput) {
			return "TTS can not play. Please define other TTS_Voice or TTS_Translate_From. Input and output languages are the same!";			
		}
		
		my $json = "{ dirCode:'" . $TTS_CodeInput . "-" . $TTS_CodeOutput . "', template:'General', text:'" .urlEncode($parameter) . "', lang:'de', limit:'3000',useAutoDetect:false, key:'123', ts:'MainSite',tid:'', IsMobile:false}";
		
		echodevice_SendCommand($hash,$command,$json);

	}	
	
	elsif($command eq "playownmusic") {

		return "No argument given." if ( !defined($a[0]) );
	
		return "POM can not play. Please define POM_IPAdrees at the ECHO ACCOUNT DEVICE " . $hash->{IODev}->{NAME} if (ReadingsVal($hash->{IODev}->{NAME} , lc("POM_IPAddress"), "none") eq "none");
 		echodevice_PlayOwnMP3($hash,$parameter);

	}

	elsif($command eq "saveownplaylist") {

		return "No argument given." if ( !defined($a[0]) );
	
 		echodevice_SaveOwnPlaylist($hash,$parameter);

	}

	elsif($command eq "playownplaylist") {

		return "No argument given." if ( !defined($a[0]) );
		
		my $WEBAddress = ReadingsVal($hash->{IODev}->{NAME} , lc("POM_IPAddress"), "none");
		return "POM can not play. Please define POM_IPAdrees at the ECHO ACCOUNT DEVICE " . $hash->{IODev}->{NAME} if ($WEBAddress eq "none");	
	
 		echodevice_PlayOwnMP3($hash,"http://" . $WEBAddress . "/playlists/" . $parameter);

	}

	elsif($command eq "deleteownplaylist") {

		return "No argument given." if ( !defined($a[0]) );
	
		# Playliste löschen
		if ((-e $FW_dir . "/echodevice/playlists/". $parameter)) {unlink $FW_dir . "/echodevice/playlists/".$parameter}

	}
	
	else {
		echodevice_SendMessage($hash,$command,$parameter);
				
		# Player aktualisieren
		InternalTimer( gettimeofday() + 2, "echodevice_GetSettings", $hash, 0);
	}

  return ;
}

#########################
sub echodevice_SendMessage($$$) {
	my ($hash,$command,$value) = @_;
	my $name = $hash->{NAME};

	my $json = encode_json( {} );
	
	if($command eq "volume") {
		$json = encode_json( {  type => 'VolumeLevelCommand',
                         volumeLevel => 0+$value,
                contentFocusClientId => undef } );
	} 
	elsif ($command eq "play") {
		$json = encode_json( {  type => 'PlayCommand',
                contentFocusClientId => undef } );
	}

	elsif ($command eq "pause") {
		$json = encode_json( {  type => 'PauseCommand',
                contentFocusClientId => undef } );
	} 
	
	elsif ($command eq "next") {
		$json = encode_json( {  type => 'NextCommand',
                contentFocusClientId => undef } );
	}
	
	elsif ($command eq "previous") {
		$json = encode_json( {  type => 'PreviousCommand',
                contentFocusClientId => undef } );
	} 
	
	elsif ($command eq "forward") {
		$json = encode_json( {  type => 'ForwardCommand',
                contentFocusClientId => undef } );
	} 
  
	elsif ($command eq "rewind") {
		$json = encode_json( {  type => 'RewindCommand',
                contentFocusClientId => undef } );
	}

	elsif ($command eq "shuffle") {
		$json = encode_json( {  type => 'ShuffleCommand',
							 shuffle => ($value eq "on"?"true":"false"),
                contentFocusClientId => undef } );
	}

	elsif ($command eq "repeat") {
		$json = encode_json( {  type => 'RepeatCommand',
                              repeat => ($value eq "on"?"true":"false"),
                contentFocusClientId => undef } );
	}
	
	else {
		Log3 ($name, 4, "[$name] [echodevice_SendMessage] Unknown command $command $value");
		return ;
	}

	Log3 ($name, 4, "[$name] [echodevice_SendMessage] command $command $value");
	
	$json =~s/\"true\"/true/g;
	$json =~s/\"false\"/false/g;

	echodevice_SendCommand($hash,"command",$json);

}

sub echodevice_SendCommand($$$) {
    my ( $hash, $type, $SendData ) = @_;
	my $name = $hash->{NAME};
	my $SendUrl;
	my $SendDataL;
		
	Log3 $name, 4, "[$name] [echodevice_SendCommand] [$type] START";
	
	if($hash->{model} eq "ACCOUNT") {
		return undef if(!defined($hash->{helper}{SERVER}));
		$SendUrl = "https://".$hash->{helper}{SERVER};
	}
	else {
		return undef if(!defined($hash->{IODev}->{helper}{SERVER}));
		$SendUrl = "https://".$hash->{IODev}->{helper}{SERVER};
	}

	my $SendParam ;
	my $SendMetode = "GET" ;
	
	# Ohne JSON
	if ($type eq "bluetoothstate") {
        $SendUrl   .= "/api/bluetooth?cached=true&_=".int(time);
	}
	elsif ($type eq "notifications") {
        $SendUrl   .= "/api/notifications?cached=true&_=".int(time);
	}
	elsif ($type eq "getdnd") {
        $SendUrl   .= "/api/dnd/device-status-list?_=".int(time);
	}
	elsif ($type eq "getdevicesettings") {
        $SendUrl   .= "/api/device-preferences";
	}	
	elsif ($type eq "getisonline") {
        $SendUrl   .= "/api/devices-v2/device?cached=true&_=".int(time);
	}	
	elsif ($type eq "wakeword") {
        $SendUrl   .= "/api/wake-word?_=".int(time);
	}
	elsif ($type eq "alarmvolume") {
        $SendUrl   .= "/api/device-notification-state?_=".int(time);
	}
	elsif ($type eq "activities") {
        $SendUrl   .= "/api/activities?startTime=&size=50&offset=1&_=".int(time);
	}	
	elsif ($type eq "player") {
        $SendUrl   .= "/api/np/player?deviceSerialNumber=".$hash->{helper}{".SERIAL"}."&deviceType=".$hash->{helper}{DEVICETYPE}."&screenWidth=1392&_=".int(time);
	}	
	elsif ($type eq "media") {
        $SendUrl   .= "/api/media/state?deviceSerialNumber=".$hash->{helper}{".SERIAL"}."&deviceType=".$hash->{helper}{DEVICETYPE}."&screenWidth=1392&_=".int(time);
	}
	elsif ($type eq "reminderitem") {
        $SendUrl   .= "/api/notifications/createReminder";
		$SendMetode = "PUT";
	}
	elsif ($type eq "command" || $type eq "volume") {
        $SendUrl   .= "/api/np/command?deviceSerialNumber=".$hash->{helper}{".SERIAL"}."&deviceType=".$hash->{helper}{DEVICETYPE};
		$SendMetode = "POST";
	}
	elsif ($type eq "tunein" || $type eq "ttstunein"  ) {
        $SendUrl   .= "/api/tunein/queue-and-play?deviceSerialNumber=".$hash->{helper}{".SERIAL"}."&deviceType=".$hash->{helper}{DEVICETYPE}."&guideId=".$SendData."&contentType=station&callSign=&mediaOwnerCustomerId=".$hash->{IODev}->{helper}{".CUSTOMER"};
		$SendDataL  = $SendData ;
		$SendData   = "";
		$SendMetode = "POST";		
	}
	elsif ($type eq "getnotifications" ) {
        $SendUrl   .= "/api/notifications";
		$SendData   = "";
	}
	elsif ($type eq "notifications_delete" ) {
        $SendUrl   .= "/api/notifications/".$hash->{helper}{DEVICETYPE}."-".$hash->{helper}{".SERIAL"}."-".$SendData;
		$SendMetode = "DELETE";	
		$SendDataL  = $SendData ;		
		$SendData   = "";
	}
	elsif ($type eq "message_delete" ) {
		$SendUrl   .= "/api/device-preferences/G090L90964350E96";
		$SendMetode = "PUT";		
	}
	elsif ($type eq "track" ) {
        $SendUrl   .= "/api/cloudplayer/queue-and-play?deviceSerialNumber=".$hash->{helper}{".SERIAL"}."&deviceType=".$hash->{helper}{DEVICETYPE}."&mediaOwnerCustomerId=".$hash->{IODev}->{helper}{".CUSTOMER"};
		$SendMetode = "POST";		
	}	
	elsif ($type eq "primeplaylist" ) {
        $SendUrl   .= "/api/prime/prime-playlist-queue-and-play?deviceSerialNumber=".$hash->{helper}{".SERIAL"}."&deviceType=".$hash->{helper}{DEVICETYPE}."&mediaOwnerCustomerId=".$hash->{IODev}->{helper}{".CUSTOMER"};
		$SendMetode = "POST";		
	}		
	elsif ($type eq "primeplayeigeneplaylist" ) {
        $SendUrl   .= "/api/cloudplayer/queue-and-play?deviceSerialNumber=".$hash->{helper}{".SERIAL"}."&deviceType=".$hash->{helper}{DEVICETYPE}."&mediaOwnerCustomerId=".$hash->{IODev}->{helper}{".CUSTOMER"};
		$SendMetode = "POST";		
	}		
	elsif ($type eq "primeplaysender" ) {
        $SendUrl   .= "/api/gotham/queue-and-play?deviceSerialNumber=".$hash->{helper}{".SERIAL"}."&deviceType=".$hash->{helper}{DEVICETYPE}."&mediaOwnerCustomerId=".$hash->{IODev}->{helper}{".CUSTOMER"};
		$SendMetode = "POST";		
	}		
	elsif ($type eq "primeplayeigene" ) {
        $SendUrl   .= "/api/cloudplayer/queue-and-play?deviceSerialNumber=".$hash->{helper}{".SERIAL"}."&deviceType=".$hash->{helper}{DEVICETYPE}."&mediaOwnerCustomerId=".$hash->{IODev}->{helper}{".CUSTOMER"};	
		$SendMetode = "POST";		
	}
	elsif ($type eq "textmessage" ) {
        
		my @parameters = split(" ",$SendData);
		my $conversationid = shift @parameters;
		my $parameter = join(" ",@parameters);
		
		$SendUrl    = "https://alexa-comms-mobile-service.amazon.com/users/".$hash->{helper}{".COMMSID"}."/conversations/".$conversationid."/messages";
		$SendMetode = "POST";
		$SendData   = JSON->new->pretty(1)->utf8(1)->encode([{ "type" => "message/text",
											     "payload" => {"text" => decode_utf8($parameter)} }] );

		$SendData =~s/\//\\\//;
		
	}
	elsif ($type eq "volume_alarm" ) {
        $SendUrl   .= "/api/device-notification-state/".$hash->{helper}{DEVICETYPE}."/".$hash->{helper}{VERSION}."/".$hash->{helper}{".SERIAL"};
		$SendMetode = "PUT";		
	}
	elsif ($type eq "dnd" ) {
        $SendUrl   .= "/api/dnd/status";
		$SendMetode = "PUT";		
	}	
	elsif ($type eq "bluetooth_connect" ) {
        $SendUrl   .= "/api/bluetooth/pair-sink/".$hash->{helper}{DEVICETYPE}."/".$hash->{helper}{".SERIAL"};
		$SendMetode = "POST";		
	}	
	elsif ($type eq "bluetooth_disconnect" ) {
        $SendUrl   .= "/api/bluetooth/disconnect-sink/".$hash->{helper}{DEVICETYPE}."/".$hash->{helper}{".SERIAL"};
		$SendMetode = "POST";		
	}
	elsif ($type eq "listitems_task" || $type eq "listitems_shopping" ) {
        $SendUrl   .= "/api/todos?size=100&startTime=&endTime=&completed=false&type=".$SendData."&deviceSerialNumber=&deviceType=&_=".int(time);
		$SendDataL  = $SendData ;
		$SendData   = "";
	}
	elsif ($type eq "item_shopping_delete" || $type eq "item_task_delete" || $type eq "item_task_add" || $type eq "item_shopping_add" ) {
        $SendUrl   .= "/api/todos/" . $hash->{helper}{".CUSTOMER"};
		$SendMetode = "PUT";		
	}
	elsif ($type eq "account" ) {
        $SendUrl    = "https://alexa-comms-mobile-service.amazon.com/accounts";
		$SendMetode = "GET";		
	}
	elsif ($type eq "homegroup" ) {
        $SendUrl    = "https://alexa-comms-mobile-service.amazon.com/users/".$hash->{helper}{".COMMSID"}."/identities?includeUserName=true";
		$SendMetode = "GET";		
	}
	elsif ($type eq "conversations" ) {
        $SendUrl    = "https://alexa-comms-mobile-service.amazon.com/users/".$hash->{helper}{".COMMSID"}."/conversations?latest=true&includeHomegroup=true&unread=false&modifiedSinceDate=1970-01-01T00:00:00.000Z&includeUserName=true";
	}
	elsif ($type eq "devices" || $type eq "autocreate_devices" ) {
        $SendUrl   .= "/api/devices-v2/device?cached=true&_=".int(time);
	}
	elsif ($type eq "searchtunein" ) {
        $SendUrl   .= "/api/tunein/search?query=".uri_escape_utf8(decode_utf8($SendData))."&mediaOwnerCustomerId=".$hash->{IODev}->{helper}{".CUSTOMER"}."&_=".int(time);
		$SendDataL  = $SendData ;
		$SendData   = "";
	}	
	elsif ($type eq "searchtracks" ) {
        $SendUrl    .= "/api/cloudplayer/playlists/IMPORTED-V0-OBJECTID?deviceSerialNumber=".$hash->{helper}{".SERIAL"}."&deviceType=".$hash->{helper}{DEVICETYPE}."&size=50&offset=&mediaOwnerCustomerId=".$hash->{helper}{".CUSTOMER"}."&_=".int(time);
	}
	elsif ($type eq "getcards" ) {
        $SendUrl    .= "/api/cards?limit=50&beforeCreationTime=".int(time)."000&_=".int(time);
	}
	elsif ($type eq "primeplayeigene_Albums" || $type eq "primeplayeigene_Tracks") {
		my $querytype =  substr($type,16);
		$SendData =~ s/ /+/g;
        $SendUrl   .= "/api/cloudplayer/search?deviceSerialNumber=".$hash->{helper}{".SERIAL"}."&deviceType=".$hash->{helper}{DEVICETYPE}. "&size=50&category=$querytype&query=". $SendData . "&offset=0" .   "&mediaOwnerCustomerId=".$hash->{IODev}->{helper}{".CUSTOMER"}."&_=".int(time);	
		$SendDataL  = $SendData ;
		$SendData   = "";
	}
	elsif ($type eq "primeplayeigene_Artists" ) {
		$SendData =~ s/ /+/g;
        $SendUrl   .= "/api/cloudplayer/albums?deviceSerialNumber=".$hash->{helper}{".SERIAL"}."&deviceType=".$hash->{helper}{DEVICETYPE}. "&size=50&artistName=". $SendData ."&mediaOwnerCustomerId=".$hash->{IODev}->{helper}{".CUSTOMER"}."&_=".int(time);	
		$SendDataL  = $SendData ;
		$SendData   = "";
	}
	elsif ($type eq "getprimeplayeigeneplaylist" ) {
        $SendUrl   .= "/api/cloudplayer/playlists?deviceSerialNumber=".$hash->{helper}{".SERIAL"}."&deviceType=".$hash->{helper}{DEVICETYPE}. "&mediaOwnerCustomerId=".$hash->{IODev}->{helper}{".CUSTOMER"}."&_=".int(time);	
	}
	elsif ($type eq "tts_translate" ) {
        $SendUrl   = "http://www.online-translator.com/services/soap.asmx/GetTranslation";
		$SendMetode = "POST";		
	}	
	
	
	else {
		return;
	}
	
	# Log 
	Log3 $name, 4, "[$name] [echodevice_SendCommand] [$type] PushToCmdQueue SendURL =" .echodevice_anonymize($hash, $SendUrl);
	Log3 $name, 4, "[$name] [echodevice_SendCommand] [$type] PushToCmdQueue SendData=" .$SendDataL;
		
	#2018.01.14 - Übergabe SendCommandQuery
	$SendParam = {
		url             => $SendUrl,
		hash            => $hash,
		data            => $SendData,
		method          => $SendMetode,
		CL              => $hash->{CL},
		httpversion     => "1.1",
		type            => $type
	};
	
	#2018.01.14 - PushToCmdQueue
	push @{$hash->{helper}{CMD_QUEUE}}, $SendParam;  
	echodevice_HandleCmdQueue($hash);
	
	return;
}

sub echodevice_HandleCmdQueue($) {
    my ($hash, $param)  = @_;
    my $name            = $hash->{NAME};
	
	return undef if(!defined($hash->{helper}{CMD_QUEUE})); 
	$hash->{helper}{RUNNING_REQUEST} = 0 if(!defined($hash->{helper}{RUNNING_REQUEST})); 
	
	#Header auslesen
	my $AmazonHeader;

	
	if($hash->{model} eq "ACCOUNT") {$AmazonHeader = "Cookie: ".$hash->{helper}{".COOKIE"}."\r\ncsrf: ".$hash->{helper}{".CSRF"}."\r\nContent-Type: application/json; charset=UTF-8";}
	else 							{$AmazonHeader = "Cookie: ".$hash->{IODev}->{helper}{".COOKIE"}."\r\ncsrf: ".$hash->{IODev}->{helper}{".CSRF"}."\r\nContent-Type: application/json; charset=UTF-8";}
		
	
    if(not($hash->{helper}{RUNNING_REQUEST}) and @{$hash->{helper}{CMD_QUEUE}})
    {
  
		my $params =  {
                       url             => $param->{url},
					   header          => $AmazonHeader,
                       timeout         => 10,
                       noshutdown      => 1,
                       keepalive       => 0,
					   method          => $param->{method},
					   data            => $param->{data},
					   CL              => $param->{CL},
                       hash            => $hash,
					   type            => $param->{type},
					   httpversion     => $param->{httpversion},
                       callback        => \&echodevice_Parse
                      };
  
        my $request = pop @{$hash->{helper}{CMD_QUEUE}};

        map {$hash->{helper}{".HTTP_CONNECTION"}{$_} = $params->{$_}} keys %{$params};
        map {$hash->{helper}{".HTTP_CONNECTION"}{$_} = $request->{$_}} keys %{$request};
		
		my $type = $hash->{helper}{".HTTP_CONNECTION"}{type};
        
        $hash->{helper}{RUNNING_REQUEST} = 1;
        Log3 $name, 4, "[$name] [echodevice_HandleCmdQueue] [$type] send command=" .echodevice_anonymize($hash, $hash->{helper}{".HTTP_CONNECTION"}{url});
        HttpUtils_NonblockingGet($hash->{helper}{".HTTP_CONNECTION"});
    }
}

sub echodevice_SendLoginCommand($$$) {
    my ( $hash, $type, $SendData ) = @_;
	my $name = $hash->{NAME};
	my $SendUrl;
	my $param;
	my $HeaderLanguage = AttrVal($name,"browser_language","de,en-US");# "de,en-US";
	
	# Überspringen wenn Attr cookie gesetzt ist!
	if(AttrVal( $name, "cookie", "none" ) ne "none" && $type ne "cookielogin6") {
		Log3 $name, 3, "[$name] [echodevice_SendLoginCommand] echodevice_FirstStart";
		echodevice_FirstStart($hash);
		return;
	}
	
	# Browser User Agent
	my $UserAgent = AttrVal($name,"browser_useragent","Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101 Firefox/58.0"); 
	
	if (AttrVal($name,"browser_useragent_random",1) == 1) {
		$UserAgent = join('', map{('a'..'z','A'..'Z',0..9)[rand 62]} 0..20);
	}

	readingsSingleUpdate ($hash, "BrowserUserAgent", $UserAgent ,0);
	readingsSingleUpdate ($hash, "BrowserLanguage", $HeaderLanguage ,0);
	
	# COOKIE LOGIN
	if ($type eq "cookielogin1" ) {
		$param->{url} = "https://".$hash->{helper}{SERVER}."/";
		$param->{method} = "GET";
		$param->{ignoreredirects} = 1;
		$param->{header} = "User-Agent: ".$UserAgent."\r\nAccept-Language: " . $HeaderLanguage . "\r\nDNT: 1\r\nConnection: keep-alive\r\nUpgrade-Insecure-Requests: 1";
		$param->{callback} = \&echodevice_Parse;
		$param->{type} = $type;
		$param->{hash} = $hash;
		$param->{timeout} = 10;
		$param->{httpversion} = "1.1";
		
		#Daten zurücksetzen
		$hash->{helper}{".login_postdata"}     = "";
		$hash->{helper}{".login_location"}     = "";
		$hash->{helper}{".login_sessionid"}    = "";
		$hash->{helper}{".login_cookiestring"} = "";
		
		readingsSingleUpdate ($hash, ".COOKIE", "" ,0);
		readingsSingleUpdate ($hash, "COOKIE_TYPE",  "NEW" ,0);
		readingsSingleUpdate ($hash, "COOKIE_STATE", "START" ,0);
	}

	if ($type eq "cookielogin2" ) {
		$param->{url} = "https://".$hash->{helper}{SERVER}."/";
		$param->{method} = "GET";
		$param->{header} = "User-Agent: ".$UserAgent."\r\nAccept-Language: " . $HeaderLanguage . "\r\nDNT: 1\r\nConnection: keep-alive\r\nUpgrade-Insecure-Requests: 1";
		$param->{callback} = \&echodevice_Parse;
		$param->{type} = $type;
		$param->{hash} = $hash;
		$param->{timeout} = 10;
		$param->{httpversion} = "1.1";
	}

	if ($type eq "cookielogin3" ) {
	
		my $location     = $hash->{helper}{".login_location"};
		my $cookiestring = $hash->{helper}{".login_cookiestring"};
		my $postdata     = $hash->{helper}{".login_postdata"};
	
		$param->{url} = "https://www.amazon.de/ap/signin";
		$param->{method} = "POST";
		$param->{header} = "User-Agent: ".$UserAgent."\r\nAccept-Language: " . $HeaderLanguage . "\r\nDNT: 1\r\nConnection: keep-alive\r\nUpgrade-Insecure-Requests: 1\r\nReferer: $location\r\nCookie: $cookiestring";
		$param->{callback} = \&echodevice_Parse;
		$param->{data} = $postdata;
		$param->{type} = $type;
		$param->{hash} = $hash;
		$param->{timeout} = 10;
		$param->{httpversion} = "1.1";
	}

	if ($type eq "cookielogin4" ) {
	
		my $location     = $hash->{helper}{".login_location"};
		my $cookiestring = $hash->{helper}{".login_cookiestring"};
		my $postdata     = $hash->{helper}{".login_postdata"};
		my $sessionid    = $hash->{helper}{".login_sessionid"};
	
		$param->{url}    = "https://www.amazon.de/ap/signin";
		$param->{method} = "POST";
		$param->{header} = "User-Agent: ".$UserAgent."\r\nAccept-Language: " . $HeaderLanguage . "\r\nDNT: 1\r\nConnection: keep-alive\r\nUpgrade-Insecure-Requests: 1\r\nReferer: https://www.amazon.de/ap/signin/$sessionid\r\nCookie: $cookiestring";
		$param->{callback} = \&echodevice_Parse;

		if ($hash->{helper}{TWOFA} eq "") {
			readingsSingleUpdate ($hash, "2FACode", "not used" ,0);
			$param->{data}   = $postdata."email=".uri_escape(echodevice_decrypt($hash->{helper}{".USER"}))."&password=".uri_escape(echodevice_decrypt($hash->{helper}{".PASSWORD"}))."&rememberMe=true";
		}
		else {
			readingsSingleUpdate ($hash, "2FACode", "used " .$hash->{helper}{TWOFA} ,0);
			my $zweiFA       = $hash->{helper}{TWOFA} . "&rememberDevice";
			$param->{data}   = $postdata."email=".uri_escape(echodevice_decrypt($hash->{helper}{".USER"}))."&password=".uri_escape(echodevice_decrypt($hash->{helper}{".PASSWORD"})).$zweiFA;
		}
	
		$param->{ignoreredirects} = 1;
		$param->{type}   = $type;
		$param->{hash}   = $hash;
		$param->{timeout} = 10;
		$param->{httpversion} = "1.1";
		$hash->{helper}{TWOFA} = "";
	}

	if ($type eq "cookielogin5" ) {

		my $cookiestring = $hash->{helper}{".login_cookiestring"};
	
		$param->{url}    = "https://".$hash->{helper}{SERVER}."/api/bootstrap?version=0&_=".int(time);
		$param->{header} = "User-Agent: ".$UserAgent."\r\nAccept-Language: " . $HeaderLanguage . "\r\nDNT: 1\r\nConnection: keep-alive\r\nUpgrade-Insecure-Requests: 1\r\nReferer: https://".$hash->{helper}{SERVER}."/spa/index.html\r\nOrigin: https://".$hash->{helper}{SERVER}."\r\nCookie: $cookiestring";
		$param->{callback} = \&echodevice_Parse;
		$param->{type}   = $type;
		$param->{hash}   = $hash;
		$param->{httpversion} = "1.1";
	}
	
	if ($type eq "cookielogin6" ) {
		$param->{url}        = "https://".$hash->{helper}{SERVER}."/api/bootstrap";
		$param->{header}     = 'Cookie: '.$hash->{helper}{".COOKIE"};
		$param->{callback}   = \&echodevice_ParseAuth;
		$param->{noshutdown} = 1;
		$param->{type}       = $type;
		$param->{hash}       = $hash;
		$param->{timeout} = 10;
		$param->{httpversion} = "1.1";
	}	
	
    HttpUtils_NonblockingGet($param);
	
}

sub echodevice_Parse($$$) {
	my ($param, $err, $data) = @_;
	my $hash = $param->{hash};
	my $name = $hash->{NAME};
	my $msgtype = $param->{type};
  
    Log3 $name, 4, "[$name] [echodevice_Parse] [$msgtype] ";
	Log3 $name, 5, "[$name] [echodevice_Parse] [$msgtype] DATA Dumper=" . Dumper(echodevice_anonymize($hash, $data));

	$hash->{helper}{RUNNING_REQUEST} = 0;
	
	# COOKIE LOGIN Part
	if($msgtype eq "cookielogin1") {

		my $location = $param->{httpheader};
		$location =~ /Location: (.+?)\s/;
		$location = $1;
	
		$hash->{helper}{".login_location"} = $location;
		echodevice_SendLoginCommand($hash,"cookielogin2","");
		return;
	}

	if($msgtype eq "cookielogin2") {

		my (@cookies) = ($param->{httpheader} =~ /Set-Cookie: (.*)\s/g);

		my $cookiestring = "";
		foreach my $cookie (@cookies){
			next if($cookie =~ /1970/);
			$cookie =~ /(.*) (expires=|Version=|Domain)/;
			$cookiestring .= $1." ";
		} 

		my @formparams = ('appActionToken', 'appAction', 'showRmrMe', 'openid.return_to', 'prevRID', 'openid.identity', 'openid.assoc_handle', 'openid.mode', 'failedSignInCount', 'openid.claimed_id', 'pageId', 'openid.ns', 'showPasswordChecked');
		my $postdata = "";
		foreach my $formparam (@formparams){
			my $value = ($data =~ /type="hidden" name="$formparam" value="(.*)"/);
			$value = $1;
			$value =~ /^(.*?)"/;
    		$postdata .= $formparam."=".$1."&"
		} 
	
		$hash->{helper}{".login_postdata"}     = $postdata;
		$hash->{helper}{".login_cookiestring"} = $cookiestring;
		echodevice_SendLoginCommand($hash,"cookielogin3","");
		return;
	}

	if($msgtype eq "cookielogin3") {

		my @formparams = ('appActionToken', 'appAction', 'showRmrMe', 'openid.return_to', 'prevRID', 'openid.identity', 'openid.assoc_handle', 'openid.mode', 'failedSignInCount', 'openid.claimed_id', 'pageId', 'openid.ns', 'showPasswordChecked');
		my $postdata = "";
		foreach my $formparam (@formparams){
			my $value = ($data =~ /type="hidden" name="$formparam" value="(.*)"/);
			$value = $1;
			$value =~ /^(.*?)"/;
			$postdata .= $formparam."=".$1."&"
		} 

		my (@cookies2) = ($param->{httpheader} =~ /Set-Cookie: (.*)\s/g);
  
		my $sessionid = "";
		my $cookiestring2 = "";
		foreach my $cookie (@cookies2){
			next if($cookie =~ /1970/);
			$cookie =~ /(.*) (expires|Version|Domain)/;
			$cookiestring2 .= $1." ";
			$cookiestring2 =~ /ubid-acbde=(.*);/;
			$sessionid = $1;
		} 
	
		$hash->{helper}{".login_postdata"}     = $postdata;
		$hash->{helper}{".login_sessionid"}    = $sessionid;
		$hash->{helper}{".login_cookiestring"}.= $cookiestring2;
		echodevice_SendLoginCommand($hash,"cookielogin4","");
		return;
	}	

	if($msgtype eq "cookielogin4") {

		my (@cookies3) = ($param->{httpheader} =~ /Set-Cookie: (.*)\s/g);
  
		my $cookiestring3 = "";
		my $cookiestring  = $hash->{helper}{".login_cookiestring"};
		
		foreach my $cookie (@cookies3){
			#Log3 $name, 5, "Cookie: ".$cookie;
			next if($cookie =~ /1970/);
			$cookie =~ s/Version=1; //g;
			$cookie =~ /(.*) (expires|Version|Domain)/;
			$cookie = $1;
			next if($cookiestring =~ /\Q$cookie\E/);
			$cookiestring3 .= $cookie." ";
		} 

		$hash->{helper}{".login_cookiestring"}.= $cookiestring3;
		echodevice_SendLoginCommand($hash,"cookielogin5","");
		return;
	}		

	if($msgtype eq "cookielogin5") {

		my (@cookies4) = ($param->{httpheader} =~ /Set-Cookie: (.*)\s/g);
		my $cookiestring4 = "";
		my $cookiestring  = $hash->{helper}{".login_cookiestring"};
		
		foreach my $cookie (@cookies4){
			#Log3 $name, 5, "Cookie: ".$cookie;
			next if($cookie =~ /1970/);
			$cookie =~ s/Version=1; //g;
			$cookie =~ /(.*) (expires|Version)/;
			$cookie = $1;
			next if($cookiestring =~ /\Q$cookie\E/);
			$cookiestring4 .= $cookie." ";
		} 
		$cookiestring .= $cookiestring4;

		$hash->{helper}{".login_cookiestring"}.= $cookiestring4;
		
		if($cookiestring =~ /doctype html/) {
			#RemoveInternalTimer($hash);
			Log3 $name, 4, "[$name] [echodevice_Parse] [$msgtype] Login failed";
			readingsBeginUpdate($hash);
			readingsBulkUpdateIfChanged($hash, "state", "unauthorized", 1);
			readingsEndUpdate($hash,1);
			$hash->{STATE} = "LOGIN ERROR";
			return undef;
		}
	
		$hash->{helper}{".COOKIE"} = $cookiestring;
		$hash->{helper}{".COOKIE"} =~ /csrf=([-\w]+)[;\s]?(.*)?$/ if(defined($hash->{helper}{".COOKIE"}));
		$hash->{helper}{".CSRF"} = $1  if(defined($hash->{helper}{".COOKIE"}));

		if(defined($hash->{helper}{".COOKIE"})){
			readingsSingleUpdate ($hash, ".COOKIE", $hash->{helper}{".COOKIE"} ,0); # Cookie als READING festhalten!
			readingsSingleUpdate ($hash, "COOKIE_TYPE", "NEW" ,0);
			echodevice_SendCommand($hash,"devices","");
		}
		echodevice_SendLoginCommand($hash,"cookielogin6","");
		return;
	}	

	if($msgtype eq "cookielogin6") {
		readingsSingleUpdate ($hash, "COOKIE_STATE", "OK" ,0);
		return;
	}
	
	if($msgtype eq "notifications_delete" || $msgtype eq "reminderitem") {
		
		my $IODev = $hash->{IODev}->{NAME};
		Log3 $name, 5, "[$name] [echodevice_Parse] [$msgtype] sendToFHEM get $IODev settings";
		print (fhem( "get $IODev settings" )) ;
		
		echodevice_HandleCmdQueue($hash);
		return;
	}
    
	if($data =~ /doctype html/ || $data =~ /cookie is missing/){
		#RemoveInternalTimer($hash);
		Log3 $name, 4, "[$name] [echodevice_Parse] [$msgtype] Invalid cookie";
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "state", "unauthorized", 1);
		readingsEndUpdate($hash,1);
		$hash->{STATE} = "COOKIE ERROR";
		echodevice_HandleCmdQueue($hash);
		return undef;
	}

	if($err){
		if($hash->{model} eq "ACCOUNT") {
			echodevice_setState($hash,"disconnected");
			if ($hash->{helper}{RUNLOGIN} == 0) {
				InternalTimer(gettimeofday() + 10 , "echodevice_LoginStart" , $hash, 0);
				$hash->{helper}{RUNLOGIN} = 1;
			}
		}
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "state", "disconnected", 1);
		readingsEndUpdate($hash,1);
		Log3 $name, 4, "[$name] [echodevice_Parse] [$msgtype] connection error $msgtype $err";
		echodevice_HandleCmdQueue($hash);
		return undef;
	}
  
	if($data =~ /No routes found/){

		# Spezial set Volume
		if ($msgtype eq "command") {}
		else {
			Log3 $name, 4, "[$name] [echodevice_Parse] [$msgtype] No routes found $msgtype";
			readingsBeginUpdate($hash);
			readingsBulkUpdateIfChanged($hash, "state", "timeout", 1);	
			readingsEndUpdate($hash,1);
		}

		echodevice_HandleCmdQueue($hash);
		return undef;
	}
	
	if($data =~ /UnknownOperationException/){
		Log3 $name, 4, "[$name] [echodevice_Parse] [$msgtype] Unknown Operation";
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "state", "unknown", 1);
		readingsEndUpdate($hash,1);
		echodevice_HandleCmdQueue($hash);
		return undef;
	}

	if($msgtype eq "null"){
		echodevice_HandleCmdQueue($hash);
		return undef;
	}
	
	elsif($msgtype eq "setting") {
		InternalTimer( gettimeofday() + 3, "echodevice_GetSettings", $hash, 0);
		echodevice_HandleCmdQueue($hash);
		return undef;
	}
	
	elsif($msgtype eq "command") {
		InternalTimer( gettimeofday() + 3, "echodevice_GetSettings", $hash, 0);
		echodevice_HandleCmdQueue($hash);
		return undef;
	}
	
	elsif($msgtype eq "primeplaylist") {
		echodevice_HandleCmdQueue($hash);
		return undef;
	}
	
	elsif($msgtype eq "track") {
		echodevice_HandleCmdQueue($hash);
		return undef;
	}
	
	elsif($msgtype eq "primeplayeigeneplaylist" || $msgtype eq "primeplayeigene" || $msgtype eq "primeplaysender") {
		echodevice_HandleCmdQueue($hash);
		return undef;
	}
	
	elsif($msgtype eq "textmessage") {
		echodevice_HandleCmdQueue($hash);
		return undef;
	}
	
	elsif($msgtype eq "volume_alarm") {
		echodevice_HandleCmdQueue($hash);
		return undef;
	}
	
	elsif($msgtype eq "bluetooth_disconnect") {
		echodevice_HandleCmdQueue($hash);
		return undef;
	}
	
	elsif($msgtype eq "bluetooth_connect") {
		echodevice_HandleCmdQueue($hash);
		return undef;
	}
	
	elsif($msgtype eq "dnd") {
		echodevice_HandleCmdQueue($hash);
		return undef;
	}

	elsif($msgtype eq "list") {
		echodevice_HandleCmdQueue($hash);
		return undef;
	}	

	elsif($msgtype eq "item_task_delete" || $msgtype eq "item_task_add") {
		echodevice_HandleCmdQueue($hash);
		echodevice_SendCommand($hash,"listitems_task","TASK");
		return undef;
	}		

	elsif($msgtype eq "item_shopping_delete" || $msgtype eq "item_shopping_add") {
		echodevice_HandleCmdQueue($hash);
		echodevice_SendCommand($hash,"listitems_shopping","SHOPPING_ITEM");
		return undef;
	}	

	if($@) {
		if($data =~ /doctype html/ || $data =~ /cookie is missing/){
			#RemoveInternalTimer($hash);
			Log3 $name, 4, "[$name] [echodevice_Parse] [$msgtype] Invalid cookie";
			readingsBeginUpdate($hash);
			readingsBulkUpdateIfChanged($hash, "state", "unauthorized", 1);
			readingsEndUpdate($hash,1);
			$hash->{STATE} = "COOKIE ERROR";
			#InternalTimer( gettimeofday() + 10, "echodevice_CheckAuth", $hash, 0) if($hash->{model} eq "ACCOUNT");
			echodevice_HandleCmdQueue($hash);
			return undef;
		}
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "state", "error", 1);
		readingsEndUpdate($hash,1);
		Log3 $name, 4, "[$name] [echodevice_Parse] [$msgtype] json evaluation error ".$@."\n".Dumper(echodevice_anonymize($hash, $data));
		echodevice_HandleCmdQueue($hash);
		return undef;
	}

	readingsBeginUpdate($hash);
	readingsBulkUpdateIfChanged($hash, "state", "connected", 1);
	readingsEndUpdate($hash,1);

	# Prüfen ob es sich um ein json String handelt!
	if (index($data, '{') == -1) {$data = '{"data": "nodata"}';}
	
	my $json = eval { JSON->new->utf8(0)->decode($data) };
		
	if($msgtype eq "activities") {

		if(defined($json->{activities}) && ref($json->{activities}) eq "ARRAY") {
			foreach my $card (@{$json->{activities}}) {
				# Device ID herausfiltern
				my $sourceDeviceIds = ""; 
				foreach my $cards (@{$card->{sourceDeviceIds}}) {
					next if (echodevice_getModel($cards->{deviceType}) eq "Echo Multiroom");
					next if (echodevice_getModel($cards->{deviceType}) eq "Sonos Display");
					next if (echodevice_getModel($cards->{deviceType}) eq "unbekannt");
					$sourceDeviceIds = $cards->{serialNumber};
				}
			
				# Informationen in das ECHO Device eintragen
				if(defined($modules{$hash->{TYPE}}{defptr}{$sourceDeviceIds})) {
					my $echohash = $modules{$hash->{TYPE}}{defptr}{$sourceDeviceIds};
					my $timestamp = int(time - ReadingsAge($echohash->{NAME},'voice',time));
					
					next if($timestamp >= int($card->{creationTimestamp}/1000));
					next if($card->{description} !~ /firstUtteranceId/);
				  
					my $textjson = $card->{description};
					$textjson =~ s/\\//g;
					my $cardjson = eval { JSON->new->utf8(0)->decode($textjson) };

					next if($@);
					next if(!defined($cardjson->{summary}));
					next if($cardjson->{summary} eq "");
					
					$echohash->{".updateTimestamp"} = FmtDateTime(int($card->{creationTimestamp}/1000));
					readingsBeginUpdate($echohash);
					readingsBulkUpdateIfChanged($echohash, "voice", $cardjson->{summary}, 1);
					readingsEndUpdate($echohash,1);
					$echohash->{CHANGETIME}[0] = FmtDateTime(int($card->{creationTimestamp}/1000));
				}	
			}
		}
	} 
  
  	elsif($msgtype eq "account") {
		my $i=1;

		if ($data eq '{"data": "nodata"}') {
			Log3 $name, 3, "[$name] [echodevice_Parse] [$msgtype] Invalid authentication token! Generate new COOKIE!" ;
			echodevice_SendLoginCommand($hash,"cookielogin1","");
		}
		else {
			if(ref($json) eq 'ARRAY') {
				foreach my $account (@{$json}) {
				  $hash->{helper}{".COMMSID"}  = $account->{commsId} if(defined($account->{commsId}));
				  $hash->{helper}{".DIRECTID"} = $account->{directedId} if(defined($account->{directedId}));
				  last if(1<$i++);
				}			
			}
			else {
				Log3 $name, 3, "[$name] [echodevice_Parse] [$msgtype] Invalid DATA! = $data / Generate new COOKIE!" ;
				echodevice_SendLoginCommand($hash,"cookielogin1","");
			}
		}
	}
	
	elsif($msgtype eq "cards") {
		my $timestamp = int(time - ReadingsAge($name,'voice',time));
		return undef if(!defined($json->{cards}));
		return undef if(ref($json->{cards}) ne "ARRAY");
		foreach my $card (reverse(@{$json->{cards}})) {
			#next if($card->{cardType} ne "TextCard");
			#next if($card->{sourceDevice}{serialNumber} ne $hash->{helper}{".SERIAL"});
			next if($timestamp >= int($card->{creationTimestamp}/1000));
			next if(!defined($card->{playbackAudioAction}{mainText}));
			readingsBeginUpdate($hash);
			$hash->{".updateTimestamp"} = FmtDateTime(int($card->{creationTimestamp}/1000));
			readingsBulkUpdateIfChanged( $hash, "voice", $card->{playbackAudioAction}{mainText}, 1 );
			$hash->{CHANGETIME}[0] = FmtDateTime(int($card->{creationTimestamp}/1000));
			readingsEndUpdate($hash,1);
		}
		return undef;
	} 
  
	elsif($msgtype eq "media") {

		readingsBeginUpdate($hash);
		
		if (defined($json->{currentState} )) {
			if ($json->{currentState} ne "IDLE") {
				#echodevice_SendCommand($hash,"player",""); # Player läuft! Daten abfragen!
			}
			else {
				readingsBulkUpdateIfChanged($hash, "progress", "0", 1);
				readingsBulkUpdateIfChanged($hash, "progresslen", "0", 1);
				readingsBulkUpdateIfChanged($hash, "shuffle", $json->{shuffling}?"on":"off", 1) if(defined($json->{shuffling}));
				readingsBulkUpdateIfChanged($hash, "repeat", $json->{looping}?"on":"off", 1) if(defined($json->{looping}));
				readingsBulkUpdateIfChanged($hash, "volume", $json->{volume}, 1) if(defined($json->{volume}));
				readingsBulkUpdateIfChanged($hash, "mute", $json->{muted}?"on":"off", 1) if(defined($json->{muted}));	
			}
		}

		readingsEndUpdate($hash,1);
	} 
  
	elsif($msgtype eq "player") {
	
		# Beenden wenn keine Daten vorhanden!
		if(defined($json->{playerInfo})){
			readingsBeginUpdate($hash);
			my $TempTuneInName ;
			my $TempTuneInURL  ;

			# Play Status
			if(!defined($json->{playerInfo}{state}) || $json->{playerInfo}{state} eq "IDLE" ){
				readingsBulkUpdateIfChanged($hash, "playStatus", "stopped", 1);
				readingsBulkUpdateIfChanged($hash, "currentArtwork", "-", 1);
				readingsBulkUpdateIfChanged($hash, "currentTitle", "-", 1);
				readingsBulkUpdateIfChanged($hash, "currentArtist", "-", 1);
				readingsBulkUpdateIfChanged($hash, "currentAlbum", "-", 1);
				readingsBulkUpdateIfChanged($hash, "currentTuneInID", "-", 1);
				readingsBulkUpdateIfChanged($hash, "channel", "-", 1);
				readingsBulkUpdateIfChanged($hash, "progress", 0, 1);
				readingsBulkUpdateIfChanged($hash, "progresslen", 0, 1);
			}
			else {
				
				readingsBulkUpdateIfChanged($hash, "playStatus",  lc($json->{playerInfo}{state}), 1);
				
				if(defined($json->{playerInfo}{infoText})) {
					readingsBulkUpdateIfChanged($hash, "currentTitle", $json->{playerInfo}{infoText}{title}, 1) if(defined($json->{playerInfo}{infoText}{title}));
					readingsBulkUpdateIfChanged($hash, "currentArtist", $json->{playerInfo}{infoText}{subText1}, 1) if(defined($json->{playerInfo}{infoText}{subText1}));
					readingsBulkUpdateIfChanged($hash, "currentAlbum", $json->{playerInfo}{infoText}{subText2}, 1) if(defined($json->{playerInfo}{infoText}{subText2}));
					readingsBulkUpdateIfChanged($hash, "currentTitle", "-", 1) if(!defined($json->{playerInfo}{infoText}{title}));
					readingsBulkUpdateIfChanged($hash, "currentArtist", "-", 1) if(!defined($json->{playerInfo}{infoText}{subText1}));
					readingsBulkUpdateIfChanged($hash, "currentAlbum", "-", 1) if(!defined($json->{playerInfo}{infoText}{subText2}));
				}
				
				if(defined($json->{playerInfo}{provider})) {
					readingsBulkUpdateIfChanged($hash, "channel", $json->{playerInfo}{provider}{providerName}, 1) if(defined($json->{playerInfo}{provider}{providerName}));
					$TempTuneInName = "TuneIn" if (lc($json->{playerInfo}{provider}{providerName}) eq 'tunein live-radio') ;
				} else {
					readingsBulkUpdateIfChanged($hash, "channel", "-", 1);
				}
				
				if(defined($json->{playerInfo}{mainArt})) {
					if(defined($json->{playerInfo}{mainArt}{url})){
						readingsBulkUpdateIfChanged($hash, "currentArtwork", $json->{playerInfo}{mainArt}{url}, 1);
						$TempTuneInURL = $json->{playerInfo}{mainArt}{url};
					}
					else{
						readingsBulkUpdateIfChanged($hash, "currentArtwork", "-", 1);
					}
				}

				if (lc($json->{playerInfo}{state}) eq "playing") {
					# TuneIn ID festhalten
					if ($TempTuneInURL ne "" && $TempTuneInName eq "TuneIn") {
						my @TuneInID = split("/",$TempTuneInURL);
						if (@TuneInID >= 3) {
							$TempTuneInName = @TuneInID[3];
							$TempTuneInName =~ s/(\D+)//;
							$TempTuneInName =~ s/(\D+)//;
							$TempTuneInName = "s" . $TempTuneInName;
						}
						else {
							$TempTuneInName = "-";
						}
						readingsBulkUpdateIfChanged($hash, "currentTuneInID", $TempTuneInName , 1);
					} 
					else {
						readingsBulkUpdateIfChanged($hash, "currentTuneInID", "-", 1);
					}
				}
				else {
					readingsBulkUpdateIfChanged($hash, "currentTuneInID", "-", 1);
				}
				
				if(defined($json->{playerInfo}{progress})) {
					readingsBulkUpdateIfChanged($hash, "progress", $json->{playerInfo}{progress}{mediaProgress}, 1) if(defined($json->{playerInfo}{progress}{mediaProgress}));
					readingsBulkUpdateIfChanged($hash, "progress", 0, 1) if(!defined($json->{playerInfo}{progress}{mediaProgress}));
					readingsBulkUpdateIfChanged($hash, "progresslen", $json->{playerInfo}{progress}{mediaLength}, 1) if(defined($json->{playerInfo}{progress}{mediaLength}));
					readingsBulkUpdateIfChanged($hash, "progresslen", 0, 1) if(!defined($json->{playerInfo}{progress}{mediaLength}));
				}
				
				if(defined($json->{playerInfo}{volume})) {
					readingsBulkUpdateIfChanged($hash, "volume", $json->{playerInfo}{volume}{volume}, 1) if(defined($json->{playerInfo}{volume}{volume}));
					readingsBulkUpdateIfChanged($hash, "mute", $json->{playerInfo}{volume}{muted}?"on":"off", 1) if(defined($json->{playerInfo}{volume}{muted}));
				}
				
				if(defined($json->{playerInfo}{transport}{shuffle})) {
					if($json->{playerInfo}{transport}{shuffle} eq "SELECTED") {readingsBulkUpdateIfChanged($hash, "shuffle", "true", 1);}
					else{readingsBulkUpdateIfChanged($hash, "shuffle", "false", 1);}
				}
				
				if(defined($json->{playerInfo}{transport}{repeat})) {
					if($json->{playerInfo}{transport}{repeat} eq "SELECTED") {readingsBulkUpdateIfChanged($hash, "repeat", "true", 1);}
					else{readingsBulkUpdateIfChanged($hash, "repeat", "false", 1);}
				}
			}
			readingsEndUpdate($hash,1);
		}
	} 
  
	elsif($msgtype eq "listitems_task" || $msgtype eq "listitems_shopping" ) {
		my $listtype ;#= $param->{listtype};
		my @listitems;
		my $Firststart = "1";
		my $Text ;
		
		$listtype = "TASK" if ($msgtype eq "listitems_task");
		$listtype = "SHOPPING_ITEM" if ($msgtype eq "listitems_shopping");
		
		foreach my $item ( @{ $json->{values} } ) {
		  
			if ($Firststart eq "1"){
				$hash->{helper}{"ITEMS"}{$item->{type}} = ();
				$Firststart = "0";
			}
		  
			next if ($item->{complete});
			$item->{text} =~ s/,/;/g;
			$item->{text} =~ s/ /_/g;		  
			$Text = $item->{text};
			push @listitems, $item->{text};

			$hash->{helper}{"ITEMS"}{$item->{type}}{$item->{text}} = $item->{itemId};
		  		  
		}
		readingsBeginUpdate($hash);
		
		if (@listitems) {
			readingsBulkUpdateIfChanged( $hash, "list_".$listtype, join(",", @listitems),  1 );
		} else {
			readingsBulkUpdateIfChanged( $hash, "list_".$listtype, "",  1 );
		}
		
		readingsEndUpdate($hash,1);
	} 

	elsif($msgtype eq "getnotifications") {
		my @ncstrings;
		@ncstrings = ();
		$hash->{helper}{"notifications"} = ();
		my $RunningID = time();
		my $NotifiCount ;
		my $NotifiReTime = 99999999;
		my $TimerReTime = 99999999 ;
		my $iFrom ;
		
		foreach my $device (@{$json->{notifications}}) {
			
			next if ($device->{status} eq "OFF" && (lc($device->{type}) ne "reminder" || lc($device->{type}) ne "timer"));

			my $ncstring ;
				
			if(lc($device->{type}) eq "reminder") {
				$ncstring  = $device->{type} . "_" . FmtDateTime($device->{alarmTime}/1000) . "_";
				$ncstring .= $device->{recurringPattern} . "_" if (defined($device->{recurringPattern}));
				$ncstring .= $device->{reminderLabel} ;
			}
			elsif(lc($device->{type}) eq "timer") {
				$ncstring = $device->{type} . "_" . $device->{remainingTime}
			}
			else {
				$ncstring = $device->{type} . "_" . $device->{originalTime} ;			
			}
			$hash->{helper}{"notifications"}{$device->{deviceSerialNumber}}{$device->{notificationIndex}} = $ncstring;
			
			#Reading anlegen
			my $echohash = $modules{$hash->{TYPE}}{defptr}{$device->{deviceSerialNumber}};
			
			if (!defined($hash->{helper}{"notifications"}{"_".$device->{deviceSerialNumber}}{"count_" . $device->{type}})) {
				$NotifiCount = 1;
			}
			else {
				$NotifiCount = int($hash->{helper}{"notifications"}{"_".$device->{deviceSerialNumber}}{"count_" . $device->{type}}) + 1
			}
			
			next if(!defined($echohash));
			
			readingsBeginUpdate($echohash);
			
			if(lc($device->{type}) eq "reminder") {
				readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_" . sprintf("%02d",$NotifiCount) . "_alarmtime"  , FmtDateTime($device->{alarmTime}/1000), 1 );
				readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_" . sprintf("%02d",$NotifiCount) . "_alarmticks"  , $device->{alarmTime}/1000, 1 );
				readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_" . sprintf("%02d",$NotifiCount) . "_id"  , $device->{notificationIndex},1);
				readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_" . sprintf("%02d",$NotifiCount) . "_recurring"  , $device->{recurringPattern},1) if (defined($device->{recurringPattern}));
				readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_" . sprintf("%02d",$NotifiCount) . "_recurring"  , 0,1) if (!defined($device->{recurringPattern}));
			}
			elsif(lc($device->{type}) eq "timer") {
				readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_" . sprintf("%02d",$NotifiCount) . "_remainingtime"  , int($device->{remainingTime} / 1000), 1 );
				readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_" . sprintf("%02d",$NotifiCount) . "_id"  , $device->{notificationIndex},1);
				
				if (int($device->{remainingTime} / 1000) < $TimerReTime) {
					$TimerReTime = int($device->{remainingTime} / 1000);
					readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_remainingtime"  , int($device->{remainingTime} / 1000), 1 );
					readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_id"  , $device->{notificationIndex},1);
				}
				
				if ($TimerReTime <$NotifiReTime) {$NotifiReTime = $TimerReTime;}
			}
			else {
				readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_" . sprintf("%02d",$NotifiCount) . "_originalTime"  , $device->{originalTime}, 1 );
				readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_" . sprintf("%02d",$NotifiCount) . "_id"  , $device->{notificationIndex},1);
				readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_" . sprintf("%02d",$NotifiCount) . "_status"  , lc($device->{status}),1);
			}

			# Infos im Hash hinterlegen
			$hash->{helper}{"notifications"}{"_".$device->{deviceSerialNumber}}{"count_" . $device->{type}} = $NotifiCount;
			$hash->{helper}{"notifications"}{"_".$device->{deviceSerialNumber}}{lc($device->{type})."_aktiv"} = 1;

			readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_count"  , $NotifiCount,1);
			
			readingsEndUpdate($echohash,1);
			
		}

		# Timer neu setzen wenn der Timer gleich abläuft
		if ($NotifiReTime < 60 && $NotifiReTime > 0) {InternalTimer(gettimeofday() + $NotifiReTime , "echodevice_GetSettings", $hash, 0);}
		
		# Readings bereinigen
		my $nextupdate = int(AttrVal($name,"intervalsettings",60));
		
		foreach my $DeviceID (sort keys %{$modules{$hash->{TYPE}}{defptr}}) {

			next if (echodevice_getModel($modules{$hash->{TYPE}}{defptr}{$DeviceID}{model}) eq "Echo Multiroom");
			next if (echodevice_getModel($modules{$hash->{TYPE}}{defptr}{$DeviceID}{model}) eq "Sonos Display");
			next if (echodevice_getModel($modules{$hash->{TYPE}}{defptr}{$DeviceID}{model}) eq "unbekannt");
		
			my $DeviceName = $modules{$hash->{TYPE}}{defptr}{$DeviceID}{NAME};
			my $echohash   = $modules{$hash->{TYPE}}{defptr}{$DeviceID};
			readingsBeginUpdate($echohash);

			# Timer auswerten
			my $TimerAktiv = 0;
			foreach my $i (1..20) {
				my $ReadingAge = int(ReadingsAge($DeviceName, "timer_" . sprintf("%02d",$i) . "_remainingtime", 2000));
				
				if ($ReadingAge == 2000){last;} 
				elsif ($ReadingAge > $nextupdate) {
					readingsDelete($echohash, "timer_" . sprintf("%02d",$i) . "_id") ;
					readingsDelete($echohash, "timer_" . sprintf("%02d",$i) . "_remainingtime") ;
				}
				else {$TimerAktiv=1;}
			}
			
			if ($TimerAktiv == 0) {
				readingsBulkUpdateIfChanged( $echohash, "timer_count"  , 0,1);
				readingsBulkUpdateIfChanged( $echohash, "timer_id"  , "-",1);
				readingsBulkUpdateIfChanged( $echohash, "timer_remainingtime"  , 0,1);
			}

			# Erinnerungen auswerten			
			my $ReminderAktiv = 0;
			$ReminderAktiv = $hash->{helper}{"notifications"}{"_".$DeviceID}{"reminder_aktiv"} if (defined($hash->{helper}{"notifications"}{"_".$DeviceID}{"reminder_aktiv"}));
		
			if ($ReminderAktiv eq "0") {
				readingsBulkUpdateIfChanged( $echohash, "reminder_count"  , 0,1);
			}
			else {
				$hash->{helper}{"notifications"}{"_".$DeviceID}{"reminder_aktiv"} = 0
			}

			$iFrom = int(ReadingsVal($DeviceName, "reminder_count", 0)) +1 ;
			
			foreach my $i ($iFrom..20) {
				
				if (ReadingsVal($DeviceName, "reminder_" . sprintf("%02d",$i) . "_alarmticks", "none") ne "none"){
					readingsDelete($echohash, "reminder_" . sprintf("%02d",$i) . "_id") ;
					readingsDelete($echohash, "reminder_" . sprintf("%02d",$i) . "_alarmticks") ;
					readingsDelete($echohash, "reminder_" . sprintf("%02d",$i) . "_alarmtime") ;
					readingsDelete($echohash, "reminder_" . sprintf("%02d",$i) . "_recurring") ;
				}
				else {last;}
			}
			
			# Alarm auswerten
			my $AlarmAktiv = 0;
			$AlarmAktiv = $hash->{helper}{"notifications"}{"_".$DeviceID}{"alarm_aktiv"} if (defined($hash->{helper}{"notifications"}{"_".$DeviceID}{"alarm_aktiv"}));
		
			if ($AlarmAktiv eq "0") {
				readingsBulkUpdateIfChanged( $echohash, "alarm_count"  , 0,1);
			}
			else {
				$hash->{helper}{"notifications"}{"_".$DeviceID}{"alarm_aktiv"} = 0
			}

			$iFrom = int(ReadingsVal($DeviceName, "alarm_count", 0)) +1 ;
			
			foreach my $i ($iFrom..20) {
				
				if (ReadingsVal($DeviceName, "alarm_" . sprintf("%02d",$i) . "_id", "none") ne "none"){
					readingsDelete($echohash, "alarm_" . sprintf("%02d",$i) . "_id") ;
					readingsDelete($echohash, "alarm_" . sprintf("%02d",$i) . "_originalTime") ;
					readingsDelete($echohash, "alarm_" . sprintf("%02d",$i) . "_status") ;
				}
				else {last;}
			}
			
			# Musikalarm auswerten
			my $MusikAlarmAktiv = 0;
			$MusikAlarmAktiv = $hash->{helper}{"notifications"}{"_".$DeviceID}{"musikalarm_aktiv"} if (defined($hash->{helper}{"notifications"}{"_".$DeviceID}{"musicalarm_aktiv"}));
		
			if ($MusikAlarmAktiv eq "0") {
				readingsBulkUpdateIfChanged( $echohash, "musicalarm_count"  , 0,1);
			}
			else {
				$hash->{helper}{"notifications"}{"_".$DeviceID}{"musicalarm_aktiv"} = 0
			}

			$iFrom = int(ReadingsVal($DeviceName, "musicalarm_count", 0)) +1 ;
			
			foreach my $i ($iFrom..20) {
				
				if (ReadingsVal($DeviceName, "musicalarm_" . sprintf("%02d",$i) . "_id", "none") ne "none"){
					readingsDelete($echohash, "musicalarm_" . sprintf("%02d",$i) . "_id") ;
					readingsDelete($echohash, "musicalarm_" . sprintf("%02d",$i) . "_originalTime") ;
					readingsDelete($echohash, "musicalarm_" . sprintf("%02d",$i) . "_status") ;
				}
				else {last;}
			}
			
			readingsEndUpdate($echohash,1);
		}
	} 
		
	elsif($msgtype eq "homegroup") {
		$hash->{helper}{HOMEGROUP} = $json->{homeGroupId} if(defined($json->{homeGroupId}));
		$hash->{helper}{SIPS} = $json->{aor} if(defined($json->{aor}));
	} 
	
	elsif($msgtype eq "bluetoothstate") {
		my @btstrings;
		
		foreach my $device (@{$json->{bluetoothStates}}) {
			@btstrings = ();
			if(defined($modules{$hash->{TYPE}}{defptr}{$device->{deviceSerialNumber}})) {
				foreach my $btdevice (@{$device->{pairedDeviceList}}) {
					next if(!defined($btdevice->{friendlyName}));
					next if (echodevice_getModel($btdevice->{deviceType}) eq "Reverb");
					next if (echodevice_getModel($btdevice->{deviceType}) eq "unbekannt");
					
					$btdevice->{address} =~ s/:/-/g;
					$btdevice->{friendlyName} =~ s/ /_/g;
					$btdevice->{friendlyName} =~ s/,/./g;
					my $btstring .= $btdevice->{address}."/".$btdevice->{friendlyName};
					push @btstrings, $btstring;
				}
				$modules{$hash->{TYPE}}{defptr}{$device->{deviceSerialNumber}}->{helper}{bluetooth} = join(",", @btstrings) if (@btstrings);
				$modules{$hash->{TYPE}}{defptr}{$device->{deviceSerialNumber}}->{helper}{bluetooth} = "-" if(!defined($modules{$hash->{TYPE}}{defptr}{$device->{deviceSerialNumber}}->{helper}{bluetooth}));
			}
		}
	} 
  
 	elsif($msgtype eq "getdnd") {
		foreach my $device (@{$json->{doNotDisturbDeviceStatusList}}) {
			if(defined($modules{$hash->{TYPE}}{defptr}{$device->{deviceSerialNumber}})) {
				next if (echodevice_getModel($device->{deviceType}) eq "Reverb");
				next if (echodevice_getModel($device->{deviceType}) eq "Echo Multiroom");
				next if (echodevice_getModel($device->{deviceType}) eq "Sonos Display");
				next if (echodevice_getModel($device->{deviceType}) eq "Sonos One");
				next if (echodevice_getModel($device->{deviceType}) eq "unbekannt");
				my $echohash = $modules{$hash->{TYPE}}{defptr}{$device->{deviceSerialNumber}};
				readingsBeginUpdate($echohash);
				readingsBulkUpdateIfChanged($echohash, "dnd", $device->{enabled}?"on":"off", 1);
				readingsEndUpdate($echohash,1);
			}
		}
	} 
	
	elsif($msgtype eq "alarmvolume") {
		foreach my $device (@{$json->{deviceNotificationStates}}) {
			if(defined($modules{$hash->{TYPE}}{defptr}{$device->{deviceSerialNumber}})) {
				next if (echodevice_getModel($device->{deviceType}) eq "Reverb");
				next if (echodevice_getModel($device->{deviceType}) eq "Echo Multiroom");
				next if (echodevice_getModel($device->{deviceType}) eq "Sonos Display");
				next if (echodevice_getModel($device->{deviceType}) eq "unbekannt");
				my $echohash = $modules{$hash->{TYPE}}{defptr}{$device->{deviceSerialNumber}};
				readingsBeginUpdate($echohash);
				readingsBulkUpdateIfChanged($echohash, "volume_alarm", $device->{volumeLevel}, 1)if(defined($device->{volumeLevel}));
				readingsEndUpdate($echohash,1);
			}
		}
	} 
	
	elsif($msgtype eq "dndset") {
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "dnd", $json->{enabled}?"on":"off", 1) if(defined($json->{enabled}));
		readingsEndUpdate($hash,1);
	} 
  
	elsif($msgtype eq "tunein") {
	}

	elsif($msgtype eq "ttstunein") {
		InternalTimer(gettimeofday() + $hash->{helper}{lasttuneindelay}  , "echodevice_StartLastMedia" , $hash, 0);
		Log3 $name, 4, "[$name] [echodevice_ParseTTSMP3] Setze echodevice_StartLastMedia Timer in " . $hash->{helper}{lasttuneindelay} . " Sekunden.";
	
	}
	
	elsif($msgtype eq "tts_translate") {
	
		my $TTS_Translate_Result     = "ERROR no result!!!!";
		my $TTS_Translate_ResultTags = "";
		
		if (defined($json->{d})) {
			if (defined($json->{d}{result})) {
				$TTS_Translate_Result = $json->{d}{result};
			}
			
			if (defined($json->{d}{resultNoTags})) {
				$TTS_Translate_ResultTags = $json->{d}{resultNoTags};
			}
		}
		
		# Prüfen ob Text erkannt wurde
		if (index($TTS_Translate_Result,'<div') >=0 && $TTS_Translate_ResultTags ne "" ) {
			# Kein Text erkannt!
			my @TTS_ResultArray = split("\n",$TTS_Translate_ResultTags);
			$TTS_Translate_Result = substr($TTS_ResultArray[1], 5,index($TTS_ResultArray[1],",")-5 );
		}

		# Verzeichnis anlegen
		my $filedir = "cache";
		mkdir($filedir, 0777) unless(-d $filedir );
		
		# Text in Datei zwischenspeichern
		open(FH, ">$filedir/$name.html");
		print FH $TTS_Translate_Result;
		close(FH);
		
		# Reading aktualisieren.
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "tts_translate_result",$TTS_Translate_Result , 1);
		readingsEndUpdate($hash,1);	

		# Datei wieder auslesen
		open FILE, "$filedir/$name.html" or do {
			return;
		};
		chomp(my $TTS_Translate_Result = <FILE>);
		close FILE;

		# TTS Nachricht abspielen
		if ($TTS_Translate_Result ne "ERROR no result!!!!") {
			echodevice_Amazon($hash,$TTS_Translate_Result,$msgtype);
			
		}

	}
	
	elsif($msgtype eq "wakeword") {
		foreach my $device (@{$json->{wakeWords}}) {
			if(defined($modules{$hash->{TYPE}}{defptr}{$device->{deviceSerialNumber}})) {
				my $echohash = $modules{$hash->{TYPE}}{defptr}{$device->{deviceSerialNumber}};
				readingsBeginUpdate($echohash);
				#readingsBulkUpdateIfChanged($echohash, "active", $device->{active}?"true":"false", 1) if(defined($device->{active}));
				readingsBulkUpdateIfChanged($echohash, "wakeword", $device->{wakeWord}, 1) if(defined($device->{wakeWord}));
				#readingsBulkUpdateIfChanged($echohash, "midfield", $device->{midFieldState}, 1) if(defined($device->{midFieldState}));
				readingsEndUpdate($echohash,1);
			}
		}
	}
	
	elsif($msgtype eq "getdevicesettings") {
		foreach my $device (@{$json->{devicePreferences}}) {
			if(defined($modules{$hash->{TYPE}}{defptr}{$device->{deviceSerialNumber}})) {
				my $echohash = $modules{$hash->{TYPE}}{defptr}{$device->{deviceSerialNumber}};
				next if (echodevice_getModel($device->{deviceType}) eq "Echo Multiroom");
				next if (echodevice_getModel($device->{deviceType}) eq "unbekannt");
				readingsBeginUpdate($echohash);
				readingsBulkUpdateIfChanged($echohash, "microphone", $device->{notificationEarconEnabled}?"false":"true", 1) if(defined($device->{notificationEarconEnabled}));
				readingsBulkUpdateIfChanged($echohash, "deviceAddress", $device->{deviceAddress}, 1) if(defined($device->{deviceAddress}));
				readingsBulkUpdateIfChanged($echohash, "timeZoneId", $device->{timeZoneId}, 1) if(defined($device->{timeZoneId}));
				readingsEndUpdate($echohash,1);
			}
		}
	}

	elsif($msgtype eq "getisonline") {
		foreach my $device (@{$json->{devices}}) {
			if(defined($modules{$hash->{TYPE}}{defptr}{$device->{serialNumber}})) {
				my $echohash = $modules{$hash->{TYPE}}{defptr}{$device->{serialNumber}};
				next if (echodevice_getModel($device->{deviceType}) eq "Echo Multiroom");
				next if (echodevice_getModel($device->{deviceType}) eq "Sonos Display");
				next if (echodevice_getModel($device->{deviceType}) eq "unbekannt");
				readingsBeginUpdate($echohash);
				readingsBulkUpdateIfChanged($echohash, "online", $device->{online}?"true":"false", 1) if(defined($device->{online}));
				readingsEndUpdate($echohash,1);
			}
		}
	}

	elsif($msgtype eq "conversations") {
	
		my $return = '<html><table align="" border="0" cellspacing="0" cellpadding="3" width="100%" height="100%" class="mceEditable"><tbody>';
		$return   .= "<p>Conversations:</p>";
		$return   .= "<tr><td><strong>ID</strong></td><td><strong>Date</strong></td><td><strong>Message</strong></td></tr>";
		my $conversations_date = "";
		my $conversations_msg  = "";
		
		if(!defined($json->{conversations})) {}
		elsif(ref($json->{conversations}) ne "ARRAY") {}
		else{
			foreach my $conversation (@{$json->{conversations}}) {
				if(defined($conversation->{lastMessage}{payload}{text})){
				  $conversations_date = $conversation->{lastMessage}{time};
				  $conversations_msg  = substr($conversation->{lastMessage}{payload}{text},0,32);
				} else {
				  $conversations_msg  = "no previous messages";
				  $conversations_date = "no date";
				}
				$return .= "<tr><td>".$conversation->{conversationId}."&nbsp;&nbsp;&nbsp;</td><td>".$conversations_date."&nbsp;&nbsp;&nbsp;</td><td>".$conversations_msg."&nbsp;&nbsp;&nbsp;</td></tr>";
			}

		}
		$return .= "</tbody></table></html>";
		asyncOutput( $param->{CL}, $return );
	}
	
	elsif($msgtype eq "devices" || $msgtype eq "autocreate_devices") {
	
		my $autocreated   = 0;
		my $autocreate    = 0;
		my $isautocreated = 0;
		$autocreate=1 if($msgtype eq "autocreate_devices");

		my $return = '<html><table align="" border="0" cellspacing="0" cellpadding="3" width="100%" height="100%" class="mceEditable"><tbody>';
		$return .= "<p>Devices:</p>";
		$return .= "<tr><td><strong>Serial</strong></td><td><strong>Family</strong></td><td><strong>Devicetype</strong></td><td><strong>Name</strong></td></tr>";
		
		if(!defined($json->{devices})) {}
		elsif (ref($json->{devices}) ne "ARRAY") {}
		else {
			foreach my $device (@{$json->{devices}}) {
				next if($device->{deviceFamily} eq "UNKNOWN");
				next if($device->{deviceFamily} eq "FIRE_TV");
				next if($device->{deviceFamily} =~ /AMAZON/);
				$isautocreated = 0;
				if($autocreate && ($device->{deviceFamily} eq "ECHO" || $device->{deviceFamily} eq "KNIGHT" || $device->{deviceFamily} eq "THIRD_PARTY_AVS_MEDIA_DISPLAY"  || $device->{deviceFamily} eq "WHA" || $device->{deviceFamily} eq "ROOK" )) {
					if( defined($modules{$hash->{TYPE}}{defptr}{"$device->{serialNumber}"}) ) {
						Log3 $name, 4, "$name: device '$device->{serialNumber}' already defined";
						if (AttrVal($name, "autocreate_refresh", 0) == 1) {
							my $devicehash = $modules{$hash->{TYPE}}{defptr}{"$device->{serialNumber}"};
							print (fhem( "attr " . $devicehash->{NAME} ." alias " .$device->{accountName}  )) if( defined($device->{accountName}) );
							print (fhem( "attr " . $devicehash->{NAME} ." icon echo"  ))if (-e "././www/images/fhemSVG/echo.svg");
						}
					}
					else {
						$isautocreated = 1;
						my $devname = "ECHO_".$device->{serialNumber};
						my $define= "$devname echodevice ".$device->{deviceType}." ".$device->{serialNumber};

						Log3 $name, 3, "[$name] create new device '$devname'";
						my $cmdret= CommandDefine(undef,$define);
						if($cmdret) {
							Log3 $name, 1, "[$name] Autocreate: An error occurred while creating device for serial '$device->{serialNumber}': $cmdret";
						} 
						else {
							$cmdret= CommandAttr(undef,"$devname alias ".$device->{accountName}) if( defined($device->{accountName}) );
							$cmdret= CommandAttr(undef,"$devname icon echo" )if (-e "././www/images/fhemSVG/echo.svg");
							$cmdret= CommandAttr(undef,"$devname IODev $name");
							$cmdret= CommandAttr(undef,"$devname room Amazon");
							$autocreated++;
						}
					  
						$hash->{helper}{VERSION} = $device->{softwareVersion} if(!defined($hash->{helper}{VERSION}));
						$hash->{helper}{".CUSTOMER"} = $device->{deviceOwnerCustomerId} if(!defined($hash->{helper}{".CUSTOMER"}));
						$hash->{helper}{".SERIAL"} = $device->{serialNumber} if(!defined($hash->{helper}{".SERIAL"}));
						$hash->{helper}{DEVICETYPE} = $device->{deviceType} if(!defined($hash->{helper}{DEVICETYPE}));
					}

				}
				elsif($device->{deviceFamily} eq "ECHO") {
					$hash->{helper}{VERSION} = $device->{softwareVersion} if(!defined($hash->{helper}{VERSION}));
					$hash->{helper}{".CUSTOMER"} = $device->{deviceOwnerCustomerId} if(!defined($hash->{helper}{".CUSTOMER"}));
					$hash->{helper}{".SERIAL"} = $device->{serialNumber} if(!defined($hash->{helper}{".SERIAL"}));
					$hash->{helper}{DEVICETYPE} = $device->{deviceType} if(!defined($hash->{helper}{DEVICETYPE}));
					if( defined($modules{$hash->{TYPE}}{defptr}{"$device->{serialNumber}"}) ) {
						my $devicehash = $modules{$hash->{TYPE}}{defptr}{"$device->{serialNumber}"};
					}
				}
				if ($isautocreated == 0) {
					$return .= "<tr><td>".$device->{serialNumber}."&nbsp;&nbsp;&nbsp;</td><td>".$device->{deviceFamily}."&nbsp;&nbsp;&nbsp;</td><td>".$device->{deviceType}."&nbsp;&nbsp;&nbsp;</td><td>".$device->{accountName}."&nbsp;&nbsp;&nbsp;</td></tr>";
				}
				else {
					$return .= "<tr><td><strong>*".$device->{serialNumber}."&nbsp;&nbsp;&nbsp;</strong></td><td><strong>".$device->{deviceFamily}."&nbsp;&nbsp;&nbsp;</strong></td><td><strong>".$device->{deviceType}."&nbsp;&nbsp;&nbsp;</strong></td><td><strong>".$device->{accountName}."&nbsp;&nbsp;&nbsp;</strong></td></tr>";
				}
				
			}
	
			foreach my $device (@{$json->{devices}}) {
				next if($device->{deviceFamily} ne "ECHO");
				my $devicehash = $modules{$hash->{TYPE}}{defptr}{"$device->{serialNumber}"};
				next if( !defined($devicehash) );
				
				
				$devicehash->{model} = echodevice_getModel($device->{deviceType});#$device->{deviceType};
				
				readingsBeginUpdate($devicehash);
				readingsBulkUpdateIfChanged($devicehash, "model", $devicehash->{model}, 1);
				readingsBulkUpdateIfChanged($devicehash, "presence", ($device->{online}?"present":"absent"), 1);
				readingsBulkUpdateIfChanged($devicehash, "state", "absent", 1) if(!$device->{online});
				readingsBulkUpdateIfChanged($devicehash, "version", $device->{softwareVersion}, 1);
				readingsEndUpdate($devicehash,1);
				
				$hash->{helper}{".SERIAL"} = $device->{serialNumber};
				$hash->{helper}{DEVICETYPE} = $device->{deviceType};
				$devicehash->{helper}{".SERIAL"} = $device->{serialNumber};
				$devicehash->{helper}{DEVICETYPE} = $device->{deviceType};
				$devicehash->{helper}{NAME} = $device->{accountName};
				$devicehash->{helper}{FAMILY} = $device->{deviceFamily};
				$devicehash->{helper}{VERSION} = $device->{softwareVersion};
				$devicehash->{helper}{".CUSTOMER"} = $device->{deviceOwnerCustomerId};

			}
			
			readingsSingleUpdate ($hash, "autocreate_devices", "found: ".$autocreated, 0 ) if($msgtype eq "autocreate_devices");
			
			$return .= "</tbody></table>";
			$return .= "<p><strong>* ".$autocreated." devices created</strong></p>" if($msgtype eq "autocreate_devices");
			$return .= "</html>";
		}
		
		$return =~ s/'/&#x0027/g;
		asyncOutput( $param->{CL}, $return );
	}
	
	elsif($msgtype eq "searchtunein") {
		my $tuneincount = 0;
	
		my $return = '<html><table align="" border="0" cellspacing="0" cellpadding="3" width="100%" height="100%" class="mceEditable"><tbody>';
		$return   .= "<p>TuneIn:</p>";
		$return   .= "<tr><td><strong>ID</strong></td><td><strong>Name</strong></td><td><strong>Start</strong></td></tr>";			
	
		if (!defined($json->{browseList})) {}
		elsif (ref($json->{browseList}) ne "ARRAY") {}
		else {
			# Play on Device
			foreach my $result (@{$json->{browseList}}) {
				next if(!$result->{available});
				next if($result->{contentType} ne "station");
				$tuneincount ++;
				$return .= "<tr><td>".$result->{id}."&nbsp;&nbsp;&nbsp;</td><td>".$result->{name}."&nbsp;&nbsp;&nbsp;</td><td><a href=" . '/fhem?cmd.Test=set%20' .$name .'%20tunein%20'.$result->{id}.'>play&nbsp;&nbsp;&nbsp;' . "</a></td></tr>";
			}
		}
		
		$return .= "</tbody></table>";
		$return .= "<p><strong>".$tuneincount. " tunein IDs found</strong></p>";
		$return .= "</html>";
		$return =~ s/'/&#x0027/g;
		
		asyncOutput( $param->{CL}, $return );
	}
	
	elsif($msgtype eq "searchtracks") {
			my $trackcount = 0;
			my $return     = '<html><table align="" border="0" cellspacing="0" cellpadding="3" width="100%" height="100%" class="mceEditable"><tbody>';
			my $tracktitle = "";
			$return .= "<p>Tracks:</p>";
			$return .= "<tr><td><strong>ID</strong></td><td><strong>Title</strong></td></tr>";
	
			if (!defined($json->{playlist}{entryList})) {}
			elsif (ref($json->{playlist}{entryList}) ne "ARRAY") {}
			else {
				foreach my $track (@{$json->{playlist}{entryList}}) {
					if(defined($track->{metadata}{title})){$tracktitle = $track->{metadata}{title};} 
					else {$tracktitle= "unknown title";}
					$trackcount ++;
					$return .= "<tr><td>".$track->{trackId}."&nbsp;&nbsp;&nbsp;</td><td>".$tracktitle."&nbsp;&nbsp;&nbsp;</td></tr>";
				}
			}
		
			$return .= "</tbody></table>";
			$return .= "<p><strong>".$trackcount." track IDs found</strong></p>";
			$return .= "</html>";
			$return =~ s/'/&#x0027/g;
			
			asyncOutput( $param->{CL}, $return );	
	}

	elsif($msgtype eq "primeplayeigene_Albums" || $msgtype eq "primeplayeigene_Tracks" || $msgtype eq "primeplayeigene_Artists" ) {
		my $querytype =  substr($msgtype,16);
		my $albumcount = 0;

		my $artistcolum  = "";
		$artistcolum     = "<td><strong>Title&nbsp;&nbsp;&nbsp</strong></td><td><strong>ID&nbsp;&nbsp;&nbsp</strong></td>" if ($msgtype eq "primeplayeigene_Tracks" ) ;
		
		my $return = '<html><table align="" border="0" cellspacing="0" cellpadding="3" width="100%" height="100%" class="mceEditable"><tbody>';
		$return   .= "<p>$querytype:</p>";
		$return   .= "<tr><td><strong>Artist&nbsp;&nbsp;&nbsp</strong></td><td><strong>Albumname&nbsp;&nbsp;&nbsp</strong></td>$artistcolum<td><strong>Tracks&nbsp;&nbsp;&nbsp</strong></td><td><strong>Start</strong></td></tr>";			
	
		if (!defined($json->{selectItemList})) {}
		elsif (ref($json->{selectItemList}) ne "ARRAY") {}
		else {
			# Play on Device
			foreach my $result (@{$json->{selectItemList}}) {
				#next if(!$result->{available});
				#next if($result->{contentType} ne "station");
				$albumcount ++;
				if ($msgtype eq "primeplayeigene_Tracks" ) {
					$return .= "<tr><td>".$result->{metadata}{albumArtistName}."&nbsp;&nbsp;&nbsp;</td><td>".$result->{metadata}{albumName}."&nbsp;&nbsp;&nbsp;</td><td>".$result->{metadata}{title}."&nbsp;&nbsp;&nbsp;</td><td>".$result->{metadata}{objectId}."&nbsp;&nbsp;&nbsp;</td><td>1&nbsp;&nbsp;&nbsp;</td><td><a href=" . '/fhem?cmd.Test=set%20' .$name .'%20track%20'.$result->{metadata}{objectId}.'>play&nbsp;&nbsp;&nbsp;' . "</a></td></tr>";
				}
				else {
					$return .= "<tr><td>".$result->{metadata}{albumArtistName}."&nbsp;&nbsp;&nbsp;</td><td>".$result->{metadata}{albumName}."&nbsp;&nbsp;&nbsp;</td><td>".$result->{numTracks}."&nbsp;&nbsp;&nbsp;</td><td><a href=" . '/fhem?cmd.Test=set%20' .$name .'%20primeplayeigene%20'.urlEncode($result->{metadata}{albumArtistName})."@".urlEncode($result->{metadata}{albumName}).'>play&nbsp;&nbsp;&nbsp;' . "</a></td></tr>";
				}
			}
		}
		
		$return .= "</tbody></table>";
		$return .= "<p><strong>".$albumcount. " ". lc($querytype) ." IDs found</strong></p>";
		$return .= "</html>";
		$return =~ s/'/&#x0027/g;

		asyncOutput( $param->{CL}, $return );	
	}

	elsif($msgtype eq "getprimeplayeigeneplaylist" ) {

		my $playlistcount = 0;
		
		my $return = '<html><table align="" border="0" cellspacing="0" cellpadding="3" width="100%" height="100%" class="mceEditable"><tbody>';
		$return   .= "<p>Playlists:</p>";
		$return   .= "<tr><td><strong>Name&nbsp;&nbsp;&nbsp</strong></td><td><strong>ID&nbsp;&nbsp;&nbsp</strong></td><td><strong>Tracks&nbsp;&nbsp;&nbsp</strong></td><td><strong>Start</strong></td></tr>";			
		if (!defined($json->{playlists})) {}
		elsif (ref($json->{playlists}) ne "HASH") {}
		else {
			foreach my $result (sort keys %{$json->{playlists}}) {
				$playlistcount ++;
				$return .= "<tr><td>".$result."&nbsp;&nbsp;&nbsp;</td><td>".$json->{playlists}{"$result"}[0]{playlistId}."&nbsp;&nbsp;&nbsp;</td><td>".$json->{playlists}{"$result"}[0]{trackCount}."&nbsp;&nbsp;&nbsp;</td><td><a href=" . '/fhem?cmd.Test=set%20' .$name .'%20primeplayeigeneplaylist%20'.$json->{playlists}{"$result"}[0]{playlistId}.'>play&nbsp;&nbsp;&nbsp;' . "</a></td></tr>";
			}
		}
		
		$return .= "</tbody></table>";
		$return .= "<p><strong>".$playlistcount. " playlist IDs found</strong></p>";
		$return .= "</html>";
		$return =~ s/'/&#x0027/g;

		asyncOutput( $param->{CL}, $return );	
	}
	
	elsif($msgtype eq "getcards") {

			my $return     = '<html><table align="" border="0" cellspacing="0" cellpadding="3" width="100%" height="100%" class="mceEditable"><tbody>';

			$return .= "<p>Actions:</p>";
			$return .= "<tr><td><strong>Title</strong></td><td><strong>Subtitle</strong></td><td><strong>Voice</strong></td><td><strong>Device</strong></td></tr>";
	
			if (!defined($json->{cards})) {}
			elsif (ref($json->{cards}) ne "ARRAY") {}
			else {
				foreach my $cards (@{$json->{cards}}) {
					my $devicehash = $modules{$hash->{TYPE}}{defptr}{"$cards->{sourceDevice}{serialNumber}"};
					my $devicename = $devicehash->{NAME};
					my $VoiceText  = $cards->{playbackAudioAction}{mainText};
					$VoiceText = "No voice command detected. Action was started by the Alexa app." if ($VoiceText eq "");
					
					if (AttrVal( $devicename, "alias", "none" ) ne "none") {$devicename = AttrVal( $devicename, "alias", "none" );}

					$return .= "<tr><td>".$cards->{title}."&nbsp;&nbsp;&nbsp;</td><td>".$cards->{subtitle}."&nbsp;&nbsp;&nbsp;</td><td>".$VoiceText."&nbsp;&nbsp;&nbsp;</td><td>".$devicename."&nbsp;&nbsp;&nbsp;</td></tr>";
				}
			}
		
			$return .= "</tbody></table>";
			$return .= "</html>";
			$return =~ s/'/&#x0027/g;
			
			asyncOutput( $param->{CL}, $return );	
	}
	
	else {
		Log3 $name, 4, "[$name] [echodevice_Parse] [$msgtype] json for unknown message \n".Dumper(echodevice_anonymize($hash, $json));
	}
  
	echodevice_HandleCmdQueue($hash);

	return undef;
}

##########################
sub echodevice_GetSettings($) {

	my ($hash)       = @_;
	my $name         = $hash->{NAME};
	my $nextupdate   = int(AttrVal($name,"intervalsettings",60));
	my $ConnectState = "";
	
	return if($hash->{model} eq "unbekannt");

	# ECHO Device disable
	if (AttrVal($name,"disable",0) == 1) {
		RemoveInternalTimer($hash, "echodevice_GetSettings");
		InternalTimer(gettimeofday() + $nextupdate, "echodevice_GetSettings", $hash, 0);
		return;
	}
	
	# ECHO am Account registrierern
	if($hash->{model} ne "ACCOUNT") {
		$hash->{IODev}->{helper}{"DEVICETYPE"} = $hash->{helper}{"DEVICETYPE"} ;
		$hash->{IODev}->{helper}{".SERIAL"}    = $hash->{helper}{".SERIAL"};
		$hash->{IODev}->{helper}{"VERSION"}    = $hash->{helper}{"VERSION"};		
	}

	if($hash->{model} eq "ACCOUNT") {$ConnectState = $hash->{STATE}} else {$ConnectState = $hash->{IODev}->{STATE}}
	
	Log3 $name, 5, "[$name] [echodevice_GetSettings] ping!"  ;
	
	if ($ConnectState eq "connected") {

		if($hash->{model} eq "ACCOUNT") {
			echodevice_SendCommand($hash,"getnotifications","");
			echodevice_SendCommand($hash,"alarmvolume","");
			echodevice_SendCommand($hash,"bluetoothstate","");
			echodevice_SendCommand($hash,"getdnd","");
			echodevice_SendCommand($hash,"wakeword","");
			echodevice_SendCommand($hash,"listitems_task","TASK");
			echodevice_SendCommand($hash,"listitems_shopping","SHOPPING_ITEM");
			echodevice_SendCommand($hash,"getdevicesettings","");
			echodevice_SendCommand($hash,"getisonline","");
			echodevice_SendCommand($hash,"account","");
			echodevice_SendCommand($hash,"activities","");
		}
		else {
		
			if ($hash->{model} eq "Reverb" || $hash->{model} eq "Sonos One") {
				if ($hash->{IODev}{STATE} eq "connected") {
					readingsBeginUpdate($hash);
					readingsBulkUpdateIfChanged($hash, "state", $hash->{IODev}{STATE}, 1);
					readingsEndUpdate($hash,1);
				}
				else {$nextupdate = 10;}
			}
			else
			{
				if (ReadingsVal($name, "playStatus", "off") ne "paused") {
					my $CalcInterval = int(ReadingsVal($name, "progresslen", 0)) - (int(ReadingsVal($name, "progress", 0)) + $nextupdate);
					if ($CalcInterval < 0) {}
					elsif ($CalcInterval < ($nextupdate -1) ){$nextupdate = $CalcInterval + 4;}
						
					Log3( $name, 4, "[$name] [echodevice_GetSettings] Timer CNTERVAL = " . $CalcInterval);			
				}
				if ($hash->{IODev}{STATE} eq "connected") {
					echodevice_SendCommand($hash,"player","");
					echodevice_SendCommand($hash,"media","");
				}
				else {
					$nextupdate = 10;
				}
			}
			
			# Readings löschen
			readingsDelete($hash, "COOKIE_STATE") ;
			readingsDelete($hash, "COOKIE_TYPE") ;
			readingsDelete($hash, "2FACode") ;
			readingsDelete($hash, "BrowserUserAgent") ;
		}
	
		# Readings Bereinigung
		readingsDelete($hash, "active") if (ReadingsVal($name , "active", "none") ne "none");
		
		Log3( $name, 4, "[$name] [echodevice_GetSettings] Timer INTERVAL = " . $nextupdate);	
	}
	elsif ($hash->{model} eq "ACCOUNT" && $ConnectState eq "COOKIE ERROR") {
		Log3 $name, 3, "[$name] [echodevice_GetSettings] COOKIE ERROR / Generate new COOKIE!" ;
		echodevice_SendLoginCommand($hash,"cookielogin1","");
	}
	elsif ($hash->{model} eq "ACCOUNT" && $ConnectState eq "LOGIN ERROR") {
		Log3 $name, 3, "[$name] [echodevice_GetSettings] LOGIN ERROR / Generate new COOKIE!" ;
		echodevice_SendLoginCommand($hash,"cookielogin1","");
	}
	elsif ($hash->{model} eq "ACCOUNT" && $ConnectState eq "connection error") {
		Log3 $name, 3, "[$name] [echodevice_GetSettings] LOGIN ERROR / Generate new COOKIE!" ;
		echodevice_SendLoginCommand($hash,"cookielogin1","");
	}
	elsif ($hash->{model} eq "ACCOUNT" && $ConnectState eq "disconnected") {
		Log3 $name, 3, "[$name] [echodevice_GetSettings] disconnected / Generate new COOKIE!" ;
		echodevice_SendLoginCommand($hash,"cookielogin1","");
	}
	else {
		Log3 $name, 5, "[$name] [echodevice_GetSettings] unknown stat / ConnectState=$ConnectState" ;
	}
	
	RemoveInternalTimer($hash, "echodevice_GetSettings");
	InternalTimer(gettimeofday() + $nextupdate, "echodevice_GetSettings", $hash, 0);
	return;
}

##########################
sub echodevice_FirstStart($) {

	my ($hash) = @_;
	my $name = $hash->{NAME};
	my $CookieDevice = "";
	
	readingsSingleUpdate ($hash, "version", $ModulVersion ,0);
	readingsSingleUpdate ($hash, "autocreate_devices", "stop", 0 );
	
	if(AttrVal( $name, "cookie", "none" ) ne "none") {
		readingsSingleUpdate ($hash, "COOKIE_TYPE", "ATTRIBUTE" ,0);
		$hash->{helper}{".COOKIE"} = AttrVal( $name, "cookie", "none" );
		$hash->{helper}{".COOKIE"} =~ s/Cookie: //g;
		$hash->{helper}{".COOKIE"} =~ /csrf=([-\w]+)[;\s]?(.*)?$/;
		$hash->{helper}{".CSRF"} = $1;
		readingsSingleUpdate ($hash, ".COOKIE", $hash->{helper}{".COOKIE"} ,0); # Cookie als READING festhalten!
    }
	elsif (ReadingsVal( $name, ".COOKIE", "none" ) ne "none") {
		readingsSingleUpdate ($hash, "COOKIE_TYPE", "READING" ,0);
		$hash->{helper}{".COOKIE"} = ReadingsVal( $name, ".COOKIE", "none" );
		$hash->{helper}{".COOKIE"} =~ s/Cookie: //g;
		$hash->{helper}{".COOKIE"} =~ /csrf=([-\w]+)[;\s]?(.*)?$/;
		$hash->{helper}{".CSRF"} = $1;
	}
	else {
		readingsSingleUpdate ($hash, "COOKIE_TYPE", "NEW" ,0);
	}

	Log3 $name, 4, "[$name] COOKIE      = " . $hash->{helper}{".COOKIE"};
	Log3 $name, 4, "[$name] COOKIE_TYPE = " . ReadingsVal( $name, "COOKIE_TYPE", "none" );
	
    $hash->{STATE} = "INITIALIZED";
    echodevice_CheckAuth($hash);
	
	if(defined($hash->{helper}{".COOKIE"})) {
		echodevice_SendCommand($hash,"devices","");
		echodevice_SendCommand($hash,"account","");
	}

	# Alte Readingsbereinigen
	readingsDelete($hash, "COOKIE");
	
	# Migration aws_secret_key  & aws_access_key
	if (ReadingsVal($name , "aws_access_key", "none") ne "none") {
		readingsSingleUpdate ($hash, ".aws_access_key", ReadingsVal($name , lc("AWS_Access_Key"), "none") ,0);
		readingsDelete($hash, "aws_access_key");
	}
	if (ReadingsVal($name , lc("aws_secret_key"), "none") ne "none") {
		readingsSingleUpdate ($hash, ".aws_secret_key", ReadingsVal($name , lc("aws_secret_key"), "none") ,0);
		readingsDelete($hash, "aws_secret_key");
	}
	
}

sub echodevice_LoginStart($) {

	my ($hash) = @_;
	my $name = $hash->{NAME};
	Log3 $name, 4, "[$name] [echodevice_LoginStart] start....";

	$hash->{helper}{RUNLOGIN} = 0;
	echodevice_SendLoginCommand($hash,"cookielogin1","") if(!defined($attr{$name}{cookie}));
}

sub echodevice_CheckAuth($) {
	my ($hash) = @_;
	my $name = $hash->{NAME};
	return undef if($hash->{model} ne "ACCOUNT");
  
	# Erneut Login ausführen wenn Cookie nicht gesetzt wurde!
	if(!defined($hash->{helper}{".COOKIE"})) {echodevice_SendLoginCommand($hash,"cookielogin1","");}
	else {echodevice_SendLoginCommand($hash,"cookielogin6","");}

	return undef;
}

sub echodevice_ParseAuth($$$) {
	my ($param, $err, $data) = @_;
	my $hash = $param->{hash};
	my $name = $hash->{NAME};
	my $nextupdate = int(AttrVal($name,"intervallogin",60));

	if($err){
		echodevice_setState($hash,"connection error");
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "state", "connection error", 1);
		readingsEndUpdate($hash,1);
		if ($hash->{helper}{RUNLOGIN} == 0) {
			readingsSingleUpdate ($hash, "COOKIE_STATE", "ERROR" ,0);
			InternalTimer(gettimeofday() + $nextupdate  , "echodevice_LoginStart" , $hash, 0);
			$hash->{helper}{RUNLOGIN} = 1;
		}	
		Log3 $name, 4, "[$name] [echodevice_ParseAuth] connection error $err";
		return undef;
	}
  
	if($data =~ /cookie is missing/) {
		echodevice_setState($hash,"disconnected");
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "state", "disconnected", 1);
		readingsEndUpdate($hash,1);
		if ($hash->{helper}{RUNLOGIN} == 0) {
			readingsSingleUpdate ($hash, "COOKIE_STATE", "ERROR" ,0);
			InternalTimer(gettimeofday() + $nextupdate  , "echodevice_LoginStart" , $hash, 0);
			$hash->{helper}{RUNLOGIN} = 1;
		}	
		return undef;
	}
  
	my $json = eval { JSON->new->utf8(0)->decode($data) };
	if($@) {
		echodevice_setState($hash,"disconnected");
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "state", "disconnected", 1);
		readingsEndUpdate($hash,1);
		if ($hash->{helper}{RUNLOGIN} == 0) {
			readingsSingleUpdate ($hash, "COOKIE_STATE", "ERROR" ,0);
			InternalTimer(gettimeofday() + $nextupdate  , "echodevice_LoginStart" , $hash, 0);
			$hash->{helper}{RUNLOGIN} = 1;
		}
		return undef;
	}
  
	Log3 $name, 4, "[$name] [echodevice_ParseAuth] DATA=$data";

	if($json->{authentication}{authenticated}){
		echodevice_setState($hash,"connected");
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "state", "connected", 1);
		readingsBulkUpdateIfChanged($hash, "COOKIE_STATE", "OK", 1);
		readingsEndUpdate($hash,1);
		$hash->{helper}{".CUSTOMER"} = $json->{authentication}{customerId};
	} 
	
	elsif($json->{authentication}) {
		echodevice_setState($hash,"disconnected");
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "state", "disconnected", 1);
		readingsEndUpdate($hash,1);
		
		if ($hash->{helper}{RUNLOGIN} == 0) {
			readingsSingleUpdate ($hash, "COOKIE_STATE", "ERROR" ,0);
			InternalTimer(gettimeofday() + $nextupdate  , "echodevice_LoginStart" , $hash, 0);
			$hash->{helper}{RUNLOGIN} = 1;
		}
		
		
	}
	return undef;
}

##########################
sub echodevice_getModel($){
	my ($ModelNumber) = @_;
	
	if   ($ModelNumber eq "AB72C64C86AW2"  || $ModelNumber eq "Echo")          {return "Echo";}
	elsif($ModelNumber eq "A3S5BH2HU6VAYF" || $ModelNumber eq "Echo Dot")      {return "Echo Dot";}
	elsif($ModelNumber eq "A10A33FOX2NUBK" || $ModelNumber eq "Echo Spot")     {return "Echo Spot";}
	elsif($ModelNumber eq "A1NL4BVLQ4L3N3" || $ModelNumber eq "Echo Show")     {return "Echo Show";}
	elsif($ModelNumber eq "A2M35JJZWCQOMZ" || $ModelNumber eq "Echo Plus")     {return "Echo Plus";}
	elsif($ModelNumber eq "AILBSA2LNTOYL"  || $ModelNumber eq "Reverb")        {return "Reverb";}
	elsif($ModelNumber eq "A15ERDAKK5HQQG" || $ModelNumber eq "Sonos Display") {return "Sonos Display";}
	elsif($ModelNumber eq "A2OSP3UA4VC85F" || $ModelNumber eq "Sonos One")     {return "Sonos One";}
	elsif($ModelNumber eq "A7WXQPH584YP"   || $ModelNumber eq "Echo Gen2")     {return "Echo Gen2";}
	elsif($ModelNumber eq "A3C9PE6TNYLTCH" || $ModelNumber eq "Echo Multiroom"){return "Echo Multiroom";}
	elsif($ModelNumber eq "")               {return "";}
	elsif($ModelNumber eq "ACCOUNT")        {return "ACCOUNT";}
	else {return "unbekannt";}

}

sub echodevice_Attr($$$) {
  
	my ($cmd, $name, $attrName, $attrVal) = @_;
	my $hash = $defs{$name};

	if( $attrName eq "cookie" ) {
		#my $hash = $defs{$name};
		if( $cmd eq "set" ) {
			$attrVal =~ s/Cookie: //g;
			$hash->{helper}{".COOKIE"} = $attrVal;
			$hash->{helper}{".COOKIE"} =~ /csrf=([-\w]+)[;\s]?(.*)?$/;
			$hash->{helper}{".CSRF"} = $1;
			$hash->{STATE} = "INITIALIZED";
		}
	}
	
	if ( $attrName eq "server" ) {
		#my $hash = $defs{$name};
		if( $cmd eq "set" ) {
		  $hash->{helper}{SERVER} = $attrVal;
		}
	}
	
	$attr{$name}{$attrName} = $attrVal;
	
	return;  
}

sub echodevice_anonymize($$) {
	my ($hash, $string) = @_;
	my $s1 = $hash->{helper}{".SERIAL"};
	my $s2 = $hash->{helper}{".CUSTOMER"};
	my $s3 = $hash->{helper}{HOMEGROUP};
	my $s4 = $hash->{helper}{".COMMSID"};
	my $s5;
	$s5 = echodevice_decrypt($hash->{helper}{".USER"}) if(defined($hash->{helper}{".USER"}));
	$s5 = echodevice_decrypt($hash->{IODev}->{helper}{".USER"}) if(defined($hash->{IODev}->{helper}{".USER"}));;
	$s1 = "SERIAL" if(!defined($s1));
	$s2 = "CUSTOMER" if(!defined($s2));
	$s3 = "HOMEGROUP" if(!defined($s3));
	$s4 = "COMMSID" if(!defined($s4));
	$s5 = "USER" if(!defined($s5));
	$string =~ s/$s1/SERIAL/g;
	$string =~ s/$s2/CUSTOMER/g;
	$string =~ s/$s3/HOMEGROUP/g;
	$string =~ s/$s4/COMMSID/g;
	$string =~ s/$s5/USER/g;
	return $string;
}

sub echodevice_encrypt($) {
  my ($decoded) = @_;
  my $key = getUniqueId();
  my $encoded;

  return $decoded if( $decoded =~ /\Qcrypt:\E/ );

  for my $char (split //, $decoded) {
    my $encode = chop($key);
    $encoded .= sprintf("%.2x",ord($char)^ord($encode));
    $key = $encode.$key;
  }

  return 'crypt:'.$encoded;
}

sub echodevice_decrypt($) {
  my ($encoded) = @_;
  my $key = getUniqueId();
  my $decoded;

  return $encoded if( $encoded !~ /crypt:/ );
  
  $encoded = $1 if( $encoded =~ /crypt:(.*)/ );

  for my $char (map { pack('C', hex($_)) } ($encoded =~ /(..)/g)) {
    my $decode = chop($key);
    $decoded .= chr(ord($char)^ord($decode));
    $key = $decode.$key;
  }

  return $decoded;
}

sub echodevice_setState($$) {
	my ($hash,$State) = @_;
	my $name = $hash->{NAME};
	
	Log3 $name, 3, "[$name] [echodevice_setState] to $State"  if($hash->{STATE} ne $State) ;
	
	foreach my $DeviceID (sort keys %{$modules{$hash->{TYPE}}{defptr}}) {
		my $echohash   = $modules{$hash->{TYPE}}{defptr}{$DeviceID};
		readingsBeginUpdate($echohash);
		readingsBulkUpdateIfChanged( $echohash, "state"  , $State,1);		
		readingsEndUpdate($echohash,1);
	}
	return;
}

##########################
# TTS/POM
sub echodevice_AWSPython($$) {
	my ($hash,$Skriptfile) = @_;
	my $name = $hash->{NAME};

	#Verzeichnis anlegen
	my $filedir ="cache";
	mkdir($filedir, 0777) unless(-d $filedir );
	
	my $filename  = $filedir ."/". $Skriptfile;
	
	# Prüfen ob die Datei erstezt werden muss
	if ($AWSPythonVersion eq ReadingsVal($hash->{IODev}->{NAME} , lc("AWS_PythonVersion"), "0") && (-e $filename)) {
		Log3 "echodevice", 4, "[$name] [echodevice_AWSPython] file $filename exist";
		return;
	}

	Log3 "echodevice", 3, "[$name] [echodevice_AWSPython] file $filename not exist or to old";
	
	readingsBeginUpdate($hash->{IODev});
	readingsBulkUpdateIfChanged($hash->{IODev}, lc("AWS_PythonVersion"), $AWSPythonVersion, 1);
	readingsEndUpdate($hash->{IODev},1);
	
	#altes Skript löschen
	if ((-e $filename)) {unlink $filename};
	
	#Skript Inhalt
	my $SkriptContent = "# IAM API (CreateUser) adapted to Polly service\n";
	$SkriptContent .= "import sys, os, base64, datetime, hashlib, hmac, urllib\n";
	$SkriptContent .= "sys.path.append('../')\n";
	$SkriptContent .= "# Parameter\n";
	$SkriptContent .= "MessageText  = sys.argv[1]\n";
	$SkriptContent .= "MessageVoice = sys.argv[2]\n";
	$SkriptContent .= "access_key   = sys.argv[3]\n";
	$SkriptContent .= "secret_key   = sys.argv[4]\n";
	$SkriptContent .= "OutputFormat = sys.argv[7]\n";
	$SkriptContent .= "# DEFs\n";
	$SkriptContent .= "def sign(key, msg):\n";
	$SkriptContent .= "    return hmac.new(key, msg.encode('utf-8'), hashlib.sha256).digest()\n";
	$SkriptContent .= "\n";
	$SkriptContent .= "def getSignatureKey(key, dateStamp, regionName, serviceName):\n";
	$SkriptContent .= "    kDate = sign(('AWS4' + key).encode('utf-8'), dateStamp)\n";
	$SkriptContent .= "    kRegion = sign(kDate, regionName)\n";
	$SkriptContent .= "    kService = sign(kRegion, serviceName)\n";
	$SkriptContent .= "    kSigning = sign(kService, 'aws4_request')\n";
	$SkriptContent .= "    return kSigning\n";
	$SkriptContent .= "# ************* REQUEST VALUES *************\n";
	$SkriptContent .= "method       = 'POST'\n";
	$SkriptContent .= "service      = 'polly'\n";
	$SkriptContent .= "region       = 'eu-west-1'\n";
	$SkriptContent .= "host         = service+'.'+region+'.amazonaws.com'\n";
	$SkriptContent .= "api          = '/v1/speech'\n";
	$SkriptContent .= "endpoint     = 'https://'+host+api\n";
	$SkriptContent .= "content_type = 'application/json'\n";
	$SkriptContent .= "# ************* REQUEST CONTENT ************\n";
	$SkriptContent .= "request_parameters = '{'\n";
	$SkriptContent .= "request_parameters +=  '" . '"' . "OutputFormat" . '"' . ": " . '"' . "' + OutputFormat + '" . '"' . ",'\n";
	$SkriptContent .= "request_parameters +=  '" . '"' . "Text"         . '"' . ": " . '"' . "' + MessageText  + '" . '"' . ",'\n";
	$SkriptContent .= "request_parameters +=  '" . '"' . "TextType"     . '"' . ": " . '"' . "text" . '"' . ",'\n";
	$SkriptContent .= "request_parameters +=  '" . '"' . "VoiceId"      . '"' . ": " . '"' . "' + MessageVoice + '" . '"' . "'\n";
	$SkriptContent .= "request_parameters +=  '}'\n";
	$SkriptContent .= "# Create a date for headers and the credential string\n";
	$SkriptContent .= "t = datetime.datetime.utcnow()\n";
	$SkriptContent .= "amz_date = t.strftime('%Y%m%dT%H%M%SZ')\n";
	$SkriptContent .= "date_stamp = t.strftime('%Y%m%d')\n";
	$SkriptContent .= "# ************* TASK 1: CREATE A CANONICAL REQUEST *************\n";
	$SkriptContent .= "canonical_uri = api\n";
	$SkriptContent .= "canonical_querystring = ''\n";
	$SkriptContent .= "canonical_headers = 'content-type:' + content_type + '\\n' + 'host:' + host + '\\n' + 'x-amz-date:' + amz_date + '\\n'\n";
	$SkriptContent .= "signed_headers = 'content-type;host;x-amz-date'\n";
	$SkriptContent .= "payload_hash = hashlib.sha256(request_parameters).hexdigest()\n";
	$SkriptContent .= "canonical_request = method + '\\n' + canonical_uri + '\\n' + canonical_querystring + '\\n' + canonical_headers + '\\n' + signed_headers + '\\n' + payload_hash\n";
	$SkriptContent .= "# ************* TASK 2: CREATE THE STRING TO SIGN*************\n";
	$SkriptContent .= "algorithm = 'AWS4-HMAC-SHA256'\n";
	$SkriptContent .= "credential_scope = date_stamp + '/' + region + '/' + service + '/' + 'aws4_request'\n";
	$SkriptContent .= "string_to_sign = algorithm + '\\n' +  amz_date + '\\n' +  credential_scope + '\\n' +  hashlib.sha256(canonical_request).hexdigest()\n";
	$SkriptContent .= "# ************* TASK 3: CALCULATE THE SIGNATURE *************\n";
	$SkriptContent .= "signing_key = getSignatureKey(secret_key, date_stamp, region, service)\n";
	$SkriptContent .= "signature = hmac.new(signing_key, (string_to_sign).encode('utf-8'), hashlib.sha256).hexdigest()\n";
	$SkriptContent .= "# ************* TASK 4: ADD SIGNING INFORMATION TO THE REQUEST *************\n";
	$SkriptContent .= "authorization_header = algorithm + ' ' + 'Credential=' + access_key + '/' + credential_scope + ', ' +  'SignedHeaders=' + signed_headers + ', ' + 'Signature=' + signature\n";
	$SkriptContent .= "# ************* TASK 5: ADD SIGNING INFORMATION TO FHEM *************\n";
	$SkriptContent .= "f=open(sys.argv[5],'wb')\n";
	$SkriptContent .= "f.write(amz_date)\n";
	$SkriptContent .= "f.close()\n";
	$SkriptContent .= "f=open(sys.argv[6],'wb')\n";
	$SkriptContent .= "f.write(authorization_header)\n";
	$SkriptContent .= "f.close()\n";

	open(FH, ">$filename");
	print FH $SkriptContent;
	close(FH);

}

sub echodevice_Amazon($$$) {
	my ($hash,$parameter,$type) = @_;
	my $name = $hash->{NAME};
	
	my $AWS_Access_Key = ReadingsVal($hash->{IODev}->{NAME} , lc(".AWS_Access_Key"), "none");
	my $AWS_Secret_Key = ReadingsVal($hash->{IODev}->{NAME} , lc(".AWS_Secret_Key"), "none");
		
	if ( $AWS_Access_Key eq "none" ) {
		readingsSingleUpdate( $hash, "tts_error", "No AWS_Access_Key Value",1 );
		return "No AWS_Access_Key Value" ;
	}
	if ( $AWS_Secret_Key eq "none" ){
		readingsSingleUpdate( $hash, "tts_error", "No AWS_Secret_Key Value",1 );
		return "No AWS_Secret_Key Value";
	}

	#Defaults
	my $TTS_Voice  = AttrVal($name,"TTS_Voice","German_Female_Marlene"); 
	my $AWS_Format = ReadingsVal($hash->{IODev}->{NAME} , lc("AWS_OutputFormat"), "mp3"); 
	my @VoiceName = split("_",$TTS_Voice);

	#Verzeichnis anlegen
	my $filedir = "cache";
	mkdir($filedir, 0777) unless(-d $filedir );
	
	#Temp Dateien
	my $AWS_File_AMZDate = $filedir . "/amzdate";
	my $AWS_File_Header  = $filedir . "/header";
	
	if ((-e "$AWS_File_AMZDate")) {unlink "$AWS_File_AMZDate"}	
	if ((-e "$AWS_File_Header"))  {unlink "$AWS_File_Header"}	
	
	# Länge der Nachricht prüfen. Bei kleiner 3 wird noch ein " ," angehängt!
	$parameter .= " ," if (length($parameter) < 3) ;
	
	# Python Skript ausführen
	echodevice_AWSPython($hash,"pollyspeech.py");
	my $ret = system('python ' . $filedir . '/pollyspeech.py "' . $parameter .'" ' . @VoiceName[2]  .' '. echodevice_decrypt($AWS_Access_Key) . " " . echodevice_decrypt($AWS_Secret_Key) . " " . $AWS_File_AMZDate . " " . $AWS_File_Header . " " . $AWS_Format);

	# Infos auswerten 
	my $AWSDate;
	open FILE, $AWS_File_AMZDate or do {
		Log3 $name, 3, "[$name] [echodevice_Amazon] Could not read from $AWS_File_AMZDate";
		readingsSingleUpdate( $hash, "tts_error", "Could not read from $AWS_File_AMZDate",1 );
		return;
	};
	chomp(my $AWSDate = <FILE>);
	close FILE;
		
	my $AWSHeader;
	open FILE, $AWS_File_Header or do {
		Log3 $name, 3, "[$name] [echodevice_Amazon] Could not read from $AWS_File_Header";
		readingsSingleUpdate( $hash, "tts_error", "Could not read from $AWS_File_Header",1 );
		return;
	};
	chomp(my $AWSHeader = <FILE>);
	close FILE;
	
	# MP3 Download starten
	my $params =  {
        url             => "https://polly.eu-west-1.amazonaws.com/v1/speech",
		header          => "Authorization: ".$AWSHeader."\r\nX-Amz-Date: ".$AWSDate."\r\nContent-Type: application/json",
		method          => "POST",
		data            => '{"OutputFormat": "' . $AWS_Format . '","Text": "' . $parameter .'","TextType": "text","VoiceId": "' . @VoiceName[2] . '"}',
        hash            => $hash,
		type            => $type,
        callback        => \&echodevice_ParseTTSMP3
    };
	
	HttpUtils_NonblockingGet($params);

}

sub echodevice_Google($$$) {
	my ($hash,$parameter,$type) = @_;
	my $name = $hash->{NAME};

	# ersetze Sonderzeichen die Google nicht auflösen kann
	my $MessageText = decode_utf8($parameter);
	$MessageText =~ s/ä/ae/g;
	$MessageText =~ s/ö/oe/g;
	$MessageText =~ s/ü/ue/g;
    $MessageText =~ s/Ä/Ae/g;
    $MessageText =~ s/Ö/Oe/g;
    $MessageText =~ s/Ü/Ue/g;
    $MessageText =~ s/ß/ss/g;	
	
	Log3 $name, 4, "[$name] [echodevice_ParseTTSMP3] TTS Message length=" . length($MessageText) ;
	
	if (length($MessageText) > 200) {
		Log3 $name, 3, "[$name] [echodevice_ParseTTSMP3] TTS Message to long!";
		readingsSingleUpdate( $hash, "tts_error", "TTS Message to long",1 );
		$MessageText = substr($MessageText,0,202)
	}
	
	# MP3 Download starten
	my $params =  {
        url             => "http://translate.google.com/translate_tts?tl=de&client=tw-ob&q=" . uri_escape($MessageText),
		method          => "GET",
        hash            => $hash,
		type            => $type,
        callback        => \&echodevice_ParseTTSMP3
    };

	HttpUtils_NonblockingGet($params);
}

sub echodevice_ParseTTSMP3($) {
	my ($param, $err, $data) = @_;
	my $hash = $param->{hash};
	my $name = $hash->{NAME};
	my $type = $param->{type};
	Log3 $name, 4, "[$name] [echodevice_ParseTTSMP3] [$type] URL      = " . $param->{url};
	Log3 $name, 4, "[$name] [echodevice_ParseTTSMP3] [$type] DATA     = " . $param->{data};
	Log3 $name, 5, "[$name] [echodevice_ParseTTSMP3] [$type] HEADER   = " . $param->{header};
	Log3 $name, 4, "[$name] [echodevice_ParseTTSMP3] [$type] ERROR    = " . $err if ($err);
	Log3 $name, 5, "[$name] [echodevice_ParseTTSMP3] [$type] DATA     = " . $data;

	#ReadingsVal($hash->{IODev}->{NAME} , lc("TTS_Filename"), "")
	my $MP3Filename = $name . ".mp3";
	my $M3UFilename = ReadingsVal($hash->{IODev}->{NAME} , lc("TTS_Filename"), "live18-hq.aac.m3u");
	
	Log3 $name, 4, "[$name] [echodevice_ParseTTSMP3] [$type] MP3File  = " . $MP3Filename;
	Log3 $name, 4, "[$name] [echodevice_ParseTTSMP3] [$type] M3UFile  = " . $M3UFilename;

	if ($data eq "") {
		Log3 $name, 3, "[$name] [echodevice_ParseTTSMP3] [$type] no data received";
		readingsSingleUpdate( $hash, "tts_error", "no data received",1 );
		return;
	}
	
	#Verzeichnis echodevice anlegen
	mkdir($FW_dir . "/echodevice", 0777) unless(-d $FW_dir . "/echodevice" );
	
	# MP3/M3U Datei löschen
	if ((-e $FW_dir . "/echodevice/". $MP3Filename)) {unlink $FW_dir . "/echodevice/". $MP3Filename}
	if ((-e $FW_dir . "/echodevice/". $M3UFilename)) {unlink $FW_dir . "/echodevice/".$M3UFilename}
	
	# MP3 Datei anlegen
	open(FH, ">$FW_dir/echodevice/$MP3Filename");
	print FH $data;
	close(FH);
	
	# MP3 TTS_normalize
	my $TTS_normalize_value = 200;
	$TTS_normalize_value = AttrVal($hash->{IODev}->{NAME}, "TTS_normalize", 100) if (AttrVal($hash->{IODev}->{NAME}, "TTS_normalize", 100) != 100 ) ;
	$TTS_normalize_value = AttrVal($name, "TTS_normalize", 100) if (AttrVal($name, "TTS_normalize", 100) != 100 ) ;

	if ($TTS_normalize_value != 200 ) {
		Log3 $name, 4, "[$name] [echodevice_ParseTTSMP3] [$type] MP3 dBFS = " . $TTS_normalize_value ;
		system("normalize-mp3 -a " . $TTS_normalize_value . "dBFS " . $FW_dir . "/echodevice/" . $MP3Filename . " > /dev/null 2>&1");
		if (!-e "/usr/bin/normalize-mp3") {Log3 $name, 3, "[$name] [echodevice_ParseTTSMP3] [$type] Missing /usr/bin/normalize-mp3";}
		if (!-e "/usr/bin/mpg123")        {Log3 $name, 3, "[$name] [echodevice_ParseTTSMP3] [$type] Missing /usr/bin/mpg123";}
		if (!-e "/usr/bin/lame")          {Log3 $name, 3, "[$name] [echodevice_ParseTTSMP3] [$type] Missing /usr/bin/lame";}

	}
		
	# M3U Datei erzeugen
	open(FH, ">$FW_dir/echodevice/$M3UFilename");
	print FH "http://" . ReadingsVal($hash->{IODev}->{NAME} , lc("TTS_IPAddress"), "live18-hq.aac.m3u") . "/" . $MP3Filename;
	close(FH);

	# Länge feststellen
	my $MP3_Info = get_mp3info("$FW_dir/echodevice/$MP3Filename");
	my $MP3_Time;
    if ($MP3_Info && defined($MP3_Info->{SECS})) {
		$MP3_Time = int($MP3_Info->{SECS}+1);
		readingsSingleUpdate( $hash, "tts_lenght", $MP3_Time ,1 );
		Log3 $name, 4, "[$name] [echodevice_ParseTTSMP3] [$type] MP3 len  = $MP3_Time Sekunden.";
    }

	$hash->{helper}{lasttuneindelay} = $MP3_Time;	
	$hash->{helper}{lastvolume}      = ReadingsVal($name , "volume", 50);
	$hash->{helper}{lasttuneinid}    = ReadingsVal($name , "currentTuneInID", "-");
	$hash->{helper}{lasttype}        = $type;
	
	if(ReadingsVal($name , "volume", 50) < ReadingsVal($name , "volume_alarm", 50)) {
		echodevice_SendMessage($hash,"pause","");	
		echodevice_SendMessage($hash,"volume",ReadingsVal($name , "volume_alarm", 50));	
		Log3 $name, 4, "[$name] [echodevice_ParseTTSMP3] [$type] set volume to " . ReadingsVal($name , "volume_alarm", 50);
	}

	InternalTimer(gettimeofday() + 1.5  , "echodevice_StartTTSMessage" , $hash, 0);
	Log3 $name, 4, "[$name] [echodevice_ParseTTSMP3] Setze echodevice_StartTTSMessage Timer";

}

sub echodevice_PlayOwnMP3($$) {
	my ($hash,$M3UContent) = @_;
	my $name = $hash->{NAME};

	Log3 $name, 4, "[$name] [echodevice_PlayOwnMP3] M3UContent = " . $M3UContent;

	#ReadingsVal($hash->{IODev}->{NAME} , lc("TTS_Filename"), "")
	my $M3UFilename = ReadingsVal($hash->{IODev}->{NAME} , lc("POM_Filename"), "stream.m3u");
	
	Log3 $name, 4, "[$name] [echodevice_PlayOwnMP3] M3UFile= " . $M3UFilename;

	if ($M3UContent eq "") {
		Log3 $name, 3, "[$name] [echodevice_PlayOwnMP3] no data received";
		return;
	}
	
	# M3U Datei löschen
	if ((-e $FW_dir . "/echodevice/". $M3UFilename)) {unlink $FW_dir . "/echodevice/".$M3UFilename}
	
	# Content zusammenbauen
	my $M3UContentWR;
	my @M3UConntentArray = split /\n+/, $M3UContent;
	foreach (@M3UConntentArray) { 
		if (lc(substr($_,0,4)) eq 'http') {
			$M3UContentWR .= $_ . "\n";
			Log3 $name, 4, "[$name] [echodevice_SaveOwnMP3] " . $_;
		}
	} 
	
	# M3U Datei erzeugen
	open(FH, ">$FW_dir/echodevice/$M3UFilename");
	print FH $M3UContentWR;
	close(FH);
		
	echodevice_SendCommand($hash,"tunein",ReadingsVal($hash->{IODev}->{NAME} , "POM_TuneIn", "s167655"));
}

sub echodevice_SaveOwnPlaylist($$) {
	my ($hash,$M3UContent) = @_;
	my $name = $hash->{NAME};
	my $M3UFilename;
	my $M3UContentWR;

	Log3 $name, 4, "[$name] [echodevice_SaveOwnMP3] M3UContent = " . $M3UContent;
	Log3 $name, 4, "[$name] [echodevice_SaveOwnMP3] M3UFile    = " . $M3UFilename;

	if ($M3UContent eq "") {
		Log3 $name, 3, "[$name] [echodevice_SaveOwnMP3] no content received";
		return;
	}

	# Playlist Name auslesen
	my @M3UConntentArray = split /\n+/, $M3UContent;
	$M3UFilename = @M3UConntentArray[0];
	
	# Div. Zeichen ersetzen
	$M3UFilename  =~ s/\s+/_/g;
	$M3UFilename  =~ s/\W/_/g;
	$M3UFilename .= ".m3u";
	
	Log3 $name, 4, "[$name] [echodevice_SaveOwnMP3] M3UFile    = " . $M3UFilename;
	
	# Content zusammenbauen
	foreach (@M3UConntentArray) { 
		if (lc(substr($_,0,4)) eq 'http') {
			$M3UContentWR .= $_ . "\n";
			Log3 $name, 4, "[$name] [echodevice_SaveOwnMP3] " . $_;
		}
	} 
	
	#Verzeichnis echodevice anlegen
	mkdir($FW_dir . "/echodevice", 0777) unless(-d $FW_dir . "/echodevice" );
	
	#Verzeichnis playlists anlegen
	mkdir($FW_dir . "/echodevice/playlists", 0755) unless(-d $FW_dir . "/echodevice/playlists" );
	
	# M3U Datei löschen
	if ((-e $FW_dir . "/echodevice/playlists/". $M3UFilename)) {unlink $FW_dir . "/echodevice/playlists/".$M3UFilename}
	
	# M3U Datei erzeugen
	open(FH, ">$FW_dir/echodevice/playlists/$M3UFilename");
	print FH $M3UContentWR;
	close(FH);

}

sub echodevice_GetOwnPlaylist($) {
	my ($hash) = @_;
	my $name = $hash->{NAME};
	
	# startownplaylist
	if (-d $FW_dir . "/echodevice/playlists") {

		my $M3UFiles;

		opendir(DH, $FW_dir . "/echodevice/playlists");
			my @files = readdir(DH);
		closedir(DH);

		foreach my $file (@files){
			# skip . and ..
			next if($file =~ /^\.$/);
			next if($file =~ /^\.\.$/);
			Log3 $name, 5, "[$name] [echodevice_GetOwnPlaylist] found filename = $file";
			if ($M3UFiles eq "") {
				$M3UFiles = $file;
			}
			else {
				$M3UFiles .= ",".$file;
			}
		}
		Log3 $name, 5, "[$name] [echodevice_GetOwnPlaylist] return = " . "playownplaylist:" . $M3UFiles ." ";
		if ($M3UFiles ne "") {
			return "playownplaylist:" . $M3UFiles ." " . "deleteownplaylist:" . $M3UFiles ." ";  
		}
		else {
			return ;
		}
	}
	
	else {
		return;
	}
	
}

sub echodevice_StartLastMedia($) {
	my ($hash) = @_;
	my $name = $hash->{NAME};
	my $type = $hash->{helper}{lasttype};
	
	if($hash->{helper}{lastvolume} < ReadingsVal($name , "volume_alarm", 50)) {
		echodevice_SendMessage($hash,"volume",$hash->{helper}{lastvolume});
		Log3 $name, 4, "[$name] [echodevice_StartLastMedia] [$type] set volume to " . $hash->{helper}{lastvolume};
	}
	
	if ($hash->{helper}{lasttuneinid} ne "-" && $hash->{helper}{lasttuneinid} ne "s237481" && $hash->{helper}{lasttuneinid} ne "s204188") {
		echodevice_SendCommand($hash,"tunein",$hash->{helper}{lasttuneinid}) ;
		Log3 $name, 4, "[$name] [echodevice_StartLastMedia] [$type] starte TuneIN ID " . $hash->{helper}{lasttuneinid};	
	}
	
	# Settings erneut einlesen
	InternalTimer(gettimeofday() + 5, "echodevice_GetSettings", $hash, 0);

}

sub echodevice_StartTTSMessage($) {
	my ($hash) = @_;
	my $name = $hash->{NAME};
	
	# TTS starten
	echodevice_SendCommand($hash,"ttstunein",ReadingsVal($hash->{IODev}->{NAME} , "TTS_TuneIn", "s237481"));
}

1;

=pod
=item device
=item summary Amazon Echo remote control
=begin html

<a name="echodevice"></a>
<h3>echodevice</h3>
<ul>
  Basic remote control for Amazon Echo devices. You can find the complete documentation here. 
  <br/><br/><a href="https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/" target="_blank"><b><font size=4 color="blue">https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/</font></b></a>
  
  <br/><br/>
  <b>Define</b>
  <ul>
    <code>define &lt;name&gt; echodevice &lt;DeviceID&gt; [DeviceType]</code>
    <br>
    Example: <code>define &lt;Name&gt; echodevice &lt;Amazon account&gt; &lt;Amazon Kennwort&gt</code>
    <br>
    Example: <code>define &lt;Name&gt; echodevice </code>
  </ul>
  <br>
  <b>Set</b>
   <ul>
      <li><code>...</code>
      <br>
      ...
      </li><br>
  </ul>
  <b>Get</b>
   <ul>
      <li><code>settings</code>
      <br>
      Manually reload setings (dnd, bluetooth, wakeword)
      </li><br>
      <li><code>devices</code>
      <br>
      Displays a list of Amazon devices connected to your account
      </li>
  </ul>
  <br>
  <b>Readings</b>
   <ul>
      <li><code>...</code>
      <br>
      ...
      </li><br>
  </ul>
  <br>
   <b>Attributes</b>
   <ul>
      <li><code>interval</code>
         <br>
         Poll interval in seconds (300)
      </li><br>
      <li><code>cookie</code>
         <br>
         Amazon access cookie, has to be entered for the module to work
      </li><br>
      <li><code>server</code>
         <br>
         Amazon server used for controlling the Echo
      </li><br>
  </ul>
</ul>

=end html
=cut