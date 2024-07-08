
# iOS Card Game Application

This project is an iOS application written in Swift, featuring a card game. The application includes multiple view controllers, a game manager, location requests, and shared preferences for storing user information.

## Features
- **Login System**: Users can log in to the app using their credentials.
- **Card Game**: A card game that includes different view controllers to manage the game flow.
- **Winner Screen**: Displays the winner and the score after the game ends.
- **Location Requests**: The app requests the user's location to enhance gameplay features.
- **Shared Preferences**: Stores user information such as the user's name for a personalized experience.

## Installation

1. **Clone the repository**:
    ```bash
    git clone https://github.com/yourusername/ios-card-game.git
    cd ios-card-game
    ```

2. **Open in Xcode**:
    Open `ios-card-game.xcodeproj` or `ios-card-game.xcworkspace` in Xcode.

3. **Build and Run**:
    Select the target device or simulator and press `Cmd + R` to build and run the project.

## Usage

1. **Launch the app**.
2. **Log in** using your credentials.
3. **Play the card game**.
4. View the **results** on the Winner screen.

### Location Requests

The application requests the user's location to provide location-based features within the game. Ensure that you grant the necessary permissions when prompted. The location data is used to enhance the user experience and is not shared with third parties.

### Shared Preferences

The application uses shared preferences to store the user's name and other preferences locally on the device. This allows the app to personalize the user experience by greeting the user by name and remembering their settings.

## File Descriptions

- `Ticker.swift`: Handles the ticker functionality used in the app.
- `WarCardViewController.swift`: Manages the main gameplay interface.
- `WinnerViewController.swift`: Displays the winner and score after the game ends.
- `GameManager.swift`: Contains the logic for managing the game, including score calculation and determining the winner.
- `LoginViewController.swift`: Manages the login interface and handles user authentication.
- `Info.plist`: Contains configuration information for the app.

## Vudeo from the app

https://github.com/NoaGilboa/ios-HW1/assets/143444119/8affc2f6-2c4e-402f-a003-1ec3d68339b8

