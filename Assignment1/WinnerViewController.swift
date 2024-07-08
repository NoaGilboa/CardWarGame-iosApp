import UIKit

class WinnerViewController: UIViewController {
    
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var winnerScoreLabel: UILabel!
    @IBOutlet weak var backToMenuButton: UIButton!
    
    var winnerText: String?
    var scoreText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the background image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background_winner")!)
        // Set the text for the winner and score labels
        winnerLabel.text = winnerText
        winnerScoreLabel.text = scoreText
        
        // Set the title for the back to menu button
        backToMenuButton.setTitle("Back to Menu", for: .normal)
    }
    
    @IBAction func backToMenuTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "back", sender: self)
    }
}
