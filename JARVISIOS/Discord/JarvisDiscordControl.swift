import UIKit
@MainActor final class JarvisDiscordControl{
 func open(guild:String)->Bool{
  for s in ["discord://discord.com/channels/\(guild)","https://discord.com/channels/\(guild)"]{if let u=URL(string:s),UIApplication.shared.canOpenURL(u){UIApplication.shared.open(u);return true}}
  return false
 }
 func moderationLimitation()->String{"iOS does not expose another app's controls to JARVIS. Discord moderation must use supported Discord interfaces; no user-token self-bot is used."}
}
