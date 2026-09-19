import Foundation
import UIKit
import UserNotifications
@MainActor final class JarvisCore:ObservableObject{
 @Published var status="Online"
 @Published var discordServerID=UserDefaults.standard.string(forKey:"guild_id") ?? ""
 @Published var modelStatus="No GGUF model imported"
 @Published var memorySummary="Ready"
 let voice=VoiceEngine();private let memory=JarvisMemory();private var pending:(String,Date)?
 init(){voice.onText={[weak self] t in Task{@MainActor in self?.handle(t)}};UNUserNotificationCenter.current().requestAuthorization(options:[.alert,.sound]){_,_ in};refreshMemory()}
 func toggleVoice(){voice.listening ? voice.stop():voice.start()}
 func saveSettings(){UserDefaults.standard.set(discordServerID,forKey:"guild_id");status="Settings saved."}
 func handle(_ raw:String){
  let t=raw.lowercased().trimmingCharacters(in:.whitespacesAndNewlines);guard !t.isEmpty else{return};memory.add("USER: \(raw)")
  if t=="jarvis confirm" || t=="confirm"{confirm();return}
  if t.contains("open my discord server") || t=="open discord server"{openDiscord();return}
  if t.hasPrefix("discord open server "){discordServerID=String(t.dropFirst("discord open server ".count));saveSettings();openDiscord();return}
  if t.hasPrefix("remind me "){reminder(raw);return}
  if t.hasPrefix("open "){openApp(String(t.dropFirst(5)));return}
  let risky=["ban ","kick ","timeout ","mute ","delete ","remove ","send ","message ","call ","pay ","buy ","install ","role ","pin ","unpin "]
  if risky.contains(where:t.contains){pending=(raw,Date().addingTimeInterval(60));status="Action staged. Say JARVIS, confirm within 60 seconds.";voice.speak(status);return}
  status="I understood: \(raw). iOS only permits actions exposed by system APIs, App Intents, Shortcuts, or URL schemes.";voice.speak(status);refreshMemory()
 }
 private func confirm(){guard let p=pending,p.1>Date() else{pending=nil;status="No action is awaiting confirmation.";voice.speak(status);return};pending=nil;status=execute(p.0);voice.speak(status)}
 private func execute(_ raw:String)->String{let t=raw.lowercased();if t.contains("discord") || ["ban","kick","timeout","mute","role","pin"].contains(where:t.contains){openDiscord();return "Discord opened. iOS does not permit JARVIS to press moderation controls inside Discord automatically."};return "Confirmed, but iOS does not expose a safe system API for that action."}
 private func openDiscord(){guard !discordServerID.isEmpty else{status="Save your Discord Server ID first.";return};for s in ["discord://discord.com/channels/\(discordServerID)","https://discord.com/channels/\(discordServerID)"]{if let u=URL(string:s),UIApplication.shared.canOpenURL(u){UIApplication.shared.open(u);status="Opening your Discord server.";return}};status="Could not open Discord."}
 private func openApp(_ n:String){let name=n.trimmingCharacters(in:.whitespaces);let map=["discord":"discord://","settings":UIApplication.openSettingsURLString];guard let s=map[name],let u=URL(string:s),UIApplication.shared.canOpenURL(u) else{status="That app does not expose an iOS URL action to JARVIS.";return};UIApplication.shared.open(u);status="Opening \(name)."}
 private func reminder(_ raw:String){let c=UNMutableNotificationContent();c.title="JARVIS";c.body=raw;UNUserNotificationCenter.current().add(UNNotificationRequest(identifier:UUID().uuidString,content:c,trigger:UNTimeIntervalNotificationTrigger(timeInterval:60,repeats:false)));status="Reminder scheduled for one minute from now."}
 private func refreshMemory(){memorySummary=memory.recent().suffix(8).joined(separator:"\n")}
 func deleteModel(){try? FileManager.default.removeItem(at:modelURL);modelStatus="No GGUF model imported"}
 private var modelURL:URL{FileManager.default.urls(for:.documentDirectory,in:.userDomainMask)[0].appendingPathComponent("jarvis.gguf")}
}
