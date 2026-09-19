import Foundation
final class JarvisCodingWorkspace{
 private let root:URL
 init(){root=FileManager.default.urls(for:.documentDirectory,in:.userDomainMask)[0].appendingPathComponent("Workspace");try? FileManager.default.createDirectory(at:root,withIntermediateDirectories:true)}
 private func safe(_ path:String)throws->URL{let u=root.appendingPathComponent(path).standardizedFileURL;guard u.path.hasPrefix(root.standardizedFileURL.path) else{throw CocoaError(.fileWriteInvalidFileName)};return u}
 func write(_ path:String,_ text:String)throws{let u=try safe(path);try FileManager.default.createDirectory(at:u.deletingLastPathComponent(),withIntermediateDirectories:true);try text.write(to:u,atomically:true,encoding:.utf8)}
 func read(_ path:String)throws->String{try String(contentsOf:try safe(path),encoding:.utf8)}
 func list()->[String]{(try? FileManager.default.subpathsOfDirectory(atPath:root.path)) ?? []}
 func replace(_ path:String,from:String,to:String)throws{let s=try read(path);try write(path,s.replacingOccurrences(of:from,with:to))}
}
