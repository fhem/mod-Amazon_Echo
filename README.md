# About
Dieses Repository dient dazu, `37_echodevice.pm` komfortabel in FHEM testen zu können.

## Lizenz
Alleiniges Copyright bei Michael Winkler ([Projektseite](https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/)).
 
## Howto
Amazon-Echo kann über den FHEM-eigenen Update-Mechanismus hinzugefügt werden. Dazu muss das `update`-Kommando verwendet werden:

    update add https://bitbucket.org/christoph-morrison/fhem-amazonecho/raw/master/controls_echodevice.txt

Danach ist FHEM neu zu starten.