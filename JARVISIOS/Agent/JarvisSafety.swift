import Foundation
@MainActor final class JarvisSafety:ObservableObject{
 struct Pending{let summary:String;let expires:Date;let action:()->Void}
 @Published private(set) var pending:Pending?
 func stage(_ summary:String,timeout:TimeInterval=60,action:@escaping()->Void){pending = .init(summary:summary,expires:Date().addingTimeInterval(timeout),action:action)}
 func cancel(){pending = nil}
 func confirm(using security:JarvisSecurity) async -> String{
  guard let p=pending,p.expires>Date() else{pending=nil;return "There is no pending action."}
  guard await security.authenticate("Confirm JARVIS action: \(p.summary)") else{return "Authentication cancelled."}
  pending=nil;p.action();return "Confirmed: \(p.summary)"
 }
}
