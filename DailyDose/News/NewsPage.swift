//
//  NewsPage.swift
//  DailyDose
//
//  Created by Caleb Kong on 11/22/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//
// Referenced:
//  Photos.swift
//  Cars
//
//  Created by Caleb Kong on 9/18/23.
//
import SwiftUI

struct NewsPage: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

/*
import SwiftUI

// Preserve selected background color between views
fileprivate var selectedColor = Color.gray.opacity(0.1)

struct Photos: View {
    
    // Default selected background color
    @State private var selectedBgColor = Color.gray.opacity(0.1)
    
    var body: some View {
        NavigationStack {
            ZStack {            // Background
                // Color entire background with selected color
                selectedBgColor
                
                // Place color picker at upper right corner
                VStack {        // Foreground
                    HStack {
                        Spacer()
                        ColorPicker("", selection: $selectedBgColor)
                            .padding()
                    }
                    Spacer()
                    
                    TabView {
                        ForEach(modelStructList) { model in
                            VStack {
                                Link(destination: URL(string: model.websiteUrl)!) {
                                    Text("\(model.brandName) \(model.modelName)")
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.blue)
                                        .padding()
                                }
                                Image(model.photoFilename)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                    }   // End of TabView
                    .tabViewStyle(PageTabViewStyle())
                    .onAppear() {
                        UIPageControl.appearance().currentPageIndicatorTintColor = .black
                        UIPageControl.appearance().pageIndicatorTintColor = .gray
                    }
                    
                }   // End of VStack
                .navigationTitle("Car Models")
                .toolbarTitleDisplayMode(.inline)
                .onAppear() {
                    selectedBgColor = selectedColor
                }
                .onDisappear() {
                    selectedColor = selectedBgColor
                }
                
            }   // End of ZStack
        }   // End of NavigationStack
    }   // End of body var
}

#Preview {
    Photos()
}

*/
