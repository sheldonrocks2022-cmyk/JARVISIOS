import Foundation
@MainActor final class JarvisVoicePipeline:ObservableObject{
 let agent=JarvisAgentRuntime()
 @Published private(set) var processing=false
 @Published private(set) var lastTranscript=""
 @Published private(set) var lastResponse=""
 func handle(_ text:String) async -> String{
  let clean=text.trimmingCharacters(in:.whitespacesAndNewlines)
  guard !clean.isEmpty else{return ""}
  processing=true;lastTranscript=clean
  defer{processing=false}
  let response=await agent.run(clean)
  lastResponse=response
  return response
 }
}
