import Foundation
enum JarvisTool:String,Codable{case openURL,reminder,workspaceRead,workspaceWrite,discordOpen}
struct JarvisStep:Codable{let tool:JarvisTool;let argument:String}
@MainActor final class JarvisAgent{
 let memory=JarvisAgentMemory()
 func plan(_ goal:String)->[JarvisStep]{
  let g=goal.lowercased()
  if g.contains("discord"){return [.init(tool:.discordOpen,argument:goal)]}
  if g.contains("remind"){return [.init(tool:.reminder,argument:goal)]}
  return []
 }
 func record(goal:String,result:String,success:Bool){memory.record(goal:goal,result:result,success:success)}
}
