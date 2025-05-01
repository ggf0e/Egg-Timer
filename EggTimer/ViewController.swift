//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

final class ViewController: UIViewController {
    private let eggTimes: [String : Int] = [
        "Soft" : 3,
        "Medium" : 6,
        "Hard" : 12
    ]
    private var totalTime = 0
    private var secondsPassed = 0
    private var timer = Timer()
    private var player: AVAudioPlayer?
    private var timerFeedback = Timer()
    private var feedback = UIImpactFeedbackGenerator()
    private var feedbackCount = 0
    
    //MARK: - Outlets:
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    //MARK: - Actions:
    @IBAction private func hardnessSelected(_ sender: UIButton) {
        mainLabel.text = "How do you like your eggs?"
        progressBar.progress = 0
        secondsPassed = 0
        let hardness = sender.currentTitle! // Soft, Medium, Hard
        
        totalTime = eggTimes[hardness]!
        
        timer.invalidate() // Invalidate timer and start new timer
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true
        )
    }
    
    //MARK: - Methods:
    @objc private func updateTimer() {
        if secondsPassed < totalTime{
            secondsPassed +=  1
            progressBar.progress = Float(secondsPassed) / Float(totalTime)
        }
        if secondsPassed == totalTime {
            timer.invalidate()
            mainLabel.text = "Done!"
            playSound()
            timerFeedback = Timer.scheduledTimer(
                timeInterval: 1.0,
                target: self,
                selector: #selector(vibro),
                userInfo: nil,
                repeats: true
            )
        }
    }
    private func playSound() {
        if let url = Bundle.main.url(
            forResource: "alarm_sound",
            withExtension: "mp3"
        ) {
            player = try? AVAudioPlayer(contentsOf: url)
            player?.play()
        }
        }
    @objc private func vibro() {
        if feedbackCount < 3 {
            feedbackCount += 1
            print(feedback)
            feedback.prepare()
            feedback.impactOccurred(intensity: 0.5)
        } else {
            feedbackCount = 0
            timerFeedback.invalidate()
        }
        
    }
}
