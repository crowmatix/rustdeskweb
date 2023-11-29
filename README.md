<p align="center">
  <img src="logo-header.svg" alt="RustDesk - Your remote desktop"><br>
  <a href="#rustdeskweb-schritte">RustDeskWeb</a> •
  <a href="#dateistruktur">Dateistruktur</a> •
  
Das hier ist ein Programm was, man nutzen kann, um einen Computer fernzusteuern, es wurde in Rust geschrieben. Es funktioniert ohne Konfiguration oder ähnliches, man kann es einfach direkt nutzen. Du hast volle Kontrolle über deine Daten und brauchst dir daher auch keine Sorgen um die Sicherheit dieser Daten zu machen.
RustDesk heißt jegliche Mitarbeit willkommen. Schau dir [`CONTRIBUTING.md`](CONTRIBUTING.md) an, wenn du Hilfe brauchst für den Start.

## RustDeskWeb Schritte

```sh
git clone https://github.com/JelleBuning/rustdesk.git
cd rustdesk
git switch fix_build
cd flutter/web/js

# Zuerst protoc installieren, siehe https://google.github.io/proto-lens/installing-protoc.html
npm install ts-proto
# Funktioniert nur mit vite ≤ 2.8, siehe https://github.com/vitejs/vite/blob/main/docs/guide/build.md#chunking-strategy
npm install vite@2.8

# Für die Erstellung von yarn erforderlich
npm install yarn -g
npm install typescript -g
npm install protoc -g

yarn build

cd ..

# Für Details zum YUV-Konverter siehe https://github.com/rustdesk/rustdesk/issues/364#issuecomment-1023562050
wget https://github.com/rustdesk/doc.rustdesk.com/releases/download/console/web_deps.tar.gz
# In den aktuellen Ordner entpacken
tar xzf web_deps.tar.gz

cd ..

# Viel Glück!
flutter run -d chrome
```

## Dateistruktur

- **[libs/hbb_common](https://github.com/rustdesk/rustdesk/tree/master/libs/hbb_common)**: Video Codec, Konfiguration, TCP/UDP Wrapper, Protokoll Puffer, fs Funktionen für Dateitransfer, und ein paar andere nützliche Funktionen
- **[libs/scrap](https://github.com/rustdesk/rustdesk/tree/master/libs/scrap)**: Bildschirmaufnahme
- **[libs/enigo](https://github.com/rustdesk/rustdesk/tree/master/libs/enigo)**: Plattformspezifische Maus und Tastatur Steuerung
- **[src/ui](https://github.com/rustdesk/rustdesk/tree/master/src/ui)**: GUI
- **[src/server](https://github.com/rustdesk/rustdesk/tree/master/src/server)**: Audio/Zwischenablage/Eingabe/Videodienste und Netzwerk Verbindungen
- **[src/client.rs](https://github.com/rustdesk/rustdesk/tree/master/src/client.rs)**: Starten einer Peer-Verbindung
- **[src/rendezvous_mediator.rs](https://github.com/rustdesk/rustdesk/tree/master/src/rendezvous_mediator.rs)**: Mit [rustdesk-server](https://github.com/rustdesk/rustdesk-server) kommunizieren, für Verbindung von außen warten, direkt (TCP hole punching) oder weitergeleitet
- **[src/platform](https://github.com/rustdesk/rustdesk/tree/master/src/platform)**: Plattformspezifischer Code
