import Foundation
import UserNotifications
@MainActor final class JarvisCore:ObservableObject{
 @Published var status="Online"
 @Published var discordServerID=JarvisSettings.guildID
 @Published var modelStatus="No GGUF model imported"
 @Published var memorySummary="Ready"
 let voice=VoiceEngine();private let memory=JarvisMemory();private let pipeline=JarvisVoicePipeline()
 init(){voice.onText={[weak self] t in self?.handle(t)};UNUserNotificationCenter.current().requestAuthorization(options:[.alert,.sound]){_,_ in};refreshMemory()}
 func toggleVoice(){voice.listening ? voice.stop():voice.start()}
 func saveSettings(){JarvisSettings.guildID=discordServerID;status="Settings saved."}
 func handle(_ raw:String){
  guard !raw.trimmingCharacters(in:.whitespacesAndNewlines).isEmpty else{return};memory.add("USER: \(raw)")
  Task{let r=await pipeline.handle(raw);status=r;memory.add("JARVIS: \(r)");refreshMemory();voice.speak(r)}
 }
 private func refreshMemory(){memorySummary=memory.recent().suffix(8).joined(separator:"\n")}
}
