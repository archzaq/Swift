//
//  ContentView.swift
//  stitchCounter
//
//  Created by zaq on 8/20/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var stitchCount: Int = 0
    @State private var variableNumber: Int = 1
    @State private var selectedVariableNumber: Int = 1
    @State private var rowCount: Int = 0
    @State private var rows: [[Int]] = []

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
                        .frame(width: 50, height: 50)
                }
                    .buttonStyle(.bordered)
                    .controlSize(.extraLarge)
                    .padding(.leading, 40)

                Spacer()
                
                Button {
                    stitchCount += variableNumber
                } label: {
                    Image(systemName: "plus")
                        .frame(width: 50, height: 50)
                }
                    .buttonStyle(.bordered)
                    .controlSize(.extraLarge)
                    .padding(.trailing, 40)
            }

            Spacer()

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

            Spacer()
                .frame(height: 30)

            VStack (spacing: 0) {
                // New Row and Options buttons
                HStack (spacing: 5) {
                    Button {
                        addNewRow()
                    } label: {
                        Text("New Row")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    Button {
                        // Action for Options button
                        // WIP
                    } label: {
                        Text("Options")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding([.top, .bottom], 10)

                // Row tracker
                HStack {
                    Text("Row")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text("Stitches")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding([.top, .bottom])
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            }

            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(rows.indices, id: \.self) { index in
                        Text("\(rows[index][0])")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()

                        Text("\(rows[index][1])")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    }
                }
            }
            .frame(maxHeight: 160)
        }
    }

    private func addNewRow() {
        // Create a new row with default integer values
        let newRow = [rowCount + 1, stitchCount]
        rows.append(newRow)
        rowCount += 1

        // Reset the view
        variableNumber = 1
        selectedVariableNumber = 1
        stitchCount = 0
    }
}

#Preview {
    ContentView()
}

