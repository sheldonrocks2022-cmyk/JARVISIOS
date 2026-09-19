import Foundation
enum DiscordSnowflake{
 static let epoch:UInt64=1420070400000
 static func createdAt(_ id:String)->Date?{guard let n=UInt64(id) else{return nil};let ms=(n>>22)+epoch;return Date(timeIntervalSince1970:TimeInterval(ms)/1000)}
 static func ageDays(_ id:String,now:Date=Date())->Int?{guard let d=createdAt(id) else{return nil};return Calendar.current.dateComponents([.day],from:d,to:now).day}
}
