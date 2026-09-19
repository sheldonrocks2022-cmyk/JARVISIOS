import Foundation
@MainActor final class JarvisAgentRuntime:ObservableObject{
 let planner=JarvisAgent();let tools=JarvisToolExecutor();let safety=JarvisSafety();let security=JarvisSecurity()
 @Published var lastResult=""
 func run(_ goal:String) async -> String{
  if ["jarvis confirm","confirm"].contains(goal.lowercased().trimmingCharacters(in:.whitespacesAndNewlines)){let r=await safety.confirm(using:security);lastResult=r;return r}
  let risky=["delete","ban","kick","remove","write","replace"].contains{goal.lowercased().contains($0)}
  if risky{safety.stage(goal){};let r="Action staged. Say JARVIS confirm to authenticate and continue.";lastResult=r;return r}
  var result="I understood the request, but no permitted iOS tool matched it."
  for _ in 0..<12{guard let step=planner.plan(goal).first else{break};result=await tools.execute(step);break}
  planner.record(goal:goal,result:result,success:!result.contains("Could not"));lastResult=result;return result
 }
}
