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

func inspectArray(inputList: [Int]) -> [Int:Int] {
    var tracker: [Int:Int] = [:]
    for char in inputList {
        if let count = tracker[char] {
            tracker[char] = count + 1
        } else {
            tracker[char] = 1
        }
    }
    return tracker
}

func compareDict(rollTracker: [Int:Int], userTracker: [Int:Int]) -> Bool {
    for (numUser, countUser) in userTracker { // iterate through user input
        if let rollNum = rollTracker[numUser] {// if the rollTracker has the user input
            if rollNum >= countUser {
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
    print("\t- First Turn -")
    print()
    let firstTurnNumbers = diceRoll(dice: 5) // call diceRoll function
    print("Roll: \t\(firstTurnNumbers.map { "\($0)" }.joined(separator: ", "))")
    print()
    if let diceSelection = diceChoice(prompt: "Choose the dice you would like to keep, type done to keep all dice: ") {
        switch diceSelection {
        case "":
            diceKept = []
            break
        case "done":
            print()
            diceKept = firstTurnNumbers
        default:
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
    print("\t- Second Turn -")
    let newRoll = diceConstant - diceKept2.count
    let secondTurnNumbers = diceRoll(dice: newRoll).sorted() // call diceRoll function
    if !diceKept2.isEmpty {
        print()
        print("Roll: \t\(diceKept2), \(secondTurnNumbers.map { "\($0)" }.joined(separator: ", "))")
        print()
    } else {
        print()
        print("Roll: \t\(secondTurnNumbers.map { "\($0)" }.joined(separator: ", "))")
        print()
    }
    if let diceSelection = diceChoice(prompt: "Choose the dice you would like to keep, type done to keep all dice: ") {
        switch diceSelection {
        case "":
            diceKept2 = []
            break
        case "done":
            print()
            diceKept2 += secondTurnNumbers
        default:
            var userKept2: [Int] = []
            for numString in diceSelection {
                if let num = Int(String(numString)) {
                    if secondTurnNumbers.contains(num) || diceKept.contains(num) {
                        userKept2.append(num)
                        let rollDict2 = inspectArray(inputList: secondTurnNumbers)
                        let userDict2 = inspectArray(inputList: userKept2)
                        let prevDict = inspectArray(inputList: diceKept)
                        let mergedDict = prevDict.merging(rollDict2) { (current, new) in
                            current + new // Add the current value and the new value
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
    print("\t- Third Turn -")
    print()
    let newRoll2 = diceConstant - diceKept3.count
    let thirdTurnNumbers = diceRoll(dice: newRoll2) // call diceRoll function
    for num in thirdTurnNumbers {
        diceKept3.append(num)
    }
    return diceKept3.sorted()
}

func main() {
    print("Welcome to not-Yahtzee!")
    let firstTurnResult = firstTurn().sorted()
    if firstTurnResult.count == 5 {
        print()
        print("Your turn is over. Final tally:", firstTurnResult.map { "\($0)" }.joined(separator: ", "))
        print()
        exit(0)
    }
    let secondTurnResult = secondTurn(diceKept: firstTurnResult).sorted()
    if secondTurnResult.count == 5 {
        print()
        print("Your turn is over. Final tally:", secondTurnResult.map { "\($0)" }.joined(separator: ", "))
        print()
        exit(0)
    }
    let thirdTurnResult = thirdTurn(diceKept2: secondTurnResult)
    print("Your turn is over. Final tally:", thirdTurnResult.map { "\($0)" }.joined(separator: ", "))
    print()
    exit(0)
}

main()
