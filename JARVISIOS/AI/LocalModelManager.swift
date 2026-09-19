import Foundation
@MainActor final class LocalModelManager:ObservableObject{
 @Published private(set) var modelURL:URL?
 private let fm=FileManager.default
 init(){reload()}
 func reload(){let u=destination;modelURL=(fm.fileExists(atPath:u.path) ? u:nil)}
 var status:String{modelURL == nil ? "No GGUF model imported":"GGUF ready: \(modelURL!.lastPathComponent)"}
 func importGGUF(from source:URL) throws{
  guard source.pathExtension.lowercased()=="gguf" else{throw CocoaError(.fileReadCorruptFile)}
  let access=source.startAccessingSecurityScopedResource();defer{if access{source.stopAccessingSecurityScopedResource()}}
  let attrs=try fm.attributesOfItem(atPath:source.path);guard (attrs[.size] as? NSNumber)?.int64Value ?? 0 > 1_000_000 else{throw CocoaError(.fileReadCorruptFile)}
  try? fm.removeItem(at:destination);try fm.copyItem(at:source,to:destination);reload()
 }
 func delete(){try? fm.removeItem(at:destination);reload()}
 private var destination:URL{fm.urls(for:.applicationSupportDirectory,in:.userDomainMask)[0].appendingPathComponent("jarvis.gguf")}
}
