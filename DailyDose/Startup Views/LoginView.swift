//
//  LoginView.swift
//  PhotosVideos
//
//  Created by Osman Balci on 6/30/23.
//  Copyright © 2023 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

private let logoCount = 3

struct LoginView : View {

    @AppStorage("darkMode") private var darkMode = false

    // Binding Input Parameter
    @Binding var canLogin: Bool
    
    // State Variables
    @State private var enteredPassword = ""
    @State private var showInvalidPasswordAlert = false
    @State private var showNoBiometricCapabilityAlert = false
    
    @State private var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @State private var logoIndex = 0

    var body: some View {
        NavigationStack {
            // Background View
            ZStack {
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
                
            // Foreground View
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Text("Daily Dose")
                        .font(.largeTitle)
                        .padding()
                    
                    Image("DDIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                        .shadow(radius: 5)  // Add a subtle shadow to the image

                    SecureField("Password", text: $enteredPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 300, height: 36)
                        .padding()
                    
                    HStack {
                        Button("Login") {
                            /*
                             UserDefaults provides an interface to the user’s defaults database,
                             where you store key-value pairs persistently across launches of your app.
                             */
                            // Retrieve the password from the user’s defaults database under the key "Password"
                            let validPassword = UserDefaults.standard.string(forKey: "Password")
                            
                            /*
                             If the user has not yet set a password, validPassword = nil
                             In this case, allow the user to login.
                             */
                            if validPassword == nil || enteredPassword == validPassword {
                                canLogin = true
                            } else {
                                showInvalidPasswordAlert = true
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .padding()
                        
                        if UserDefaults.standard.string(forKey: "SecurityQuestion") != nil {
                            NavigationLink(destination: ResetPassword()) {
                                Text("Forgot Password")
                            }
                            .tint(.blue)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            .padding()
                        }
                    }   // End of HStack
                    
                    /*
                     *********************************************************
                     *   Biometric Authentication with Face ID or Touch ID   *
                     *********************************************************
                     */
                    
                    // Enable biometric authentication only if a password has already been set
                    if UserDefaults.standard.string(forKey: "Password") != nil {
                        Button("Use Face ID or Touch ID") {
                            // authenticateUser() is given in UserAuthentication
                            authenticateUser() { status in
                                switch (status) {
                                case .Success:
                                    canLogin = true
                                    print("case .Success")
                                case .Failure:
                                    canLogin = false
                                    print("case .Failure")
                                case .Unavailable:
                                    canLogin = false
                                    showNoBiometricCapabilityAlert = true
                                    print("case .Unavailable")
                                }
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        
                        HStack {
                            Image(systemName: "faceid")
                                .font(.system(size: 40))
                                .padding()
                            Image(systemName: "touchid")
                                .font(.system(size: 40))
                                .padding()
                        }
                    }
                    // API logos scroller
                    Group {
                        Text("DailyDose is powered by:")
                        TabView(selection: $logoIndex) {
                            Link(destination: URL(string: "https://newsapi.org/docs")!) {
                                Image("NewsAPILogo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            .tag(0)
                            Link(destination: URL(string: "https://docs.mapbox.com/api/search/search-box/")!) {
                                Image("MapboxLogo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            .tag(1)
                            Link(destination: URL(string: "https://openweathermap.org/api")!) {
                                Image(darkMode ? "OpenWeatherLogoDark" : "OpenWeatherLogoLight")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            .tag(2)
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(height: 50)
                        .onReceive(timer) { _ in
                            logoIndex = (logoIndex + 1) % logoCount
                        }
                    }
                }   // End of VStack
            }   // End of ScrollView
                
            }   // End of ZStack
            .alert(isPresented: $showInvalidPasswordAlert, content: { invalidPasswordAlert })
            .navigationBarHidden(true)
            
        }   // End of NavigationStack
        .alert(isPresented: $showNoBiometricCapabilityAlert, content: { noBiometricCapabilityAlert })
        
    }   // End of body var
    
    //-----------------------
    // Invalid Password Alert
    //-----------------------
    var invalidPasswordAlert: Alert {
        Alert(title: Text("Invalid Password!"),
              message: Text("Please enter a valid password to unlock the app!"),
              dismissButton: .default(Text("OK")) )
        // Tapping OK resets showInvalidPasswordAlert to false
    }
    
     //------------------------------
     // No Biometric Capability Alert
     //------------------------------
    var noBiometricCapabilityAlert: Alert{
        Alert(title: Text("Unable to Use Biometric Authentication!"),
              message: Text("Your device does not support biometric authentication!"),
              dismissButton: .default(Text("OK")) )
        // Tapping OK resets showNoBiometricCapabilityAlert to false
    }
    
}
