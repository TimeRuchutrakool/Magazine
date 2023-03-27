//
//  infoView.swift
//  Magazine
//
//  Created by Time Ruchutrakool on 3/27/23.
//

import SwiftUI

struct infoView: View {
    
    @State private var infoIsShown =  false
    var scale: CGFloat
    var offset: CGSize
    var body: some View {
        HStack{
            Image(systemName: "arrow.down.circle")
                .resizable()
                .foregroundColor(.white)
                
                .frame(width: 30,height: 30)
                .rotationEffect(Angle(degrees: infoIsShown ? -90 : 0))
                .onLongPressGesture(minimumDuration: 0.3) {
                    withAnimation(.easeOut){
                        infoIsShown.toggle()
                    }
                }
            Spacer()
            
            HStack(spacing: 2){
                Image(systemName: "arrow.up.left.and.arrow.down.right.circle")
                Text("\(scale)")
                Spacer()
                Image(systemName: "arrow.left.and.right")
                Text("\(offset.width)")
                Spacer()
                Image(systemName: "arrow.up.and.down")
                Text("\(offset.height)")
                Spacer()
            }
            .font(.footnote)
            .padding(7)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .frame(maxWidth: 320)
            .opacity(infoIsShown ? 1 : 0)
            Spacer()
        }
        
        
    }
}

struct infoView_Previews: PreviewProvider {
    static var previews: some View {
        infoView(scale: 1, offset: .zero).previewLayout(.sizeThatFits)
            .preferredColorScheme(.light)
    }
}
