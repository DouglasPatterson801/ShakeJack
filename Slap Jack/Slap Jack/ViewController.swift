//
//  ViewController.swift
//  Slap Jack
//
//  Created by Douglas Patterson on 1/15/19.
//  Copyright © 2019 Douglas Patterson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var imageView = UIImageView()
  
    
    @IBOutlet weak var startButton: RoundButton!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var remainingTitleLabel: UILabel!
    @IBOutlet weak var cardsRemainingLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameoverLabel: UILabel!
    
    var cardsRemaining = 52
    var timer = Timer()
    var isTimerRunning = false
    var resumeTapped = false
    var deck: Deck?
    var card: Card?
    var score = 0
    var goodSlaps = 0
    var badSlaps = 0
    
    //==================================================
    // MARK: - Methods
    //==================================================
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if card?.value == "JACK" {
                score += 1
                goodSlaps += 1
            } else {
                score -= 1
                badSlaps += 1
            }
            scoreLabel.text = "\(score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.isHidden = true
        pauseButton.isHidden = true
        remainingTitleLabel.isHidden = true
        cardsRemainingLabel.isHidden = true
        gameoverLabel.isHidden = true
        
        //get image from assets
        let image = UIImage(named: "feltTable")
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.image = image
        
        self.view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageView.frame = self.view.bounds
        
    }

//==================================================
// MARK: - Actions
//==================================================
    
// Timer Functionality
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.10, target: self, selector: (#selector(ViewController.drawCardAndUpdateRemaining)), userInfo: nil, repeats: true)
        
    }
    
    @objc func drawCardAndUpdateRemaining() {
        cardsRemaining -= 1
        cardsRemainingLabel.text = "\(cardsRemaining)"
        
        guard let deck = deck,
        let deckId = deck.deck_id else { return }
        CardController.sharedController.drawCard(deckId: deckId) { (card) in
            guard let card = card else { return }
            CardController.sharedController.getImage(card: card, completion: { (image) in
                DispatchQueue.main.async {
                    self.card = card
                    self.cardImageView.image = image
                }
                
            })
        }
//  END OF GAME
        if cardsRemaining == 0 {
            timer.invalidate()
            startButton.isHidden = false
            pauseButton.isHidden = true
            cardImageView.isHidden = true
            if goodSlaps == 4 {
                gameoverLabel.text = "PERFECT SCORE!!\nPlay Again!"
            } else {
                gameoverLabel.text = "Good slaps: \(goodSlaps)\nBad Slaps: \(badSlaps)\nFINAL SCORE: \(score)\nPlay Again!"
                gameoverLabel.isHidden = false
            }
        }
        
    }
    
//  START GAME
    @IBAction func startButtonTapped(_ sender: Any) {
        gameoverLabel.isHidden = true
        goodSlaps = 0
        badSlaps = 0
        score = 0
        scoreLabel.text = "\(score)"
        CardController.sharedController.getDeck { (deck) in
            DispatchQueue.main.async {
                self.deck = deck
            }
        }
        cardsRemaining = 52
        cardImageView.isHidden = false
        runTimer()
        remainingTitleLabel.isHidden = false
        cardsRemainingLabel.isHidden = false
        pauseButton.isHidden = false
        startButton.isHidden = true
        
    }
   //   PAUSE & RESUME GAME
    @IBAction func pausePlayButtonTapped(_ sender: Any) {
        if self.resumeTapped == false {
            timer.invalidate()
            self.resumeTapped = true
            pauseButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            runTimer()
            self.resumeTapped = false
            pauseButton.setImage(UIImage(named: "pause"), for: .normal)
        }
    }
    
}

