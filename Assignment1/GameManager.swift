import Foundation

class GameManager {
    // Array representing the deck of cards
    private var deck: [String] = []
    
    // Initializer to create a deck of cards when GameManager is instantiated
    init() {
        self.deck = createDeck()
    }
    
    // Function to create a new deck of cards
    func createDeck() -> [String] {
        // Suits and ranks for the cards
        let suits = ["hearts", "diamonds", "clubs", "spades"]
        let ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
        var deck = [String]()
        
        // Nested loops to generate each card in the deck
        for suit in suits {
            for rank in ranks {
                deck.append("\(rank)_of_\(suit)") // Append each card to the deck
            }
        }
        deck.shuffle() // Shuffle the deck
        return deck
    }
    
    // Function to deal cards to two players
    func dealCards() -> (player1Card: String, player2Card: String) {
        // If the deck has fewer than 2 cards, create a new deck
        if deck.count < 2  {
            deck = createDeck()
        }
        
        // Remove the first two cards from the deck and assign them to the players
        let player1Card = deck.removeFirst()
        let player2Card = deck.removeFirst()
        
        return (player1Card, player2Card) // Return the dealt cards
    }
    
    // Function to evaluate the dealt cards and determine the winner
    func evaluateCards() -> (winner: Int, player1Card: String, player2Card: String) {
        let result = dealCards() // Deal cards to the players
        let winner = compareCards(card1: result.player1Card, card2: result.player2Card) // Compare the dealt cards to determine the winner
        return (winner, result.player1Card, result.player2Card) // Return the result
    }
    
    // Function to compare the ranks of two cards
    func compareCards(card1: String, card2: String) -> Int {
        // Dictionary to map card ranks to their respective values
        let cardRank = ["2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "10": 10, "J": 11, "Q": 12, "K": 13, "A": 14]
        // Extract the rank of each card
        let rank1 = cardRank[String(card1.split(separator: "_")[0])]!
        let rank2 = cardRank[String(card2.split(separator: "_")[0])]!
        
        // Compare the ranks and return the winner
        if rank1 > rank2 {
            return 1 // Player 1 wins
        } else if rank2 > rank1 {
            return 2 // Player 2 wins
        } else {
            return 0 // Tie
        }
    }
}
