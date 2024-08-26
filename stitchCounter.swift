//
//  ContentView.swift
//  stitchCounter
//
//  Created by Zaq on 8/20/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var stitchCount: Int = 0
    @State private var variableNumber: Int = 1
    @State private var selectedVariableNumber: Int = 1
    @State private var rowCount: Int = 0
    @State private var rows: [[Int]] = []
    @State private var firstRowAdded: Bool = false
    @State private var hideRows: Bool = false
    @State private var optionsOpened: Bool = false
    @State private var showAlert: Bool = false
    @State private var showHeaderText: Bool = false
    @State private var showRowText: Bool = false
    @State private var lastIndex: Int?

    var showBottomRow: [String] {[
        rows.description,
        showRowText.description
    ]}

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack {
            // Add and subtract buttons
            HStack {
                Button {
                    if stitchCount > variableNumber {
                        stitchCount -= variableNumber
                    } else {
                        stitchCount = 0
                    }
                } label: {
                    Image(systemName: "minus")
                        .frame(width: 70, height: 70)
                }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    .controlSize(.extraLarge)
                    .padding(.leading, 20)

                Spacer()
                
                Button {
                    stitchCount += variableNumber
                } label: {
                    Image(systemName: "plus")
                        .frame(width: 70, height: 70)
                }
                    .buttonStyle(.bordered)
                    .tint(.green)
                    .controlSize(.extraLarge)
                    .padding(.trailing, 20)
            }

            Spacer()

            // Main text/count
            Text("Stitch Count")
                .padding([.top,.bottom], 10)
                .font(.largeTitle)
            Text("\(stitchCount)")
                .font(.largeTitle)

            Spacer()

            // variableNumber selection
            HStack {
                Button {
                    variableNumber = 1
                    selectedVariableNumber = 1
                } label: {
                    Text("1")
                        .bold()
                        .frame(width: 50, height: 50)
                        .foregroundColor(selectedVariableNumber == 1 ? Color.white : Color.blue)
                }
                    .buttonStyle(.bordered)
                    .background(selectedVariableNumber == 1 ? Color.blue : Color.clear)
                    .clipShape(Circle())
                    .controlSize(.extraLarge)

                Button {
                    variableNumber = 3
                    selectedVariableNumber = 3
                } label: {
                    Text("3")
                        .bold()
                        .frame(width: 50, height: 50)
                        .foregroundColor(selectedVariableNumber == 3 ? Color.white : Color.blue)
                }
                    .buttonStyle(.bordered)
                    .background(selectedVariableNumber == 3 ? Color.blue : Color.clear)
                    .clipShape(Circle())
                    .controlSize(.extraLarge)

                Button {
                    variableNumber = 5
                    selectedVariableNumber = 5
                } label: {
                    Text("5")
                        .bold()
                        .frame(width: 50, height: 50)
                        .foregroundColor(selectedVariableNumber == 5 ? Color.white : Color.blue)
                }
                    .buttonStyle(.bordered)
                    .background(selectedVariableNumber == 5 ? Color.blue : Color.clear)
                    .clipShape(Circle())
                    .controlSize(.extraLarge)

                Button {
                    variableNumber = 10
                    selectedVariableNumber = 10
                } label: {
                    Text("10")
                        .bold()
                        .frame(width: 50, height: 50)
                        .foregroundColor(selectedVariableNumber == 10 ? Color.white : Color.blue)
                }
                    .buttonStyle(.bordered)
                    .background(selectedVariableNumber == 10 ? Color.blue : Color.clear)
                    .clipShape(Circle())
                    .controlSize(.extraLarge)
            }

            VStack (spacing: 0) {
                // New Row and Options buttons
                HStack (spacing: 5) {
                    Button {
                        addNewRow()
                        withAnimation {
                            firstRowAdded = true
                        }
                    } label: {
                        Text("New Row")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.leading, 5)

                    Button {
                        optionsOpened = true
                    } label: {
                        Text("Options")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.trailing, 5)
                    .confirmationDialog("Options", isPresented: $optionsOpened) {
                        Button ("Show Rows") {
                            withAnimation {
                                hideRows = false
                            }
                        }
                        Button ("Hide Rows") {
                            hideRows = true
                            showHeaderText = false
                            showRowText = false
                        }
                        Button ("Remove Row") {
                            if !rows.isEmpty {
                                rows.removeLast()
                                if rows.isEmpty {
                                    firstRowAdded = false
                                    showHeaderText = false
                                    showRowText = false
                                } else {
                                    withAnimation {
                                        hideRows = false
                                    }
                                }
                            } else {
                                firstRowAdded = false
                            }
                            if rowCount > 0 {
                                rowCount -= 1
                            }
                        }
                        Button ("Reset All Rows", role: .destructive) {
                            firstRowAdded = false
                            showHeaderText = false
                            showRowText = false
                            hideRows = false
                            rows.removeAll()
                            rowCount = 0
                            variableNumber = 1
                            selectedVariableNumber = 1
                            stitchCount = 0
                        }
                        Button ("Cancel", role: .cancel) {}
                    }
                }
                .padding([.top, .bottom], 10)


                // Show the bottom section if the rows are not hidden and there is an existing
                if !hideRows {
                    if firstRowAdded {
                        // Row and Stitches header
                        HStack {
                            if showHeaderText {
                                Text("Row")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .transition(.opacity)
                                    .animation(.easeIn(duration: 0.1), value: showHeaderText)
                                Text("Stitches")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .transition(.opacity)
                                    .animation(.easeIn(duration: 0.1), value: showHeaderText)
                            }
                        }
                        .padding([.top, .bottom])
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .onAppear {
                            // Delay the start of the text animation
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation {
                                    showHeaderText = true
                                }
                            }
                        }

                        // Stitch tracker
                        withAnimation {
                            ScrollViewReader { proxy in
                                ScrollView {
                                    LazyVGrid(columns: columns, spacing: 10) {
                                        ForEach(rows.indices, id: \.self) { index in
                                            Text("\(rows[index][0])")
                                                .font(.headline)
                                                .frame(maxWidth: .infinity, alignment: .center)
                                                .id(index)
                                                .padding()
                                                .opacity(showRowText ? 1 : 0)
                                                .animation(.easeIn(duration: 0.2), value: showRowText)

                                            Text("\(rows[index][1])")
                                                .font(.headline)
                                                .frame(maxWidth: .infinity, alignment: .center)
                                                .padding()
                                                .opacity(showRowText ? 1 : 0)
                                                .animation(.easeIn(duration: 0.2), value: showRowText)
                                        }
                                    }
                                    .onChange(of: showBottomRow) {
                                        // Scroll to the bottom when rows change
                                        if let lastIndex = rows.indices.last {
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
                                        showRowText = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private func addNewRow() {
        let newRow = [rowCount + 1, stitchCount]
        rows.append(newRow)
        rowCount += 1

        // Reset the view after new row
        variableNumber = 1
        selectedVariableNumber = 1
        stitchCount = 0
    }
}

#Preview {
    ContentView()
}

