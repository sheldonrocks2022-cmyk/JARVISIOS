import AppIntents
struct AskJarvisIntent:AppIntent{static var title:LocalizedStringResource="Ask JARVIS";@Parameter(title:"Command") var command:String;func perform() async throws -> some IntentResult & ProvidesDialog{.result(dialog:"Open JARVIS to run: \(command)")}}
struct JarvisShortcuts:AppShortcutsProvider{static var appShortcuts:[AppShortcut]{AppShortcut(intent:AskJarvisIntent(),phrases:["Ask \(.applicationName)"])}}
