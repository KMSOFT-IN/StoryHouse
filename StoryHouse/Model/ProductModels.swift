
import Foundation

struct StoryModels: Codable {
    var story: [Story1]?
}

struct Product: Codable {
    var category_name: String?
    var products: [ProductDetails]?
}

struct ProductDetails: Codable {
    var name: String?
    var image_name: String?
    var price: String?
    var description: String?
}

struct Story1 : Codable {
    var storyNumber : String?
    var data : [ParagraphDetails]?
}

struct ParagraphDetails: Codable {
    var number: String?
    var imageName: String?
    var he: String?
    var she: String?
}
