import Foundation
@MainActor final class JarvisVoicePipeline:ObservableObject{
 let agent=JarvisAgentRuntime();let llm=LocalLLMEngine()
 func handle(_ text:String) async -> String{
  let direct=await agent.run(text)
  if direct != "I understood the request, but no permitted iOS tool matched it."{return direct}
  do{return try await llm.generate("You are JARVIS. Respond concisely and safely. User: \(text)")}catch{return error.localizedDescription}
 }
}
