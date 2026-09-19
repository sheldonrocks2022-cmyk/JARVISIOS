import Foundation
struct AgentTrace:Codable{let date:Date;let goal:String;let result:String;let success:Bool}
final class JarvisAgentMemory{
 private let key="jarvis_agent_traces"
 func record(goal:String,result:String,success:Bool){var a=all();a.append(.init(date:Date(),goal:goal,result:result,success:success));if a.count>100{a.removeFirst(a.count-100)};if let d=try? JSONEncoder().encode(a){UserDefaults.standard.set(d,forKey:key)}}
 func all()->[AgentTrace]{guard let d=UserDefaults.standard.data(forKey:key) else{return []};return (try? JSONDecoder().decode([AgentTrace].self,from:d)) ?? []}
 func relevant(to goal:String)->[AgentTrace]{let words=Set(goal.lowercased().split(separator:" ").map(String.init));return all().sorted{score($0)>score($1)}.prefix(8).map{$0};func score(_ t:AgentTrace)->Int{Set(t.goal.lowercased().split(separator:" ").map(String.init)).intersection(words).count}}
}
