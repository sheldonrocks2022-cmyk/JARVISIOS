import Foundation
enum JarvisReminderParser{
 static func parse(_ text:String,now:Date=Date())->(String,Date)?{
  let l=text.lowercased()
  if let r=l.range(of:" in "),let n=Int(l[r.upperBound...].split(separator:" ").first ?? ""){
   let tail=l[r.upperBound...]
   let seconds=tail.contains("second") ? n : tail.contains("minute") ? n*60 : tail.contains("hour") ? n*3600 : tail.contains("day") ? n*86400 : 0
   if seconds>0{return (cleanTitle(String(text[..<r.lowerBound])),now.addingTimeInterval(TimeInterval(seconds)))}
  }
  if l.contains(" tomorrow"){
   let title=cleanTitle(text.replacingOccurrences(of:" tomorrow",with:"",options:.caseInsensitive))
   if let d=Calendar.current.date(byAdding:.day,value:1,to:now){return(title,d)}
  }
  return nil
 }
 private static func cleanTitle(_ s:String)->String{
  s.replacingOccurrences(of:"remind me to ",with:"",options:.caseInsensitive).replacingOccurrences(of:"reminder ",with:"",options:.caseInsensitive).trimmingCharacters(in:.whitespacesAndNewlines)
 }
}
