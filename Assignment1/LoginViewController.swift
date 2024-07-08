import UIKit
import CoreLocation
import Foundation
class LoginViewController: UIViewController, CLLocationManagerDelegate {
    
    // UI elements
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startGameButton: UIButton!
    var nameComponents = PersonNameComponents()
    @IBOutlet weak var westImage: UIImageView!
    @IBOutlet weak var eastImage: UIImageView!
    // Location manager
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title of the view controller
        self.title = "Enter Name and Location"
        
        // Check if a name is already stored
        if let savedName = UserDefaults.standard.string(forKey: "playerName") {
            instructionLabel.text = "Hi \(savedName)"
            nameTextField.isHidden = true
        } else {
            // Set the instruction text
            instructionLabel.text = "Please enter your name and allow location access"
            nameTextField.delegate = self
            nameTextField.placeholder = "Enter your name"
            nameTextField.autocorrectionType = .no
            nameTextField.borderStyle = .line
            nameTextField.addTarget(self, action: #selector(nameTextFieldDidChange), for: .editingChanged)
        }
        
        // Set up location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // Request location access
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // Action for start game button
    @IBAction func startGameTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty else {
           showAlert(title: "Error", message: "Please enter your name")
           return
       }
       // Save name and proceed with starting the game
        validate(components: nameComponents)
   }
    
    // Location manager delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            locationManager.stopUpdatingLocation()
            updateUIBasedOnLocation(latitude: location.coordinate.latitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location access granted")
        case .denied, .restricted:
            showAlert(title: "Error", message: "Location access denied. Please enable location services in settings.")
        case .notDetermined:
            print("Location access not determined")
        @unknown default:
            fatalError()
        }
    }
    
    // Update UI based on the location
    func updateUIBasedOnLocation(latitude: Double) {
        let boundaryLatitude: Double = 34.817549168324334
        if latitude > boundaryLatitude {
            westImage.isHidden=true
        } else {
            eastImage.isHidden=true
        }
    }
    
    
    // Helper function to show an alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func nameTextFieldDidChange() {
        if let name = nameTextField.text {
            nameComponents.givenName = name
        }
        print(nameComponents.debugDescription)
    }
    
    func validate(components: PersonNameComponents) {
        guard let name = components.givenName, !name.isEmpty else {
            showAlert(title: "Error", message: "Please enter your name")
            return
        }
        nameTextField.text = name
        // Save name and proceed with starting the game
        UserDefaults.standard.set(name, forKey: "playerName")
         instructionLabel.text = "Hi \(name)"
         nameTextField.isHidden = true
        performSegue(withIdentifier: "startGame", sender: self)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        validate(components: nameComponents)
        return true
    }
}
