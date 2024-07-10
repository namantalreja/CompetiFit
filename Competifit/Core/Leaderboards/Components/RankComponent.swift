//
//  RankComponent.swift
//  Competifit
//
//  Created by Vamsi Putti on 6/30/24.
//

import SwiftUI

struct RankComponent: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var name: String
    var steps: [Step]
    var rank: Int = 1
    init(name: String, steps: [Step]) {
        self.name = name
        self.steps = steps
    }
    var body: some View {
        HStack {
            Text("\(name)")
                .font(Font.custom(Fonts.ARCADE_BODY, size: 20))
            
            Spacer()
            
            Text("\(steps[steps.count-1].count)")
                .font(Font.custom(Fonts.ARCADE_BODY, size: 20))
        }
        .padding()
        .background(Color(red: 0.5764705882352941, green: 0.8313725490196079, blue: 0.6470588235294118))
        .cornerRadius(10.0)
    }
}

#Preview {
    RankComponent(name: "", steps: [])
}
