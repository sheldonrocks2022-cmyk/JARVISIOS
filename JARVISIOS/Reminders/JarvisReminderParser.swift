import Foundation
enum JarvisReminderParser{
 static func parse(_ text:String,now:Date=Date())->(String,Date)?{
  let l=text.lowercased()
  if let r=l.range(of:" in "),let n=Int(l[r.upperBound...].split(separator:" ").first ?? ""){
   let tail=l[r.upperBound...];let seconds=tail.contains("minute") ? n*60 : tail.contains("hour") ? n*3600 : 0
   if seconds>0{return (String(text[..<r.lowerBound]).replacingOccurrences(of:"remind me to ",with:"",options:.caseInsensitive),now.addingTimeInterval(TimeInterval(seconds)))}
  }
  return nil
 }
}
