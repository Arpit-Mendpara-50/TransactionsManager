//
//  Utils.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2023-01-06.
//

import Foundation
import SwiftUI


@objc public class Utils: NSObject {
    @objc public static var isDarkModeOn: Bool = false
    
    @objc public static func setAppTheme(isDark: Bool){
      //MARK: use saved device theme from toggle
      isDarkModeOn = UserDefaultsUtils.shared.getDarkMode()
        Utils.changeDarkMode(state: isDarkModeOn)
      //MARK: or use device theme
      if (isDark)
      {
        isDarkModeOn = true
      }
      else{
        isDarkModeOn = false
      }
        Utils.changeDarkMode(state: isDarkModeOn)
    }
    
    @objc public static func changeDarkMode(state: Bool){
      (UIApplication.shared.connectedScenes.first as?
      UIWindowScene)?.windows.first!.overrideUserInterfaceStyle = state ?   .dark : .light
      UserDefaultsUtils.shared.setDarkMode(enable: state)
    }
}

/// This class is used to return a certain of useful screen size, value will change when we rotate
final class ScreenSize {
    
    public static func safeLeading() -> CGFloat {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
            return 0
        }
        return window.safeAreaInsets.left
    }
    
    public static func safeTrailing() -> CGFloat {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
            return 0
        }
        return window.safeAreaInsets.right
    }
    
    public static func safeTop() -> CGFloat {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
            return 0
        }
        return window.safeAreaInsets.top
    }
    
    public static func safeBottom() -> CGFloat {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
            return 0
        }
        return window.safeAreaInsets.bottom
    }
    
    public static func width() -> CGFloat {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
            return 0
        }
        return window.frame.width
    }
    
    public static func height() -> CGFloat {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
            return 0
        }
        return window.frame.height
    }
}
