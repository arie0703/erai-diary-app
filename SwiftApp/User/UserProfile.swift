import SwiftUI

class UserProfile: ObservableObject {

    @Published var name: String {
        didSet {
            UserDefaults.standard.set(name, forKey: "name")
        }
    }

    @Published var goal: String {
        didSet {
            UserDefaults.standard.set(goal, forKey: "goal")
        }
    }

    @Published var point: Int {
        didSet {
            UserDefaults.standard.set(point, forKey: "point")
        }
    }

    @Published var total_point: Int {
        didSet {
            UserDefaults.standard.set(point, forKey: "total_point")
        }
    }

    @Published var image: Data {
        didSet {
            UserDefaults.standard.set(image, forKey: "image")
        }
    }

    /// 初期化処理
    init() {
        name = UserDefaults.standard.string(forKey: "name") ?? "ユーザー"
        goal = UserDefaults.standard.string(forKey: "goal") ?? ""
        point = UserDefaults.standard.integer(forKey: "point")
        total_point = UserDefaults.standard.integer(forKey: "total_point")
        image = UserDefaults.standard.data(forKey: "image") ?? UIImage(imageLiteralResourceName: "noicon").pngData()!
    }
    
    
}


//ごほうび使用後に投稿削除するなど、ポイントがマイナスになってしまうことを無くすメソッド
func avoidMinusPoint(point: Int32) {
    if point < 0 {
        UserDefaults.standard.set(0 , forKey: "point")
    }
}
