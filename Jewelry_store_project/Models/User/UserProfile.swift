import Foundation

struct UserProfile{
    let id:String
    let name:String
    let email:String
    let avatarURL:URL?
    let status:ProfileStatus
}

struct ProfileStatus{
    let favorite:Int
    let review:Int
    let subsctiptions:Int
}
