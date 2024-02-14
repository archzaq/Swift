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

func getInput(prompt: String) -> Double? {
    print(prompt, terminator: "")
    if let input = readLine(), let number = Double(input) {
        return number
    } else {
        return nil
    }
}

func menuChoice(prompt: String) -> String? {
    print(prompt, terminator: "")
    if let choice = readLine() {
        return choice
    } else {
        return nil
    }
}

func grabNumbers() -> (Double, Double)? {
    if let firstNumber = getInput(prompt: "Enter the first number: ") {
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

let additionList: [String] = ["Add", "add", "Addition", "addition", "sum", "Sum", "1", "+"]

let subtractionList: [String] = ["Subtract", "subtract", "Subtraction", "subtraction", "sub", "Sub", "2", "Difference", "difference", "-"]

let multiplicationList: [String] = ["Multiply", "multiply", "Multiplication", "multiplication", "mult", "Mult", "3", "*"]

let divisionList: [String] = ["Divide", "divide", "Division", "division", "div", "Div", "4", "/"]

func menu() {
    print()
    print("\t1: Addition")
    print("\t2: Subtraction")
    print("\t3: Multiplication")
    print("\t4: Division")
    print()
}

func main() {
    var run: Bool = true
    print("Welcome to my calculator!")
    while run {
        menu()
        if let selection = menuChoice(prompt: "Please choose from the menu:") {
            if selection == "" {run = false}
            if additionList.contains(selection) {
                print()
                print("\tAddition")
                print()
                if let (lhs, rhs) = grabNumbers() {
                    print()
                    print("The sum is", addition(lhs, rhs))
                    print()
                }
            } else if subtractionList.contains(selection) {
                print()
                print("\tSubtraction")
                print()
                if let (lhs, rhs) = grabNumbers() {
                    print()
                    print("The difference is", subtraction(lhs, rhs))
                    print()
                }
            } else if multiplicationList.contains(selection) {
                print()
                print("\tMultiplication")
                print()
                if let (lhs, rhs) = grabNumbers() {
                    print()
                    print("The product is", multiplication(lhs, rhs))
                    print()
                }
                //multiplicationAction()
            } else if divisionList.contains(selection) {
                print()
                print("\tDivision")
                print()
                if let (lhs, rhs) = grabNumbers() {
                    print()
                    print("The quotent is", division(lhs, rhs))
                    print()
                }
            }
        }
    }
}

main()
