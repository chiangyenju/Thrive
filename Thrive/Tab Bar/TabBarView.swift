//
//  TabBarView.swift
//  Thrive
//
//  Created by Yen Ju Chiang on 6/21/24.
//

import SwiftUI

enum Tabs: Int{
    case home = 0
    case test = 1
    case results = 2
    case discover = 3
    case profile = 4
}

struct TabBarView: View {
    
    @Binding var selectedTab: Tabs
    
    var body: some View {
        
        HStack (alignment: .center){
            
            Button {
                // switch pages
                selectedTab = .test
            } label: {
                
                TabBarButton(
                    imageName: "pencil.circle",
                    isActive: selectedTab == .test)
            }
            .tint(Color("icons-secondary"))
            
            Button {
                // switch pages
                selectedTab = .results
            } label: {
                
                TabBarButton(
                    imageName: "chart.bar",
                    isActive: selectedTab == .results)
            }
            .tint(Color("icons-secondary"))
            
            Button {
                // switch pages
                selectedTab = .home
            } label: {
                
                GeometryReader { geo in
                    
                    VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 4) {
                        
                        Image(systemName: "house.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        
                        //                        Text("Home")
                        //                            .font(Fonts.tabBar)
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                }
            }
            .tint(Color(.blue))
            
            Button {
                // switch pages
                selectedTab = .discover
            } label: {
                
                TabBarButton(
                    imageName: "magnifyingglass",
                    isActive: selectedTab == .discover)
            }
            .tint(Color("icons-secondary"))
            
            
            Button {
                // switch pages
                selectedTab = .profile
            } label: {
                
                TabBarButton(
                    imageName: "person",
                    isActive: selectedTab == .profile)
                
            }
            .tint(Color("icons-secondary"))
            
        }
        .frame(height: 82)
    }
}

struct TebBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(selectedTab: .constant(.home))
    }
}
