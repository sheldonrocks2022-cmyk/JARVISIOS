import Foundation
import Speech
import AVFoundation
@MainActor final class VoiceEngine:ObservableObject{
 @Published var listening=false;var onText:((String)->Void)?;private let recognizer=SFSpeechRecognizer(locale:Locale(identifier:"en-US"));private let engine=AVAudioEngine();private var request:SFSpeechAudioBufferRecognitionRequest?;private var task:SFSpeechRecognitionTask?;private let speaker=AVSpeechSynthesizer()
 func start(){SFSpeechRecognizer.requestAuthorization{_ in};AVAudioApplication.requestRecordPermission { _ in };do{request=SFSpeechAudioBufferRecognitionRequest();guard let request else{return};let input=engine.inputNode;input.removeTap(onBus:0);input.installTap(onBus:0,bufferSize:1024,format:input.outputFormat(forBus:0)){b,_ in request.append(b)};try AVAudioSession.sharedInstance().setCategory(.playAndRecord,mode:.voiceChat,options:[.allowBluetoothHFP]);try AVAudioSession.sharedInstance().setActive(true);engine.prepare();try engine.start();listening=true;task=recognizer?.recognitionTask(with:request){[weak self] r,e in guard let self else{return};if let r,r.isFinal{Task{@MainActor in self.onText?(r.bestTranscription.formattedString);self.stop()}};if e != nil{Task{@MainActor in self.stop()}}}}catch{listening=false}}
 func stop(){request?.endAudio();task?.cancel();if engine.isRunning{engine.stop()};engine.inputNode.removeTap(onBus:0);listening=false}
 func speak(_ t:String){speaker.speak(AVSpeechUtterance(string:t))}
}
