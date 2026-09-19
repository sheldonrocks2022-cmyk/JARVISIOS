import Foundation
import UserNotifications
final class JarvisReminderManager{
 func schedule(title:String,body:String,at date:Date,repeats:Bool=false) async throws{
  let c=UNMutableNotificationContent();c.title=title;c.body=body;c.sound = .default
  let comps=Calendar.current.dateComponents(repeats ? [.hour,.minute]:[.year,.month,.day,.hour,.minute],from:date)
  try await UNUserNotificationCenter.current().add(.init(identifier:UUID().uuidString,content:c,trigger:UNCalendarNotificationTrigger(dateMatching:comps,repeats:repeats)))
 }
 func pending() async -> [UNNotificationRequest]{await UNUserNotificationCenter.current().pendingNotificationRequests()}
}
