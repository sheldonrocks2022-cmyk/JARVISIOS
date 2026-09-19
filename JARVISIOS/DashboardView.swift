import SwiftUI
import UniformTypeIdentifiers
struct DashboardView:View{
 @EnvironmentObject var jarvis:JarvisCore
 @StateObject private var models=LocalModelManager()
 @StateObject private var bluetooth=JarvisBluetoothManager()
 @State private var command="";@State private var importer=false
 var body:some View{NavigationStack{ScrollView{VStack(spacing:18){
  Text("J.A.R.V.I.S.").font(.largeTitle.bold());Text(jarvis.status).font(.caption).multilineTextAlignment(.center)
  TextField("Command",text:$command).textFieldStyle(.roundedBorder)
  HStack{Button("RUN"){jarvis.handle(command);command=""}.buttonStyle(.borderedProminent);Button(jarvis.voice.listening ? "STOP":"VOICE"){jarvis.toggleVoice()}.buttonStyle(.bordered)}
  GroupBox("LOCAL AI"){VStack{Text(models.status);Button("IMPORT GGUF"){importer=true};Button("DELETE MODEL",role:.destructive){models.delete()}}}
  GroupBox("DISCORD"){TextField("Server ID",text:$jarvis.discordServerID).keyboardType(.numberPad);Button("SAVE"){jarvis.saveSettings()}}
  GroupBox("DEVICE"){Text("Bluetooth: \(bluetooth.state)");Text("Sensitive actions require confirmation; biometric authentication is available to the security layer.").font(.caption)}
  GroupBox("MEMORY"){Text(jarvis.memorySummary).font(.caption)}
  GroupBox("iOS CAPABILITIES"){Text("Voice • Siri/App Intents • notifications • reminders • local memory • GGUF storage • coding workspace • Discord deep links • Bluetooth BLE • secure confirmations").font(.caption)}
 }.padding()}.navigationTitle("JARVIS iOS")}
 .fileImporter(isPresented:$importer,allowedContentTypes:[UTType(filenameExtension:"gguf") ?? .data]){r in if case .success(let u)=r{do{try models.importGGUF(from:u);jarvis.status="Local model imported."}catch{jarvis.status="Model import failed: \(error.localizedDescription)"}}}
 }
}
