//
//  ContentView.swift
//  stitchCounter
//
//  Created by Zaq on 8/20/24.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
    @Published var stitchCount: Int = 0
    @Published var variableNumber: Int = 1
    @Published var selectedVariableNumber: Int = 1
    @Published var rowCount: Int = 0
    @Published var rows: [[Int]] = []
    @Published var firstRowAdded: Bool = false
    @Published var hideRows: Bool = false
    @Published var optionsOpened: Bool = false
    @Published var showAlert: Bool = false
    @Published var showHeaderText: Bool = false
    @Published var showRowText: Bool = false
    @Published var lastIndex: Int?

    func updateStitchCount(_ count: Int) {
        stitchCount = count
    }
}

struct CustomTopButtons: ButtonStyle {
    var backgroundColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .buttonStyle(.plain)
            .background(backgroundColor.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .tint(backgroundColor)
            .controlSize(.extraLarge)
            .padding(20)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}

struct VariableNumberButton: View {
    var number: Int
    @ObservedObject var appState: AppState

    var body: some View {
        Button {
            appState.variableNumber = number
            appState.selectedVariableNumber = number
        } label: {
            Text("\(number)")
                .bold()
                .frame(width: 60, height: 60)
                .foregroundColor(appState.selectedVariableNumber == number ? Color.white : Color.blue)
        }
        .buttonStyle(.borderless)
        .background(appState.selectedVariableNumber == number ? Color.blue : Color.white)
        .clipShape(Circle())
        .controlSize(.extraLarge)
    }
}

struct CustomLargeButtons: ButtonStyle {
    var backgroundColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .buttonStyle(.plain)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}

struct CustomOptionsButtons: ButtonStyle {
    var backgroundColor: Color
    var foregroundColor: Color = Color.black.opacity(0.9)

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: 200, alignment: .center)
            .padding()
            .background(backgroundColor.opacity(configuration.isPressed ? 0.5 : 0.2))
            .foregroundColor(foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}

struct OptionsMenu: View {
    @ObservedObject var appState: AppState

    var body: some View {
        VStack (spacing: 5) {
            Button {
                appState.optionsOpened = false
                withAnimation {
                    appState.hideRows.toggle()
                }
                if appState.hideRows {
                    appState.showHeaderText = false
                    appState.showRowText = false
                }

            } label: {
                Text(appState.hideRows ? "Show Rows" : "Hide Rows")
            }
            .buttonStyle(CustomOptionsButtons(backgroundColor: .gray))

            Button {
                appState.optionsOpened = false
                if !appState.rows.isEmpty {
                    appState.rows.removeLast()
                    if appState.rows.isEmpty {
                        appState.firstRowAdded = false
                        appState.showHeaderText = false
                        appState.showRowText = false
                    } else {
                        withAnimation {
                            appState.hideRows = false
                        }
                    }
                } else {
                    appState.firstRowAdded = false
                }
                if appState.rowCount > 0 {
                    appState.rowCount -= 1
                }
            } label: {
                Text("Remove Row")
            }
            .buttonStyle(CustomOptionsButtons(backgroundColor: .gray))

            Button {
                appState.firstRowAdded = false
                appState.showHeaderText = false
                appState.showRowText = false
                appState.hideRows = false
                appState.optionsOpened = false
                appState.rows.removeAll()
                appState.rowCount = 0
                appState.variableNumber = 1
                appState.selectedVariableNumber = 1
                appState.stitchCount = 0
            } label: {
                Text("Reset All")
            }
            .buttonStyle(CustomOptionsButtons(backgroundColor: .red))

            Button {
                appState.optionsOpened.toggle()
            } label: {
                Text("Cancel")
            }
            .buttonStyle(CustomOptionsButtons(backgroundColor: .gray))
        }
        .padding()
        //.background(Color.gray.opacity(0.8))
        .cornerRadius(10)
        //.frame(maxWidth: 300)
    }
}

struct ContentView_macOS: View {
    @ObservedObject var appState = AppState()

