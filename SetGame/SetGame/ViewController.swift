//
//  ViewController.swift
//  SetGame
//
//  Created by Yeh, Louis on 2018/4/26.
//  Copyright © 2018年 Yeh, Louis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        resetGame()
        updateUI()
    }

    @IBOutlet weak var scoreLable: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    @IBAction func touchCardButton(_ sender: UIButton) {
        guard let cardIndex = cardButtonMapping[sender] else {
            return
        }
        setGame.selectCard(of: cardIndex)
        updateUI()
    }
    @IBAction func touchNewGame(_ sender: UIButton) {
        resetGame()
        updateUI()
    }
    @IBAction func touchDraw3Cards(_ sender: UIButton) {
        guard (cardButtons.filter({ cardButtonMapping[$0] == nil }).count >= 3) else {
            print("No more room for new cards")
            return
        }
        cardIndexesNeedAButton = setGame.draw3Cards()
        updateUI()
    }
    private lazy var setGame = SetGame(with: SetGame.numberOfCardOnBoardInitial)
    private var cardButtonMapping = [UIButton: Int]()
    private var cardIndexesNeedAButton = [Int]()

    private func updateUI() {
        // Update mapping table
            // Insert cards if there are cards need to be paired
        while let cardIndex = cardIndexesNeedAButton.draw() {
            if let buttonWithMatchedCard = getButtonWithMatchedCard() {
                cardButtonMapping[buttonWithMatchedCard] = cardIndex
                continue
            }
            if let buttonWithoutCard = getButtonWithoutCard() {
                cardButtonMapping[buttonWithoutCard] = cardIndex
                continue
            }
        }
            // Remove pairs with matched cards
        while let buttonWithMatchedCard = getButtonWithMatchedCard() {
            cardButtonMapping[buttonWithMatchedCard] = nil
        }

        // Update button display
        for button in cardButtons {
            if let cardIndex = cardButtonMapping[button] {
                // Checking the cards seleted or not (not sure whether this should be out of this loop)
                if setGame.cardsSelected.contains(cardIndex) {
                    button.layer.borderWidth = 3.0
                    button.layer.borderColor = UIColor.blue.cgColor
                } else {
                    button.layer.borderWidth = 0
                }
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                button.setAttributedTitle(setGame.cards[cardIndex].cardPatternString, for: .normal)
            } else {
                button.layer.borderWidth = 0
                button.setTitle("", for: .normal)
                button.setAttributedTitle(NSAttributedString(string: ""), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
            }
        }
        // Update score
        scoreLable.text = "Score: \(setGame.cardsMatched.count)"
    }
    private func getButtonWithMatchedCard() -> UIButton? {
        return cardButtonMapping.filter({ setGame.cardsMatched.contains($0.value) }).first?.key
    }
    private func getButtonWithoutCard() -> UIButton? {
        return cardButtons.filter({ cardButtonMapping[$0] == nil }).first
    }
    private func resetGame() {
        cardButtonMapping = [UIButton: Int]()
        setGame = SetGame(with: SetGame.numberOfCardOnBoardInitial)
        cardIndexesNeedAButton = setGame.cardsUnselected
    }
}

