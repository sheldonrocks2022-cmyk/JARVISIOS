import Foundation
protocol LocalLLMBackend {
 func generate(prompt: String) async throws -> String
}
enum LocalLLMError: LocalizedError {
 case modelMissing, backendUnavailable, loadFailed, inferenceFailed
 var errorDescription: String? {
  switch self {
  case .modelMissing: return "Import a GGUF model first."
  case .backendUnavailable: return "The llama.cpp runtime is unavailable."
  case .loadFailed: return "The GGUF model could not be loaded."
  case .inferenceFailed: return "Local inference failed."
  }
 }
}
@MainActor final class LocalLLMEngine: ObservableObject {
 enum State: Equatable { case idle, loading, ready, generating, failed(String) }
 @Published private(set) var state: State = .idle
 @Published private(set) var lastError: String?
 private let models: LocalModelManager
 init(models: LocalModelManager) { self.models = models; refresh() }
 convenience init() { self.init(models: LocalModelManager()) }
 func refresh() {
  models.reload()
  state = models.modelURL == nil ? .idle : .ready
 }
 func generate(_ prompt: String) async throws -> String {
  guard !prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return "" }
  guard let url = models.modelURL else { state = .failed(LocalLLMError.modelMissing.localizedDescription); throw LocalLLMError.modelMissing }
  state = .generating; lastError = nil
  do {
   let output = try await LlamaNativeBackend(modelURL: url).generate(prompt: prompt)
   guard !output.isEmpty else { throw LocalLLMError.inferenceFailed }
   state = .ready
   return output
  } catch {
   lastError = error.localizedDescription
   state = .failed(error.localizedDescription)
   throw error
  }
 }
}
