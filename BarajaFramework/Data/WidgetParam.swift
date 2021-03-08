import Foundation

struct WidgetParameter: Codable {
    var widget: String?
    var selector: String?
    var lang: String?
    var user: User?
    var data: Data?
    
    struct User: Codable {
        var id: String?
        var name: String?
        var email: String?
    }
    
    struct Data: Codable {
        var platform: String?
    }
}
