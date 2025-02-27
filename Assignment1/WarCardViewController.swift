import Foundation
import UIKit

class WarCardViewController: UIViewController {
    
    // UI elements
    @IBOutlet weak var player1ScoreLabel: UILabel!
    @IBOutlet weak var player2ScoreLabel: UILabel!
    @IBOutlet weak var player1CardImageView: UIImageView!
    @IBOutlet weak var player2CardImageView: UIImageView!
    @IBOutlet weak var controlButton: UIButton!
 
    @IBOutlet weak var player2NameLabel: UILabel!
    
    // Game manager and ticker for game state management
    var gameManager: GameManager
    var ticker: Ticker
    var isRunning: Bool = true
    var roundCount: Int = 0
    let maxRounds = 5
    var dealtCards: (player1Card: String, player2Card: String)?

    // Initializer to create instances of GameManager and Ticker
    required init?(coder: NSCoder) {
        gameManager = GameManager()
        ticker = Ticker()
        super.init(coder: coder)
    }
    
    // Setup UI and start ticker when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve and set the player name from UserDefaults
        if let playerName = UserDefaults.standard.string(forKey: "playerName") {
            player2NameLabel.text = playerName
        }
                
        // Set initial scores
          player1ScoreLabel.text = "0"
          player2ScoreLabel.text = "0"
          
          // Set initial card images to back of the card
          player1CardImageView.image = UIImage(named: "back")
          player2CardImageView.image = UIImage(named: "back")
          
          // Set initial button image to stop
          controlButton.setImage(UIImage(named: "stop"), for: .normal)
          
          
          // Set the state change handler for the ticker
          ticker.stateChangeHandler = { [weak self] state in
              self?.handleStateChange(state)
          }
          ticker.start() // Start the ticker
      }
    
    // Toggle the ticker when the control button is tapped
    @IBAction func controlButtonTapped(_ sender: UIButton) {
        if isRunning {
            ticker.stop()
            controlButton.setImage(UIImage(named: "play"), for: .normal)
            print("Control button tapped: Timer stopped")
        } else {
            ticker.start()
            controlButton.setImage(UIImage(named: "stop"), for: .normal)
            print("Control button tapped: Timer started")
        }
        isRunning.toggle()
    }
    
    
    // Handle state changes in the game
        func handleStateChange(_ state: Ticker.GameState) {
            print("Handling state change to: \(state)")
            switch state {
                
            case .initial:
                break
                
            case .flip:
                // Deal cards and update card images
                dealtCards = gameManager.dealCards()
                guard let result = dealtCards else { return }
                self.player1CardImageView.image = UIImage(named: result.player1Card)
                self.player2CardImageView.image = UIImage(named: result.player2Card)
                print("State: Flip - player1Card: \(result.player1Card), player2Card: \(result.player2Card)")
                
            case .evaluate:
                // Evaluate the dealt cards and update scores
                guard let result = dealtCards else { return }
                let winner = gameManager.compareCards(card1: result.player1Card, card2: result.player2Card)
                updateScores(winner: winner)
                print("State: Evaluate - winner: \(winner)")

            case .scoreUpdate:
                // Reset card images and update round count
                self.player1CardImageView.image = UIImage(named: "back")
                self.player2CardImageView.image = UIImage(named: "back")
                player1ScoreLabel.font = UIFont.systemFont(ofSize: 17)
                player2ScoreLabel.font = UIFont.systemFont(ofSize: 17)
                roundCount += 1
                print("State: Score Update - Scores updated, roundCount: \(roundCount)")
                
            case .checkEnd:
                if roundCount >= maxRounds {
                    ticker.triggerGameEnd()
                    performSegue(withIdentifier: "showWinner", sender: self)
                } 
                print("State: Check End")
                
            case .gameEnd:
                print("State: Game End")
            }
        }
        
        // Update scores based on the game result
        func updateScores(winner: Int) {
            if winner == 1 {
                player1ScoreLabel.text = "\(Int(player1ScoreLabel.text!)! + 1)"
                player1ScoreLabel.font = UIFont.boldSystemFont(ofSize: 24)
                print("Player 1 wins this round")
            } else if winner == 2 {
                player2ScoreLabel.text = "\(Int(player2ScoreLabel.text!)! + 1)"
                player2ScoreLabel.font = UIFont.boldSystemFont(ofSize: 24)
                print("Player 2 wins this round")
            } else {
                print("This round is a draw")
            }
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             if segue.identifier == "showWinner" {
                 let destinationVC = segue.destination as! WinnerViewController
                 let player1Score = Int(player1ScoreLabel.text!)!
                 let player2Score = Int(player2ScoreLabel.text!)!
                 
                 if player2Score > player1Score {
                     destinationVC.winnerText = "Winner: \(player2NameLabel.text!)"
                 } else if player1Score > player2Score {
                     destinationVC.winnerText = "Winner: PC"
                 } else {
                     destinationVC.winnerText = "It's a Tie!"
                 }
                 destinationVC.scoreText = "Score: \(max(player1Score, player2Score))"
             }
         }
        
    }
