import Foundation
@MainActor final class JarvisAgentRuntime:ObservableObject{
 let planner=JarvisAgent();let tools=JarvisToolExecutor();let safety=JarvisSafety();let security=JarvisSecurity()
 let localAI=LocalLLMEngine()
 @Published var lastResult=""
 func run(_ goal:String) async -> String{
  let clean=goal.trimmingCharacters(in:.whitespacesAndNewlines)
  if ["jarvis confirm","confirm"].contains(clean.lowercased()){let r=await safety.confirm(using:security);lastResult=r;return r}
  let risky=["delete","ban","kick","remove","write","replace"].contains{clean.lowercased().contains($0)}
  if risky{safety.stage(clean){};let r="Action staged. Say JARVIS confirm to authenticate and continue.";lastResult=r;return r}
  if let step=planner.plan(clean).first {
   let result=await tools.execute(step)
   planner.record(goal:clean,result:result,success:!result.contains("Could not"))
   lastResult=result;return result
  }
  do {
   let prompt="You are JARVIS, a concise iOS assistant. Respond helpfully to the user's request. Do not claim to perform actions you cannot perform. User: \(clean)\nJARVIS:"
   let result=try await localAI.generate(prompt)
   planner.record(goal:clean,result:result,success:true);lastResult=result;return result
  } catch {
   let result="I understood the request, but no permitted iOS tool matched it and local AI is unavailable: \(error.localizedDescription)"
   planner.record(goal:clean,result:result,success:false);lastResult=result;return result
  }
 }
}
