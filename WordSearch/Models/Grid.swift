import Foundation

struct Grid: Codable {
    let sourceLanguage: String
    let targetLanguage: String
    let word: String
    let characterGrid: [[String]]
    let wordLocations: [String: String]

    static let all: [Grid] = {
        let decoder = JSONDecoder()
        return try! decoder.decode([Grid].self, from: gridJsonData)
    }()

    enum CodingKeys: String, CodingKey {
        case sourceLanguage = "source_language"
        case targetLanguage = "target_language"
        case word = "word"
        case characterGrid = "character_grid"
        case wordLocations = "word_locations"
    }
}

private let gridJsonData = """
[{"source_language":"english","word":"man","character_grid":[["i","q","í","l","n","n","m","ó"],["f","t","v","ñ","b","m","h","a"],["h","j","é","t","e","t","o","z"],["x","á","o","i","e","ñ","m","é"],["q","é","i","ó","q","s","b","s"],["c","u","m","y","v","l","r","x"],["ü","í","ó","m","o","t","e","k"],["a","g","r","n","n","ó","s","m"]],"word_locations":{"6,1,6,2,6,3,6,4,6,5,6,6":"hombre"},"target_language":"spanish"},{"source_language":"english","word":"woman","character_grid":[["v","á","q","t","b","f","q"],["y","x","i","a","ü","v","a"],["r","d","y","í","t","n","a"],["f","v","ó","w","l","a","v"],["b","u","ú","j","q","h","á"],["c","o","m","u","j","e","r"],["h","o","d","ú","w","d","ü"]],"word_locations":{"2,5,3,5,4,5,5,5,6,5":"mujer"},"target_language":"spanish"},{"source_language":"en","word":"am","character_grid":[["d","c","e","h","p"],["f","e","ü","p","t"],["s","s","ó","í","l"],["o","s","í","ñ","a"],["y","g","i","o","n"]],"word_locations":{"0,2,0,3,0,4":"soy"},"target_language":"spanish"},{"source_language":"english","word":"she","character_grid":[["z","n","w","f","m","é"],["d","ó","q","w","n","e"],["z","á","v","e","ó","l"],["r","c","z","z","m","l"],["ü","m","á","ü","n","a"],["e","a","e","x","ñ","h"]],"word_locations":{"5,1,5,2,5,3,5,4":"ella"},"target_language":"spanish"},{"source_language":"english","word":"apple","character_grid":[["ú","k","ü","b","í","n","z","d","o"],["u","á","n","g","e","y","z","o","ñ"],["o","é","ú","á","v","e","x","u","m"],["c","w","d","z","t","k","m","l","a"],["u","b","o","w","í","a","u","q","n"],["g","s","m","e","c","n","k","ú","z"],["a","o","v","t","p","ú","é","k","a"],["f","j","i","j","n","i","b","ó","n"],["s","q","l","j","j","f","q","g","a"]],"word_locations":{"8,2,8,3,8,4,8,5,8,6,8,7,8,8":"manzana"},"target_language":"spanish"},{"source_language":"english","word":"bread","character_grid":[["ü","á","p","a","n"],["k","a","k","m","l"],["a","x","q","e","h"],["p","s","a","j","í"],["á","q","l","j","l"]],"word_locations":{"2,0,3,0,4,0":"pan"},"target_language":"spanish"}]
""".data(using: .utf8)!
