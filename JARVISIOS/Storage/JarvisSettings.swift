import Foundation
struct JarvisSettings{
 static var guildID:String{get{UserDefaults.standard.string(forKey:"guild_id") ?? ""}set{UserDefaults.standard.set(newValue,forKey:"guild_id")}}
 static var confirmationTimeout:TimeInterval{60}
}
