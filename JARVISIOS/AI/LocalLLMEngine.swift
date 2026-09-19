import Foundation
protocol LocalLLMBackend{func generate(prompt:String) async throws -> String}
enum LocalLLMError:LocalizedError{case modelMissing,backendUnavailable;var errorDescription:String?{switch self{case .modelMissing:return "Import a GGUF model first.";case .backendUnavailable:return "The GGUF runtime is not linked yet."}}}
@MainActor final class LocalLLMEngine:ObservableObject{
 private let models:LocalModelManager
 init(models:LocalModelManager=LocalModelManager()){self.models=models}
 func generate(_ prompt:String) async throws -> String{
  guard models.modelURL != nil else{throw LocalLLMError.modelMissing}
  // Runtime boundary: a llama.cpp backend plugs in here without changing voice/agent routing.
  throw LocalLLMError.backendUnavailable
 }
}
