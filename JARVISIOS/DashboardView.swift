import SwiftUI
struct DashboardView: View {
 @EnvironmentObject var jarvis: JarvisCore
 @State private var command=""
 var body: some View { NavigationStack { ScrollView { VStack(spacing:18) {
  Text("J.A.R.V.I.S.").font(.largeTitle.bold()); Text(jarvis.status).font(.caption)
  TextField("Command",text:$command).textFieldStyle(.roundedBorder)
  HStack { Button("RUN"){jarvis.handle(command);command=""}.buttonStyle(.borderedProminent); Button(jarvis.voice.listening ? "STOP":"VOICE"){jarvis.toggleVoice()}.buttonStyle(.bordered) }
  GroupBox("DISCORD SERVER"){TextField("Server ID",text:$jarvis.discordServerID).keyboardType(.numberPad);Button("SAVE"){jarvis.saveSettings()}}
  GroupBox("LOCAL AI MODEL"){Text(jarvis.modelStatus);Button("DELETE MODEL"){jarvis.deleteModel()}}
  GroupBox("MEMORY"){Text(jarvis.memorySummary).font(.caption)}
 }.padding() }.navigationTitle("JARVIS iOS") } }
}
