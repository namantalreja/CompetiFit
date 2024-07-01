//
//  InidividualGroupView.swift
//  Competifit
//
//  Created by Vamsi Putti on 6/30/24.
//

import SwiftUI

struct InidividualGroupView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        ScrollView {
            ForEach (0..<10) { number in
               RankComponent()
            }
        }
        .padding()
        .onAppear {
            async{
                try await print(viewModel.getGroupsSteps())
            }
        }
    }
}

#Preview {
    InidividualGroupView()
}
