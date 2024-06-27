//
//  ContentView.swift
//  Competifit
//
//  Created by Naman Talreja on 27/06/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        Text("Hello World")
            .padding(10)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
