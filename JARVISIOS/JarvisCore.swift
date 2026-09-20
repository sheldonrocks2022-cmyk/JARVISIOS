import Foundation
import UserNotifications
@MainActor final class JarvisCore:ObservableObject{
 @Published var status="Online"
 @Published var discordServerID=JarvisSettings.guildID
 @Published var modelStatus="No GGUF model imported"
 @Published var memorySummary="Ready"
 @Published var transcript=""
 @Published var isThinking=false
 let voice=VoiceEngine();private let memory=JarvisMemory();private let pipeline=JarvisVoicePipeline()
 init(){voice.onText={[weak self] t in self?.handle(t)};UNUserNotificationCenter.current().requestAuthorization(options:[.alert,.sound]){_,_ in};refreshMemory()}
 func toggleVoice(){voice.listening ? voice.stop():voice.start()}
 func saveSettings(){JarvisSettings.guildID=discordServerID;status="Settings saved."}
 func handle(_ raw:String){
  let clean=raw.trimmingCharacters(in:.whitespacesAndNewlines);guard !clean.isEmpty else{return}
  transcript=clean;memory.add("USER: \(clean)");isThinking=true;status="Thinking…"
  Task{
   let r=await pipeline.handle(clean)
   status=r;isThinking=false;memory.add("JARVIS: \(r)");refreshMemory()
   if !r.isEmpty{voice.speak(r)}
  }
 }
 private func refreshMemory(){memorySummary=memory.recent().suffix(8).joined(separator:"\n")}
}
