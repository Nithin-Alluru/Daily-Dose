//
//  Globals.swift
//  Daily Dose
//
//  Created by Caleb Kong on 11/15/23.
//

//-----------------------------------------
// Global Alert Title and Message Variables
//-----------------------------------------
var alertTitle = ""
var alertMessage = ""

private let openWeatherAPIKey_Caleb = "e39c8687dd6113bce5e9b5bf14af6bb9"
private let newsAPIKey_Caleb = "c472c5f827cb4f61b1eb48e725504974"


private var openWeatherAPICalls = 0
func getWeatherApiKey() -> String {
    openWeatherAPICalls += 1;
    if (openWeatherAPICalls >= 1000) {
        return "Out of Requests"
    }
    return openWeatherAPIKey_Caleb
}


func getNewsApiKey() -> String {
    return newsAPIKey_Caleb
}
