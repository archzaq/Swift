//
//  main.swift
//  calc
//
//  Created by Zaq on 2/12/24.
//

import Foundation

func addition(_ left: Double, _ right: Double) -> Double {
    return left + right
}

func subtraction(_ left: Double, _ right: Double) -> Double {
    return left - right
}

func multiplication(_ left: Double, _ right: Double) -> Double {
    return left * right
}

func division(_ left: Double, _ right: Double) -> Double {
    return left / right
}

func menu() {
    print()
    print("\t1: Addition")
    print("\t2: Subtraction")
    print("\t3: Multiplication")
    print("\t4: Division")
    print()
}

// Take user input, convert to double, and return double; returning nil if invalid
func getInput(prompt: String) -> Double? {
    print(prompt, terminator: "")
    if let input = readLine(), let number = Double(input) {
        return number
    } else {
        return nil
    }
}

// Take user input, keep as string, and return string; returning nil if invalid
func menuChoice(prompt: String) -> String? {
    print(prompt, terminator: "")
    if let choice = readLine() {
        return choice
    } else {
        return nil
    }
}

// Take user input for each number using getInput() function; returning nil if invalid
func grabNumbers(_ total: Double) -> (Double, Double)? {
    if let firstNumber = getInput(prompt: "Enter the number: ") {
        if total != 0 {
            return (total, firstNumber)
        }
        if let secondNumber = getInput(prompt: "Enter the second number: ") {
            return (firstNumber, secondNumber)
        } else {
            print("Error, enter a valid second number.")
            return nil
        }
    } else {
        print("Error, enter a valid first number.")
        return nil
    }
}

// List of acceptable menu choices for addition
let additionSet: Set<String> = ["Add", "add", "Addition", "addition", "sum", "Sum", "1", "+"]

// List of acceptable menu choices for subtraction
let subtractionSet: Set<String> = ["Subtract", "subtract", "Subtraction", "subtraction", "sub", "Sub", "2", "Difference", "difference", "-"]

// List of acceptable menu choices for multiplication
let multiplicationSet: Set<String> = ["Multiply", "multiply", "Multiplication", "multiplication", "mult", "Mult", "3", "*", "Product", "product"]

// List of acceptable menu choices for division
let divisionSet: Set<String> = ["Divide", "divide", "Division", "division", "div", "Div", "4", "/", "Quotent", "quotent"]

let quitSet: Set<String> = ["Exit", "exit", "Quit", "quit", "Ex", "ex", "Q", "q", ""]

func main() {
    var run: Bool = true
    var total: Double = 0.0
    print("Welcome to my calculator!")
    while run {
        menu()
        if let selection = menuChoice(prompt: "Please choose from the menu: ") {
            if additionSet.contains(selection) {
                print()
                print("\tAddition")
                print()
                if let (lhs, rhs) = grabNumbers(total) {
                    let sum = addition(lhs, rhs)
                    if total != 0 {
                        total += rhs
                    } else {
                        total += sum
                    }
                    print()
                    print("The sum of \(lhs) and \(rhs) is", sum)
                    print("Current Total:", total)
                }
            } else if subtractionSet.contains(selection) {
                print()
                print("\tSubtraction")
                print()
                if let (lhs, rhs) = grabNumbers(total) {
                    let difference = subtraction(lhs, rhs)
                    if total != 0 {
                        total -= rhs
                    } else {
                        total -= difference
                    }
                    print()
                    print("The difference between \(lhs) and \(rhs) is", difference)
                    print("Current Total:", total)
                }
            } else if multiplicationSet.contains(selection) {
                print()
                print("\tMultiplication")
                print()
                if let (lhs, rhs) = grabNumbers(total) {
                    let product = multiplication(lhs, rhs)
                    if total != 0 {
                        total *= rhs
                    } else {
                        total = product
                    }
                    print()
                    print("The product of \(lhs) and \(rhs) is", product)
                    print("Current Total:", total)
                }
            } else if divisionSet.contains(selection) {
                print()
                print("\tDivision")
                print()
                if let (lhs, rhs) = grabNumbers(total) {
                    guard rhs != 0 else {
                        print()
                        print("Error: Cannot divide by 0. You know this, m8.")
                        if total != 0 {
                            print("Current Total:", total)
                        }
                        continue
                    }
                    let quotent = division(lhs, rhs)
                    if total != 0 {
                        total /= rhs
                    } else {
                        total /= quotent
                    }
                    print()
                    print("The quotent of \(lhs) and \(rhs) is", quotent)
                    print("Current Total:", total)
                }
            } else if selection == "Clear" || selection == "clear" {
                print()
                print("Total cleared")
                total = 0.0
            } else if quitSet.contains(selection) {
                if total != 0 {
                    print()
                    print("Ending Total:", total)
                    print()
                } else {
                    print("See ya!")
                }
                run = false
            } else {
                print()
                print("Please choose a valid option from the list.")
            }
        }
    }
}

main()