    var showBottomRow: [String] {[
        appState.rows.description,
        appState.showRowText.description
    ]}

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack {
            VStack {
                // Add and subtract buttons
                HStack {
                    Button {
                        if appState.stitchCount > appState.variableNumber {
                            appState.stitchCount -= appState.variableNumber
                        } else {
                            appState.stitchCount = 0
                        }
                    } label: {
                        Image(systemName: "minus")
                            .frame(width: 80, height: 80)
                    }
                    .buttonStyle(CustomTopButtons(backgroundColor: .red))

                    Spacer()

                    Button {
                        appState.stitchCount += appState.variableNumber
                    } label: {
                        Image(systemName: "plus")
                            .frame(width: 80, height: 80)
                    }
                    .buttonStyle(CustomTopButtons(backgroundColor: .green))
                }

                Spacer()

                // Main text/count
                Text("Stitch Count")
                    .padding(.bottom, 10)
                    .font(.largeTitle)
                Text("\(appState.stitchCount)")
                    .font(.largeTitle)

                Spacer()

                // variableNumber selection
                HStack (spacing: 20) {
                    VariableNumberButton(number: 1, appState: appState)
                    VariableNumberButton(number: 3, appState: appState)
                    VariableNumberButton(number: 5, appState: appState)
                    VariableNumberButton(number: 10, appState: appState)
                }

                VStack (spacing: 0) {
                    // New Row and Options buttons
                    HStack (spacing: 5) {
                        Button {
                            addNewRow()
                            withAnimation {
                                appState.firstRowAdded = true
                            }
                        } label: {
                            Text("New Row")
                        }
                        .buttonStyle(CustomLargeButtons(backgroundColor: .blue))

                        Button {
                            appState.optionsOpened.toggle()
                        } label: {
                            Text("Options")
                        }
                        .buttonStyle(CustomLargeButtons(backgroundColor: .green))
                    }
                    .padding(5)

                    // Show the bottom section if the rows are not hidden and there is an existing row
                    if !appState.hideRows {
                        if appState.firstRowAdded {
                            // Row and Stitches header
                            HStack {
                                if appState.showHeaderText {
                                    Text("Row")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .transition(.opacity)
                                        .animation(.easeIn(duration: 0.1), value: appState.showHeaderText)
                                    Text("Stitches")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .transition(.opacity)
                                        .animation(.easeIn(duration: 0.1), value: appState.showHeaderText)
                                }
                            }
                            .padding([.top, .bottom])
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onAppear {
                                // Delay the start of the text animation
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation {
                                        appState.showHeaderText = true
                                    }
                                }
                            }

                            // Stitch tracker
                            withAnimation {
                                ScrollViewReader { proxy in
                                    ScrollView {
                                        LazyVGrid(columns: columns, spacing: 10) {
                                            ForEach(appState.rows.indices, id: \.self) { index in
                                                Text("\(appState.rows[index][0])")
                                                    .font(.headline)
                                                    .frame(maxWidth: .infinity, alignment: .center)
                                                    .id(index)
                                                    .padding()
                                                    .opacity(appState.showRowText ? 1 : 0)
                                                    .animation(.easeIn(duration: 0.2), value: appState.showRowText)

                                                Text("\(appState.rows[index][1])")
                                                    .font(.headline)
                                                    .frame(maxWidth: .infinity, alignment: .center)
                                                    .padding()
                                                    .opacity(appState.showRowText ? 1 : 0)
                                                    .animation(.easeIn(duration: 0.2), value: appState.showRowText)
                                            }
                                        }
                                        .onChange(of: showBottomRow) {
                                            // Scroll to the bottom when rows change
                                            if let lastIndex = appState.rows.indices.last {
                                                withAnimation {
                                                    proxy.scrollTo(lastIndex, anchor: .bottom)
                                                }
                                            }
                                        }
                                    }
                                }
                                .frame(maxHeight: 177)
                                .onAppear {
                                    // Trigger grid text animation after the view appears
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        withAnimation {
                                            appState.showRowText = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .frame(minWidth: 600, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity)

            if appState.optionsOpened {
                Color.black.opacity(0.4) // Background dimming
                    .ignoresSafeArea()
                    .onTapGesture {
                        appState.optionsOpened = false // Close when tapping outside
                    }

                // Show the OptionsMenu as an overlay
                OptionsMenu(appState: appState)
                    .frame(width: 250, height: 250) // Set size for the options menu
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 20)
                    .padding()
            }
        }
    }

    private func addNewRow() {
        let newRow = [appState.rowCount + 1, appState.stitchCount]
        appState.rows.append(newRow)
        appState.rowCount += 1

        // Reset the view after new row
        appState.variableNumber = 1
        appState.selectedVariableNumber = 1
        appState.stitchCount = 0
    }
}

#Preview {
    ContentView_macOS()
}
