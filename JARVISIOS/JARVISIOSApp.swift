import SwiftUI
@main struct JARVISIOSApp: App {
 @StateObject private var jarvis = JarvisCore()
 var body: some Scene { WindowGroup { DashboardView().environmentObject(jarvis) } }
}
