import AppIntents
struct JarvisShortcuts:AppShortcutsProvider{
 static var appShortcuts:[AppShortcut]{
  AppShortcut(intent:OpenJarvisIntent(),phrases:["Open \(.applicationName)"],shortTitle:"Open JARVIS",systemImageName:"waveform")
  AppShortcut(intent:ConfirmJarvisIntent(),phrases:["Confirm with \(.applicationName)"],shortTitle:"Confirm Action",systemImageName:"checkmark.shield")
 }
}
