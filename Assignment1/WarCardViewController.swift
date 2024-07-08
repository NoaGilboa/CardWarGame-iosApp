
import UIKit

class WarCardViewController: UIViewController {
    
    // UI elements
    @IBOutlet weak var player1ScoreLabel: UILabel!
    @IBOutlet weak var player2ScoreLabel: UILabel!
    @IBOutlet weak var player1CardImageView: UIImageView!
    @IBOutlet weak var player2CardImageView: UIImageView!
    @IBOutlet weak var controlButton: UIButton!
    @IBOutlet weak var timer: UILabel!
    
    // Game manager and ticker for game state management
    var gameManager: GameManager
    var ticker: Ticker
    var isRunning: Bool = true
    var roundCount: Int = 0
    let maxRounds = 5
    
    // Initializer to create instances of GameManager and Ticker
    required init?(coder: NSCoder) {
        gameManager = GameManager()
        ticker = Ticker()
        super.init(coder: coder)
    }
    
    // Setup UI and start ticker when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set initial scores
          player1ScoreLabel.text = "0"
          player2ScoreLabel.text = "0"
          
          // Set initial card images to back of the card
          player1CardImageView.image = UIImage(named: "back")
          player2CardImageView.image = UIImage(named: "back")
          
          // Set initial button image to stop
          controlButton.setImage(UIImage(named: "stop"), for: .normal)
          
          // Ensure constraints are set
          setConstraints()
          
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
            // Initial setup if needed
            break
            
        case .flip:
            // Deal cards and update card images
            let result = gameManager.dealCards()
            player1CardImageView.image = UIImage(named: result.player1Card)
            player2CardImageView.image = UIImage(named: result.player2Card)
            print("State: Flip - player1Card: \(result.player1Card), player2Card: \(result.player2Card)")
            
        case .evaluate:
            // Evaluate the dealt cards and update scores
            let result = gameManager.evaluateCards()
            updateScores(result: result)
            print("State: Evaluate - winner: \(result.winner)")
            
        case .scoreUpdate:
            // Reset card images and update round count
            player1CardImageView.image = UIImage(named: "back")
            player2CardImageView.image = UIImage(named: "back")
            player1ScoreLabel.font = UIFont.systemFont(ofSize: 17)
            player2ScoreLabel.font = UIFont.systemFont(ofSize: 17)
            roundCount += 1
            print("State: Score Update - Scores updated, roundCount: \(roundCount)")
            
        case .checkEnd:
            if roundCount >= maxRounds {
                ticker.triggerGameEnd()
                performSegue(withIdentifier: "showWinner", sender: self)
            } else {
                ticker.updateStateTo(state.nextState)
            }
            print("State: Check End")
            
        case .gameEnd:
            print("State: Game End")
        }
    }
    
    // Update scores based on the game result
    func updateScores(result: (winner: Int, player1Card: String, player2Card: String)) {
        if result.winner == 1 {
            player1ScoreLabel.text = "\(Int(player1ScoreLabel.text!)! + 1)"
            player1ScoreLabel.font = UIFont.boldSystemFont(ofSize: 24)
            print("Player 1 wins this round")
        } else if result.winner == 2 {
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
             
             if player1Score > player2Score {
                 destinationVC.winnerText = "Winner: Gabi"
             } else if player2Score > player1Score {
                 destinationVC.winnerText = "Winner: PC"
             } else {
                 destinationVC.winnerText = "It's a Tie!"
             }
             destinationVC.scoreText = "Score: \(max(player1Score, player2Score))"
         }
     }
    
    func setConstraints() {
        player1CardImageView.translatesAutoresizingMaskIntoConstraints = false
        player2CardImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            player1CardImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            player1CardImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),

            player2CardImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            player2CardImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),

            player2CardImageView.leadingAnchor.constraint(equalTo: player1CardImageView.trailingAnchor, constant: 20)
        ])
    }
}
