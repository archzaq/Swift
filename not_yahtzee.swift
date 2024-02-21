//
//  main.swift
//  yahtzee
//
//  Created by Zaq on 2/20/24.
//

import Foundation

let diceConstant: Int = 5

func diceChoice(prompt: String) -> String? {
    print(prompt, terminator: "")
    if let choice = readLine() {
        return choice
    } else {
        return nil
    }
}

// rolls a dice, the number of dice determined by diceRoll(dice: Int)
// returns an array of the results of each dice
func diceRoll(dice: Int) -> [Int] {
    var output: [Int] = []
    for _ in 0..<dice {
        let randomNumber = Int(arc4random_uniform(6)) + 1
        output.append(randomNumber)
    }
    return output
}

// roll 5 dice, then ask which you would like to keep
func firstTurn() -> [Int] {
    var diceKept: [Int] = []
    print()
    print("\t- First Turn -")
    print()
    let firstTurnNumbers = diceRoll(dice: 5) // call diceRoll function
    print("Roll: \t\(firstTurnNumbers.map { "\($0)" }.joined(separator: ", "))")
    print()
    if let diceSelection = diceChoice(prompt: "Choose the dice you would like to keep, type done to keep all dice, or press enter to roll all dice again: ") {
        switch diceSelection {
        case "":
            diceKept = []
            break
        case "done":
            diceKept = firstTurnNumbers
        default:
            for numString in diceSelection {
                if let num = Int(String(numString)) {
                    diceKept.append(num)
                }
            }
        }
    }
    return diceKept
}

func secondTurn(diceKept: [Int]) -> [Int] {
    var diceKept2 = diceKept
    print()
    print("\t- Second Turn -")
    let newRoll = diceConstant - diceKept2.count
    let secondTurnNumbers = diceRoll(dice: newRoll) // call diceRoll function
    if !diceKept2.isEmpty {
        print()
        print("Roll: \t\(diceKept2.map { "\($0)" }.joined(separator: ", ")), \(secondTurnNumbers.map { "\($0)" }.joined(separator: ", "))")
        print()
    } else {
        print()
        print("Roll: \t\(secondTurnNumbers.map { "\($0)" }.joined(separator: ", "))")
        print()
    }
    if let diceSelection = diceChoice(prompt: "Choose the dice you would like to keep, type done to keep all dice, or press enter to roll all dice again: ") {
        switch diceSelection {
        case "":
            diceKept2 = []
            break
        case "done":
            diceKept2 += secondTurnNumbers
        default:
            diceKept2 = []
            for numString in diceSelection {
                if let num = Int(String(numString)) {
                    diceKept2.append(num)
                }
            }
        }
    }
    return diceKept2
}

func thirdTurn(diceKept2: [Int]) -> [Int] {
    var diceKept3 = diceKept2
    print()
    print("\t- Third Turn -")
    print()
    let newRoll2 = diceConstant - diceKept3.count
    let thirdTurnNumbers = diceRoll(dice: newRoll2) // call diceRoll function
    diceKept3 += thirdTurnNumbers
    return diceKept3
}

func main() {
    print("Welcome to not-Yahtzee!")
    let firstTurnResult = firstTurn()
    if firstTurnResult.count == 5 {
        print("Your turn is over. You have:", firstTurnResult.map { "\($0)" }.joined(separator: ", "))
        print()
        exit(0)
    }
    let secondTurnResult = secondTurn(diceKept: firstTurnResult)
    if secondTurnResult.count == 5 {
        print("Your turn is over. You have:", secondTurnResult.map { "\($0)" }.joined(separator: ", "))
        print()
        exit(0)
    }
    let thirdTurnResult = thirdTurn(diceKept2: secondTurnResult)
    print("Your turn is over. You have:", thirdTurnResult.map { "\($0)" }.joined(separator: ", "))
    print()
    exit(0)
}

main()
