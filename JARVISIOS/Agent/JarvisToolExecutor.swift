import Foundation
import UIKit
@MainActor final class JarvisToolExecutor{
 let discord=JarvisDiscordControl();let reminders=JarvisReminderManager();let workspace=JarvisCodingWorkspace()
 func execute(_ step:JarvisStep) async -> String{
  switch step.tool{
  case .discordOpen:
   let id=JarvisSettings.guildID;return !id.isEmpty && discord.open(guild:id) ? "Opened Discord server." : "Save a Discord Server ID first."
  case .openURL:
   guard let u=URL(string:step.argument),["http","https"].contains(u.scheme?.lowercased() ?? "") else{return "URL rejected."}
   let ok=await UIApplication.shared.open(u);return ok ? "Opened link." : "iOS could not open that link."
  case .workspaceRead:return (try? workspace.read(step.argument)) ?? "Could not read workspace file."
  case .workspaceWrite:return "Workspace writes require an explicit path and content."
  case .reminder:
   guard let (title,date)=JarvisReminderParser.parse(step.argument) else{return "Tell me when to remind you, for example: remind me to call Alex in 20 minutes."}
   do{try await reminders.schedule(title:"JARVIS Reminder",body:title,at:date);return "Reminder set for \(date.formatted(date:.abbreviated,time:.shortened))."}catch{return "I couldn't schedule that reminder: \(error.localizedDescription)"}
  }
 }
}
