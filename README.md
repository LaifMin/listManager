
# Dev Laif

# List Manager

Applicazione Flutter per la gestione di liste di attività con statistiche di performance e persistenza locale.

## Tecnologie
- Flutter 3.9.2
- Dart 3.9.2
- SharedPreferences 2.2.2 (per la persistenza)
- Material Design 3

## Persistenza dati
L'applicazione utilizza il pacchetto SharedPreferences per salvare i dati localmente sul dispositivo. Le liste e i relativi task vengono convertiti in formato JSON e memorizzati in modo che rimangano disponibili anche dopo la chiusura dell'app.

## Struttura progetto
- lib/main.dart: Entry point, tema e navigazione principale.
- lib/models/: Modelli di dati per Task e Liste.
- lib/services/: Logica per il salvataggio dei dati (StorageService).
- lib/screens/: Schermate principali (Home e Stats).
- lib/widgets/: Componenti UI riutilizzabili e dialoghi.

## Installazione
1. Scaricare o clonare il progetto.
2. Navigare nella cartella del progetto: `cd list_manager`
3. Installare le dipendenze: `flutter pub get`

## Esecuzione
Per avviare l'applicazione in ambiente web:
`flutter run -d chrome`

Per avviare su Windows:
`flutter run -d windows`

## Modifica colori
I colori principali del tema (Aqua) possono essere modificati cambiando le costanti `kAqua`, `kAquaDark` e `kAquaLight` presenti nei seguenti file:
- lib/screens/home_screen.dart
- lib/screens/stats_screen.dart
- lib/widgets/dialogs.dart

## Come usare
1. Creazione lista: Cliccare sul pulsante "+" in basso a destra, inserire nome, priorità e scadenza opzionale.
2. Aggiunta task: Cliccare su una lista per espanderla e selezionare "Aggiungi task...".
3. Completamento: Toccare la checkbox accanto a un task per segnarlo come completato.
4. Statistiche: Cambiare scheda tramite la barra di navigazione in basso per visualizzare la performance globale e per singola lista.
5. Eliminazione: Espandere una lista e cliccare su "Elimina lista" in fondo alla sezione dei task.
