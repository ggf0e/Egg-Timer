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
    private let feedback = UIImpactFeedbackGenerator(style: .heavy)

        //MARK: - Outlets:
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!

        //MARK: - Actions:
    @IBAction private func hardnessSelected(_ sender: UIButton) {
        guard let hardness = sender.currentTitle,
              let time = eggTimes[hardness]
        else { return }

        totalTime = time

        mainLabel.text = "How do you like your eggs?"
        progressBar.progress = 0
        secondsPassed = 0

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
        } else if secondsPassed == totalTime {
            timer.invalidate()
            mainLabel.text = "Done!"
            playSound()
            startFeedback()
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
    
    private func someFeedback() {
        feedback.prepare()
        feedback.impactOccurred(intensity: 0.5)
        print(feedback)
    }
    
    private func startFeedback() {
        var vibrationCount = 0
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if vibrationCount < 4 {
                self.someFeedback() // Выполнение вибрации
                vibrationCount += 1
            } else {
                timer.invalidate() // Остановить таймер после 4 вибраций
            }
        }
    }
}

