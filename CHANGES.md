CM2010 Delphi Project CHANGES
=============================

2004-09-16

* ständige Anzeige der manuell gewählten Kapazität über dem Fortschrittsbalken

2004-03-10

* Einbau der ComPort-LEDs
* Fortschrittsanzeige nach Byte 03/Lo
* LOGGING! (1 Minute = 60x34Bytes = 2.040 Bytes; 1 Std. = 122.400 Bytes)
* Optimierungen

2004-03-08

* letzte Änderungen wg. TComPort 2.64
* Anpassung der INI-Speicher- und Laderoutinen

2004-03-07

* Upgrade auf TComPort 2.64 (noch nicht getestet!)

2003-11-01

* neue Information über Byte 02/Lo und 03/Lo: TRI (Trickle/Erhaltungsladung) ins Programm eingarbeitet
* Grafikroutine flexibel gemacht, d.h. der Graph sollte auch bei veränderter Größe des Grafikfensters korrekt gezeichnet werden

2003-10-31

* Graphikroutine geändert, dass der Graph bei entfernen des Akkus keinen Haken nach unten macht, sondern einfach nur aufhört

2003-10-11

* Schriftart der Hex-Anzeige auf Courier New geändert
* GraphDelay kann nun manuell eingegeben werden (Eingeben+ENTER drücken!)

2003-10-08

* Überprüfung des laufenden (gesynchten) Datenstromes auf korrekte Zuordnung

2003-05-04

* Abspeichern/Laden der ComPort-Einstellungen vervollständigt (es werden jetzt sämtliche Einstellungen gespeichert)
* Farbfelder hinzugefügt
* Auswahldialog bei Anklicken eines Farbfeldes
* Abspeichern/Laden der Farben der einzelnen Graphen
* "Start/Stop logging"-Knopf funktionstüchtig gemacht (Logging-Funktion noch nicht)
* Fehlerbehandlung, wenn Daten nicht abgespeichert/geladen werden können
* Schieber für Timing der Graphen
* Abspeichern/Laden des zuletzt eingestellen Timing-Wertes
* INI-Paramter unter [Window]: 'AlphaBlend'(bool) und 'AlphaValue'(int)
* Feld hinzugefügt, das den Wert für das Graphen-Timing anzeigt

2003-05-02

* [X] Log - Checkboxen hinzugefügt für jeden Slot

2003-04-28

* Grafikroutine drastisch optimiert, da sie zu langsam war und das Program abschmierte --> geht jetzt
* bei Schwankungen >=0,5V zwischen zwei Messungen (1 Messung jede Minute) wird die Uhrzeit neben den Graphen geschrieben

2003-04-25

* Grafikroutine vorbereitet, aber keine Möglichkeit zum Testen
* Timeout eingefügt, wenn mehr als 400ms kein Zeichen mehr empfangen wird

2003-03-18

* virtuelles Übersichts-Display eingebaut
* Erkennung der momentanen Phase (Laden/Entladen?)

2003-03-15

* virtuelle Displays für jeden Schacht eingebaut

2003-03-14

* erste Anfänge
