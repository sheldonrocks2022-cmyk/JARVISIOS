import Foundation
import UIKit
@MainActor final class JarvisToolExecutor{
 let discord=JarvisDiscordControl();let reminders=JarvisReminderManager();let workspace=JarvisCodingWorkspace()
 func execute(_ step:JarvisStep) async -> String{
  switch step.tool{
  case .discordOpen:
   let id=JarvisSettings.guildID;return !id.isEmpty && discord.open(guild:id) ? "Opened Discord server." : "Save a Discord Server ID first."
  case .openURL:
   guard let u=URL(string:step.argument),["http","https"].contains(u.scheme?.lowercased() ?? "") else{return "URL rejected."};UIApplication.shared.open(u);return "Opened link."
  case .workspaceRead:return (try? workspace.read(step.argument)) ?? "Could not read workspace file."
  case .workspaceWrite:return "Workspace writes require an explicit path and content."
  case .reminder:
   return "Reminder request recognized. Include a supported time in the JARVIS UI."
  }
 }
}
