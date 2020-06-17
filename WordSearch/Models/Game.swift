//
//  Game.swift
//  WordSearch
//
//  Created by John N on 5/2/20.
//  Copyright © 2020 Examplingo. All rights reserved.
//

import Foundation

class Game {
    public var sourceLanguage: String!
    public var word: String!
    public var characterGrid: [[String]]!
    public var wordLocations: [WordLocation]!
    public var targetLanguage: String!
    
    init(gameSourceLanguage: String, gameWord: String, gameCharacterGrid: [[String]], gameWordLocations: [WordLocation], gameTargetLanguage: String) {
        self.sourceLanguage = gameSourceLanguage
        self.word = gameWord
        self.characterGrid = gameCharacterGrid
        self.wordLocations = gameWordLocations
        self.targetLanguage = gameTargetLanguage
    }
}
