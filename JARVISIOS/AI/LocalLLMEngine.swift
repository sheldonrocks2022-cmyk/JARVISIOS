import Foundation
protocol LocalLLMBackend{func generate(prompt:String) async throws -> String}
enum LocalLLMError:LocalizedError{case modelMissing,backendUnavailable,loadFailed,inferenceFailed;var errorDescription:String?{switch self{case .modelMissing:return "Import a GGUF model first.";case .backendUnavailable:return "The llama.cpp runtime is unavailable.";case .loadFailed:return "The GGUF model could not be loaded.";case .inferenceFailed:return "Local inference failed."}}}
@MainActor final class LocalLLMEngine:ObservableObject{
 private let models:LocalModelManager
 init(models:LocalModelManager=LocalModelManager()){self.models=models}
 func generate(_ prompt:String) async throws -> String{guard let url=models.modelURL else{throw LocalLLMError.modelMissing};return try await LlamaNativeBackend(modelURL:url).generate(prompt:prompt)}
}
