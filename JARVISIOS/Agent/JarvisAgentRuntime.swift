import Foundation
@MainActor final class JarvisAgentRuntime:ObservableObject{
 let planner=JarvisAgent();let tools=JarvisToolExecutor();let safety=JarvisSafety();let security=JarvisSecurity()
 let localAI=LocalLLMEngine()
 @Published var lastResult=""
 func run(_ goal:String) async -> String{
  let clean=goal.trimmingCharacters(in:.whitespacesAndNewlines)
  let lower=clean.lowercased()
  if ["jarvis confirm","confirm"].contains(lower){let r=await safety.confirm(using:security);lastResult=r;return r}
  if ["jarvis cancel","cancel action","cancel"].contains(lower),safety.pending != nil{safety.cancel();let r="Pending action cancelled.";lastResult=r;return r}
  let risky=["delete","ban","kick","remove","write","replace"].contains{lower.contains($0)}
  if risky{safety.stage(clean,timeout:JarvisSettings.confirmationTimeout){};let r="Action staged. Say JARVIS confirm within two minutes to authenticate and continue.";lastResult=r;return r}
  if let step=planner.plan(clean).first {
   let result=await tools.execute(step);planner.record(goal:clean,result:result,success:!result.lowercased().contains("couldn't") && !result.contains("Could not"));lastResult=result;return result
  }
  do {
   let history=planner.memory.relevant(to:clean).suffix(4).map{"Earlier request: \($0.goal)\nResult: \($0.result)"}.joined(separator:"\n")
   let prompt=""" 
   You are JARVIS, a concise private iOS assistant. Answer the current request helpfully. Never claim an external action happened unless a JARVIS tool performed it. Use relevant prior context only when useful.
   \(history)
   Current user request: \(clean)
   JARVIS:
   """
   let result=try await localAI.generate(prompt)
   planner.record(goal:clean,result:result,success:true);lastResult=result;return result
  } catch {
   let result="I understood the request, but no permitted iOS tool matched it and local AI is unavailable: \(error.localizedDescription)"
   planner.record(goal:clean,result:result,success:false);lastResult=result;return result
  }
 }
}
