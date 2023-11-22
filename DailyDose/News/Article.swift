//
//  Article.swift
//  DailyDose
//
//  Created by Caleb Kong on 11/22/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

struct Article: View {
    let thisArticle: News

    var body: some View {
        Text(thisArticle.title)
    }
}
