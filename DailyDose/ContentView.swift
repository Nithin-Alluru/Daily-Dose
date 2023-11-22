//
//  ContentView.swift
//  DailyDose
//
//  Created by CM360 on 11/16/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            NewsPage();
        }
    }
}

#Preview {
    ContentView()
}
