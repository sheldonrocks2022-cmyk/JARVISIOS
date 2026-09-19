import AppIntents
struct OpenJarvisIntent:AppIntent{
 static var title:LocalizedStringResource="Open JARVIS"
 static var openAppWhenRun=true
 func perform() async throws -> some IntentResult{.result()}
}
struct ConfirmJarvisIntent:AppIntent{
 static var title:LocalizedStringResource="Confirm JARVIS Action"
 static var openAppWhenRun=true
 func perform() async throws -> some IntentResult & ProvidesDialog{.result(dialog:"Open JARVIS and say: JARVIS confirm.")}
}
