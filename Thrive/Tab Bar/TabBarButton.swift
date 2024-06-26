//
//  TabBarButton.swift
//  Thrive
//
//  Created by Yen Ju Chiang on 6/21/24.
//

import SwiftUI

struct TabBarButton: View {
    
//    var buttonText: String
    var imageName: String
    var isActive: Bool
    
    var body: some View {
        
        GeometryReader { geo in
            
            if isActive {
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: geo.size.width/2, height:4)
                    .padding(.leading, geo.size.width/4)
            }
            
            
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 4) {
                
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
//                Text(buttonText)
//                    .font(Fonts.tabBar)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

#Preview {
    TabBarButton(imageName: "pencil.circle", isActive: true)
}
