//
//  ContentView.swift
//  Magazine
//
//  Created by Time Ruchutrakool on 3/27/23.
//

import SwiftUI

struct MagazineView: View {
    
    @State private var isAnimating: Bool = false
    @State private var scaleLevel: CGFloat = 1
    @State private var isNavBarHidden = false
    @State private var imageOffSet: CGSize = .zero
    @State private var drawerIsShown = false
    
    let magazines: [MagazineModel] = magazineData
    @State private var index: Int = 1
    
    init(){
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        print(magazines)
    }
    
    func resetImage(){
        withAnimation(.spring()){
                scaleLevel = 1
                imageOffSet = .zero
        }
    }
    
    func currentMagazine() -> String{
        return magazines[index-1].imageName
    }
    
    var body: some View {
        NavigationView {
            
            ZStack{
                Color("ColorBG")
                    .edgesIgnoringSafeArea(.all)
                
                //MARK: - Image Magazine
                Image(currentMagazine())
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15)
                    .padding()
                    .shadow(radius: 12,x: 2,y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : -10)
                    .scaleEffect(scaleLevel)
                    .offset(x: imageOffSet.width,y: imageOffSet.height)
                //MARK: - Double Tap Gesture
                    .onTapGesture(count: 2) {
                        if scaleLevel == 1{
                            withAnimation(.spring()){
                                scaleLevel = 4
                                
                            }
                        }
                        else{
                            withAnimation(.spring()){
                                resetImage()
                            }
                        }
                    }
                //MARK: - Drag Gesture
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                withAnimation(.linear){
                                    imageOffSet = value.translation
                                }
                            })
                            .onEnded({ _ in
                                if scaleLevel <= 1{
                                    resetImage()
                                }
                            })
                    )
                //MARK: - Magnification Gesture
                    .gesture(
                    MagnificationGesture()
                        .onChanged({ value in
                            withAnimation(.linear(duration: 1)){
                                if scaleLevel >= 1 && scaleLevel <= 4{
                                    scaleLevel = value
                                }
                                else if scaleLevel > 4{
                                    scaleLevel = 4
                                }
                               
                            }
                        })
                        .onEnded({ _ in
                            withAnimation(.spring()){
                                if scaleLevel < 1{
                                    resetImage()
                                }
                                else if scaleLevel > 4{
                                    scaleLevel = 4
                                }
                            }
                        })
                    )
            }
            .overlay(
                infoView(scale: scaleLevel, offset: imageOffSet)
                    .padding(.leading).padding(.top)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : -10)
                ,alignment: .topLeading
            )
            .overlay(
                Group{
                    HStack{
                        //MARK: - Scale Down
                        Button {
                            withAnimation(.spring()){
                                if scaleLevel > 1{
                                    scaleLevel -= 1
                                    if scaleLevel <= 1{
                                        resetImage()
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: "minus.magnifyingglass")
                                .font(.system(size: 36))
                                .foregroundColor(.white)
                        }

                        //MARK: - Reset
                        Button {
                            withAnimation(.spring()){
                                resetImage()
                            }
                        } label: {
                            Image(systemName: "1.magnifyingglass")
                                .font(.system(size: 36))
                                .foregroundColor(.white)
                        }
                        
                        //MARK: - Scale Up
                        Button {
                            withAnimation(.spring()){
                                if scaleLevel < 4 {
                                    scaleLevel += 1
                                    if scaleLevel > 4{
                                        scaleLevel = 4
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: "plus.magnifyingglass")
                                .font(.system(size: 36))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 10)
                }
                    .padding(.bottom,40)
                ,alignment: .bottom
            )
            .onAppear(){
                withAnimation(.easeOut(duration: 1)){
                    isAnimating = true
                    isNavBarHidden = true
                }
            }
            .overlay(
                HStack(spacing: 12){
                    Image(systemName: drawerIsShown ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.2)){
                                drawerIsShown.toggle()
                            }
                        }
                   
                        ScrollView(.horizontal,showsIndicators: false){
                            HStack{
                                ForEach(magazines,id: \.id) { magazine in
                                    Image(magazine.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60)
                                        .shadow(radius: 4)
                                        .cornerRadius(16)
                                        .onTapGesture {
                                            withAnimation(.easeOut){
                                                index = magazine.id
                                                drawerIsShown .toggle()
                                            }
                                        }
                                }
                            }
                        }
                    
                    Spacer()
                }
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .opacity(isAnimating ? 1 : 0)
                    .frame(maxWidth: 320)
                    .padding(.top,UIScreen.main.bounds.height / 12)
                    .offset(x: drawerIsShown ? 50 : 280)
                ,alignment: .topTrailing
            )
            .navigationBarHidden(scaleLevel == 1 ? false : true)
            
            .navigationTitle("Magazine")
            .navigationBarTitleDisplayMode(.inline)
           
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MagazineView()
    }
}
