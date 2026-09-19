import Foundation
final class JarvisMemory{private let key="jarvis_memory";func add(_ s:String){var a=recent();a.append(s);if a.count>50{a.removeFirst(a.count-50)};UserDefaults.standard.set(a,forKey:key)};func recent()->[String]{UserDefaults.standard.stringArray(forKey:key) ?? []}}
