//
//  ThemeSwitch.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2023-01-06.
//

import SwiftUI

struct ThemeSwitch: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @GestureState private var gestureOffset: CGFloat = 0
    @State var currentOffsetX: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    
//    @State var isDarkModeOn: Bool = false
    
    var body: some View {
        VStack{
        ZStack{
                HStack{
                    HStack{
                        if Utils.isDarkModeOn{
                            Text("Turn Light").font(.system(size: 13).bold())
                            Spacer()
                        }else{
                            Spacer()
                            Text("Turn Dark").font(.system(size: 13).bold())
                        }
                    }.padding(.horizontal, 20)
                }.frame(width: 200, height: 50)
                .background(Color.SwitchBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                HStack{
                    HStack{
                        
                            Image(systemName: Utils.isDarkModeOn ? "moon" : "moon.fill")
                                .resizable()
                                .foregroundColor(Color.ThemeSwitchColor)
                                .frame(width: 30, height: 30)
                        
                    }.frame(width: 100, height: 52)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 26))
                        .shadow(radius: 2)
                        .offset(x: currentOffsetX)
                        .gesture(dragGesture)
                        .onTapGesture {
                            withAnimation {
                                if currentOffsetX == 0{
                                    currentOffsetX = 100
                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                                        withAnimation {
                                            Utils.isDarkModeOn = true
                                        }
                                    })
                                }else{
                                    currentOffsetX = 0
                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                                        withAnimation {
                                            Utils.isDarkModeOn = false
                                        }
                                    })
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.7, execute: {
                                withAnimation {
                                    Utils.changeDarkMode(state: Utils.isDarkModeOn)
                                }
                            })
                        }
                    Spacer()
                }.frame(width: 200, height: 52)
            }
        }
        .frame(width: ScreenSize.width(), height: ScreenSize.height())
        .background(Color.BackgroundColor)
        .onAppear{
            Utils.setAppTheme(isDark: colorScheme == .dark ? true : false)
        }
    }
    
    var dragGesture: some Gesture{
        
            DragGesture()
                .updating($gestureOffset, body: { value, out, _ in
                    out = value.translation.width
                    onChange()
                })
                .onEnded({ value in
                    withAnimation {
                        if currentOffsetX > 50{
                            currentOffsetX = 100
                            Utils.isDarkModeOn = true
                        }else{
                            currentOffsetX = 0
                            Utils.isDarkModeOn = false
                        }
                    }
                    Utils.changeDarkMode(state: Utils.isDarkModeOn)
                    lastOffset = currentOffsetX
                })
    }
    
    func onChange(){
        DispatchQueue.main.async{
                self.currentOffsetX = gestureOffset + lastOffset
            if currentOffsetX > 100{
                currentOffsetX = 100
            }
            if currentOffsetX < 0{
                currentOffsetX = 0
            }
        }
    }
    
//    func setAppTheme(){
//      //MARK: use saved device theme from toggle
//      Utils.isDarkModeOn = UserDefaultsUtils.shared.getDarkMode()
//        Utils.changeDarkMode(state: Utils.isDarkModeOn)
//      //MARK: or use device theme
//      if (colorScheme == .dark)
//      {
//        Utils.isDarkModeOn = true
//      }
//      else{
//        Utils.isDarkModeOn = false
//      }
//        Utils.changeDarkMode(state: Utils.isDarkModeOn)
//    }
    
}

struct ThemeSwitch_Previews: PreviewProvider {
    static var previews: some View {
        ThemeSwitch()
    }
}
