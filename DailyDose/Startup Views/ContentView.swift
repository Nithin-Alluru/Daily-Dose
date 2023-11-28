//
//  ContentView.swift
//  PhotosVideos
//
//  Created by Osman Balci on 6/30/23.
//  Copyright © 2023 Osman Balci. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    
    @State private var userAuthenticated = false
    
    var body: some View {
        
        if userAuthenticated {
            // Foreground View
            MainView()
        } else {
            ZStack {
                // Background View
                LoginView(canLogin: $userAuthenticated)
            }
        }
    }
}

#Preview {
    ContentView()
}
