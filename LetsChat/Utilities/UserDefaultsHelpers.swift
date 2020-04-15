//
//  UserDefaultsHelpers.swift
//  audibleLearningProject
//
//  Created by Navjot Singh on 02/03/17.
//  Copyright © 2017 TisIndia. All rights reserved.
//

import Foundation

extension UserDefaults{
    
    enum UserDefaultsKeys: String {
        case isLoggedIn
        //        case userDetails
        //        case UserLanguage
        //        case UserRegion
        case userId
        case pass
    }
    
    func setUserId(value: String){
        set(value, forKey: UserDefaultsKeys.userId.rawValue)
        synchronize()
    }
    
    func getUserId() -> String?{
        return string(forKey: UserDefaultsKeys.userId.rawValue)
    }
    
    func setPass(value: String){
        set(value, forKey: UserDefaultsKeys.pass.rawValue)
        synchronize()
    }
    
    func getPass() -> String?{
        return string(forKey: UserDefaultsKeys.pass.rawValue)
    }
    
    //    func setUserLanguage(value: String){
    //        set(value, forKey: UserDefaultsKeys.UserLanguage.rawValue)
    //        synchronize()
    //    }
    //
    //    func getUserLanguage() -> String?{
    //        return string(forKey: UserDefaultsKeys.UserLanguage.rawValue)
    //    }
    
    //    func setUserRegion(value: [String:String]){
    //        set(value, forKey: UserDefaultsKeys.UserRegion.rawValue)
    //        synchronize()
    //    }
    //
    //    func getUserRegion() -> [String:String]{
    //
    //        if let data = dictionary(forKey: UserDefaultsKeys.UserRegion.rawValue) as? [String:String]{
    //            return data
    //        }
    //        return [:]
    //    }
    
    //    func setIsLoggedIn(value: Bool){
    //        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    //        synchronize()
    //    }
    //
    //    func isLoggedIn() -> Bool{
    //        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    //    }
    //
    //    func setUserDetails(value: NSDictionary){
    //        set(value, forKey: UserDefaultsKeys.userDetails.rawValue)
    //        synchronize()
    //    }
    //
    //    func getUserDetails() -> NSDictionary{
    //        if let arr = dictionary(forKey: UserDefaultsKeys.userDetails.rawValue){
    //            if arr.count > 0 {
    //                return arr as NSDictionary
    //            }
    //        }
    //        return NSDictionary()
    //    }
    //
    //    func removeAllFromUserDefault(){
    //        removeObject(forKey: UserDefaultsKeys.accesskey.rawValue)
    //        removeObject(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    //        //        removeObject(forKey: UserDefaultsKeys.UserLanguage.rawValue)
    //        //        removeObject(forKey: UserDefaultsKeys.UserRegion.rawValue)
    //        removeObject(forKey: UserDefaultsKeys.userDetails.rawValue)
    //        synchronize()
    //    }
    
}
