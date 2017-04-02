//
//  ListeningViewController.swift
//  Mnemonic
//
//  Created by Joshua Liu on 4/1/17.
//  Copyright © 2017 Joshua Liu. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ListeningViewController: UIViewController , appleSpeechFeedbackProtocall {
    
    var appleSpeechAnalyzer = AppleSpeechController()
    
    var activityView = NVActivityIndicatorView(frame: CGRect(x: 375 / 2.0 - 98 / 2.0, y: 423, width: 98, height: 98), type: NVActivityIndicatorType.lineScale, color: UIColor.white, padding: 25)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(activityView)
        activityView.startAnimating()
//        appleSpeechAnalyzer.delegate = self
//        appleSpeechAnalyzer.setupRecognizer()
//        startRecording()
    }
    
    func startRecording(){
        appleSpeechAnalyzer.startSpeech()
        shouldEnd = false

    }
    func stopRecording(){
        appleSpeechAnalyzer.endSpeech()
    }
    
    var shouldEnd = false
    
    // MARK: - Speech Delegates APPLE
    func finalAppleRecognitionRecieved(phrase: String) {
        self.addStringToTotalText(string: phrase)
        if !shouldEnd{
            delay(0.2, closure: {
                self.appleSpeechAnalyzer.startSpeech()
            })
        }
        print("Final Apple String recieved - \(phrase)")
        print("TOTAL STRING - \(fullText)")
    }
    
    func partialAppleRecognitionRecieved(phrase: String) {
        //        partialTextLabel.text = phrase
        if phrase.characters.last == "."{
            print("Sentence Ended")
            appleSpeechAnalyzer.endSpeech()
        }
        print("Partial Apple String recieved - \(phrase)")
    }
    
    func errorAppleRecieved(error: String) {
        //        partialTextLabel.text = error
        if !shouldEnd{
            self.delay(0.2, closure: {
                self.appleSpeechAnalyzer.recordButtonTapped()
            })
        }
        print("Error Apple Recieved - \(error)")
    }
    
    var fullText = ""
    
    func addStringToTotalText(string: String){
        fullText += " " + string
        print("Done")
        
    }
    
}
extension UIViewController{
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
