import UIKit

class WinnerViewController: UIViewController {
    
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var winnerScoreLabel: UILabel!
    @IBOutlet weak var backToMenuButton: UIButton!
    
    var winnerText: String?
    var scoreText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        winnerLabel.text = winnerText
        winnerScoreLabel.text = scoreText
    }
    
    @IBAction func backToMenuTapped(_ sender: UIButton) {
        // Implement logic to go back to the main menu
        self.dismiss(animated: true, completion: nil)
    }
}
