//
//  DefaultTabbarView.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 8/12/23.
//

import Foundation
import SwiftUI


struct DefaultTabbarView: View {
    
    @State var selectedIndex = 0
    @State var presented = false
    @Environment(\.modelContext) private var context
    let icons = ["house", "hands.sparkles", "plus", "person", "person"]
    
    
    
    var body: some View {
        
        VStack{
            
            Spacer().fullScreenCover(isPresented: $presented, content: {
                Text("Create Post Here")
                Button(action: {
                    presented.toggle()
                }, label: {
                    Text("Close")
                })
            })
            
            switch selectedIndex{
                
            case 0:
                HomeBuilder().build(with: context.container)
            case 1:
                TopCryptosBuilder().build(with: context.container)
            case 2:
                MyPortfolioBuilder().build(with: context.container)
            case 3:
                TopCryptosBuilder().build(with: context.container)
                
            default:
                HomeBuilder().build(with: context.container)
            }
            
            
            
            
            HStack{
                ForEach(0..<5, id: \.self){number in
                    
                    Spacer()
                    Button(action: {
                        
                        if number == 2{
                            presented.toggle()
                        }else{
                            self.selectedIndex = number
                        }
                        
                    }, label: {
                        if number == 2{
                            Image(systemName: icons[number])
                                .font(.system(size: 25, weight: .regular, design: .default))
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(Color.blue)
                                .cornerRadius(25)
                        }else{
                            Image(systemName: icons[number])
                                .font(.system(size: 25, weight: .regular, design: .default))
                                .foregroundColor(selectedIndex == number ? .black : Color(UIColor.lightGray))
                        }
                    })
                    Spacer()
                }
            }
        }
        
    }
}

