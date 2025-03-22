//
//  ContentView.swift
//  Assigment 1 (Memorize)
//
//  Created by Авазбек Надырбек уулу on 22.03.25.
//

import SwiftUI

struct Menudata {
    let name: String
    let imageSfsymbol: String
    let items: [String]
}

struct ContentView: View {
    
    
    // Initialize the dictionary with data
    @State var menuDictonary: [String: Menudata] = [
        "Emojis": Menudata(name: "Emojis", imageSfsymbol: "face.smiling", items: ["😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣", "😊", "😇"]),
        "Trees": Menudata(name: "Trees", imageSfsymbol: "leaf", items: ["🌲", "🌳", "🌴", "🌵", "🎋", "🌿", "🪷", "🪻", "🍂"]),
        "Animals": Menudata(name: "Animals", imageSfsymbol: "hare", items: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯"])
    ]
    
    // Add selected theme state
    @State private var selectedTheme: String = "Emojis"  // Default to Emojis
    
    // ADD: Grid layout configuration
    @State var columns = [
        GridItem(.adaptive(minimum: 150, maximum: 300)),
        GridItem(.adaptive(minimum: 150, maximum: 300)),
        GridItem(.adaptive(minimum: 150, maximum: 300))
    ]
    
    var body: some View {
        VStack {
            Text("Memorize!")
                .font(.largeTitle)
            
            ScrollView {
                CardView(
                    menuDictionary: $menuDictonary,
                    columns: $columns,
                    selectedTheme: $selectedTheme
                )
            }
            
            Spacer()
            
            
            ThemePickerView(
                menuDictionary: $menuDictonary,
                selectedTheme: $selectedTheme
            )
        }
        .padding()
        .background(Color.black.opacity(0.1))

    }
}



#Preview {
    ContentView()
}

struct ThemePickerView: View {
    @Binding var menuDictionary: [String: Menudata]
    @Binding var selectedTheme: String
    
    var body: some View {
        HStack {
            ForEach(Array(menuDictionary.keys), id: \.self) { key in
                if let menuItem = menuDictionary[key] {
                    Button(action: {
                        selectedTheme = key
                    }) {
                        menuView(name: menuItem.name, imageSfsymbol: menuItem.imageSfsymbol)
                            .background(selectedTheme == key ? Color.blue.opacity(0.2) : Color.clear)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}



struct menuView: View {
    
    let name: String
    let imageSfsymbol: String
    
    var body: some View {
        VStack {
            Image(systemName: imageSfsymbol)
                .font(.title)
            Text(name)
        }
        .padding()
    }
}

struct CardView: View {
    @Binding var menuDictionary: [String: Menudata]
    @Binding var columns: [GridItem]
    @Binding var selectedTheme: String
    
    @State private var shuffledItems: [String] = []
    
    @State private var cardStates: [String: Bool] = [:]
    
    private var items: [String] {
        menuDictionary[selectedTheme]?.items ?? []
    }
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(shuffledItems, id: \.self) { item in
                    // Use cardStates[item] to get individual card state
                    if cardStates[item, default: true] {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.blue)
                            .frame(width: 120,height: 120)
                            .onTapGesture {
                                cardStates[item]?.toggle()
                            }
                    } else {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.yellow)
                            .frame(width: 120,height: 120)
                            .overlay(
                                Text(item)
                                    .font(.title)
                            )
                            .padding(.horizontal)
                            .onTapGesture {
                                cardStates[item]?.toggle()
                            }
                    }
                }
            }
        }
        .onChange(of: selectedTheme) { oldValue, newValue in
            shuffledItems = items.shuffled()
            cardStates = Dictionary(uniqueKeysWithValues:
                                        shuffledItems.map { ($0, true) }
            )
        }
        .onAppear {
            shuffledItems = items.shuffled()
            cardStates = Dictionary(uniqueKeysWithValues:
                                        shuffledItems.map { ($0, true) }
            )
        }
    }
}
