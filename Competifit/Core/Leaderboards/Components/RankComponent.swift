//
//  RankComponent.swift
//  Competifit
//
//  Created by Vamsi Putti on 6/30/24.
//

import SwiftUI

struct RankComponent: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        HStack {
            Text("User 1 Name")
                .foregroundStyle(.white)
            
            
            Spacer()
            
            Text("Steps")
                .foregroundColor(.white)
        }
        .padding()
        .background(.cyan)
        .cornerRadius(10.0)
    }
}

#Preview {
    RankComponent()
}
