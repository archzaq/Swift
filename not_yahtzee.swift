//
//  main.swift
//  yahtzee
//
//  Created by Zaq on 2/20/24.
//

import Foundation

let diceConstant: Int = 5

// take user input as string
func choice(prompt: String) -> String? {
    print(prompt, terminator: "")
    if let userChoice = readLine() {
        return userChoice
    } else {
        return nil
    }
}

// takes a list, adds it to a dictonary with the value being the count
func inspectArray(inputList: [Int]) -> [Int:Int] {
    var tracker: [Int:Int] = [:]
    for number in inputList {
        if let countValue = tracker[number] {
            tracker[number] = countValue + 1
        } else {
            tracker[number] = 1
        }
    }
    return tracker
}

// compares two dictonaries and returns true if the
// value count in the first dictTracker is greater than or equal to the value count of the second
func compareDict(rollTracker: [Int:Int], userTracker: [Int:Int]) -> Bool {
    for (numUser, countUser) in userTracker { // iterate through user input
        if let rollNum = rollTracker[numUser] {// if the rollTracker has the user input
            if rollNum >= countUser { // if rollTracker value count is ge user input value count
                continue
            } else {
                return false
            }
        } else {
            return false
        }
    }
    return true
}

// rolls a dice, the number of dice determined by diceRoll(dice: Int)
// returns an array of the results of each dice
func diceRoll(dice: Int) -> [Int] {
    var output: [Int] = []
    if dice > 5 {
        print("Too many dice")
        exit(1)
    }
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
    print("\t- First Roll -")
    print()
    let firstTurnNumbers = diceRoll(dice: 5) // call diceRoll function
    print("Roll: \t\(firstTurnNumbers.map { "\($0)" }.joined(separator: ", "))") // display roll
    print()
    if let diceSelection = choice(prompt: "Choose the dice you would like to keep, type done to keep all dice: ") { // get user input
        switch diceSelection {
        case "": // if no user input, save no dice
            diceKept = []
        case "done": // if user input is done, save all dice
            print()
            diceKept = firstTurnNumbers
        default: // check user input for Int, check each Int for valid input against the current dice
            for numString in diceSelection {
                if let num = Int(String(numString)) {
                    if firstTurnNumbers.contains(num) {
                        diceKept.append(num)
                        let rollDict = inspectArray(inputList: firstTurnNumbers)
                        let userDict = inspectArray(inputList: diceKept)
                        if compareDict(rollTracker: rollDict, userTracker: userDict) {
                            continue
                        } else {
                            print()
                            print("Please provide the correct number of dice, none kept.")
                            diceKept = []
                        }
                    }
                }
            }
        }
    }
    return diceKept
}

func secondTurn(diceKept: [Int]) -> [Int] {
    var diceKept2 = diceKept
    print()
    print("\t- Second Roll -")
    let newRoll = diceConstant - diceKept2.count
    let secondTurnNumbers = diceRoll(dice: newRoll).sorted() // call diceRoll function
    if !diceKept2.isEmpty {
        print()
        print("Roll: \t\(diceKept2), \(secondTurnNumbers.map { "\($0)" }.joined(separator: ", "))") // if dice saved, show them with the roll
        print()
    } else {
        print()
        print("Roll: \t\(secondTurnNumbers.map { "\($0)" }.joined(separator: ", "))") // if no dice saved, show roll
        print()
    }
    if let diceSelection = choice(prompt: "Choose the dice you would like to keep, type done to keep all dice: ") { // get user input
        switch diceSelection {
        case "": // if no user input, save no dice
            diceKept2 = []
        case "done": // if user input is done, save all dice
            print()
            diceKept2 += secondTurnNumbers
        default: // check user input for Int, check each Int for valid input against the current dice
            var userKept2: [Int] = []
            for numString in diceSelection {
                if let num = Int(String(numString)) {
                    if secondTurnNumbers.contains(num) || diceKept.contains(num) {
                        userKept2.append(num)
                        let rollDict2 = inspectArray(inputList: secondTurnNumbers)
                        let userDict2 = inspectArray(inputList: userKept2)
                        let prevDict = inspectArray(inputList: diceKept)
                        let mergedDict = prevDict.merging(rollDict2) { (current, new) in // barely understand the syntax of merging dictonaries
                            current + new
                        }
                        if compareDict(rollTracker: mergedDict, userTracker: userDict2) {
                            diceKept2 = userKept2
                        } else {
                            print()
                            print("Please provide the correct number of dice, previous saved dice kept.")
                        }
                    }
                }
            }
        }
    }
    return diceKept2
}

func thirdTurn(diceKept2: [Int]) -> [Int] {
    var diceKept3 = diceKept2
    print()
    print("\t- Third Roll -")
    print()
    let newRoll2 = diceConstant - diceKept3.count
    let thirdTurnNumbers = diceRoll(dice: newRoll2) // call diceRoll function
    for num in thirdTurnNumbers {
        diceKept3.append(num)
    }
    return diceKept3.sorted()
}

func play(playerInt: Int) -> [Int] {
    print()
    print("------- Player \(playerInt) -------")
    let firstTurnResult = firstTurn().sorted()
    if firstTurnResult.count == 5 {
        print()
        print("Your turn is over. Final tally:", firstTurnResult.map { "\($0)" }.joined(separator: ", "))
        print()
        return firstTurnResult
    }
    let secondTurnResult = secondTurn(diceKept: firstTurnResult).sorted()
    if secondTurnResult.count == 5 {
        print()
        print("Your turn is over. Final tally:", secondTurnResult.map { "\($0)" }.joined(separator: ", "))
        print()
        return secondTurnResult
    }
    let thirdTurnResult = thirdTurn(diceKept2: secondTurnResult)
    print("Your turn is over. Final tally:", thirdTurnResult.map { "\($0)" }.joined(separator: ", "))
    print()
    return thirdTurnResult
}

func main() {
    print("Welcome to not-Yahtzee!")
    print()
    if let playersInput = choice(prompt: "How many players? ") {
        switch playersInput {
        case "":
            exit(0)
        default:
            var playerInt: Int = 0
            if playersInput.count == 1, let playerNum = Int(playersInput) {
                for _ in 1...playerNum {
                    playerInt += 1
                    let _ = play(playerInt: playerInt)
                    let _ = choice(prompt: "Press enter to continue")
                }
            }
        }
    }
}

main()
