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
    init(name: String, steps: [Step]) {
        self.name = name
        self.steps = steps
    }
    var body: some View {
        HStack {
            Text("\(name)")
                .foregroundStyle(.white)
            
            
            Spacer()
            
            Text("\(steps[steps.count - 1].count)")
                .foregroundColor(.white)
        }
        .padding()
        .background(.cyan)
        .cornerRadius(10.0)
    }
}

#Preview {
    RankComponent(name: "", steps: [])
}
