//
//  GameViewModel.swift
//  WordSearch
//
//  Created by John N on 5/2/20.
//  Copyright © 2020 Examplingo. All rights reserved.
//

import UIKit

enum ProgressType {
    case finished
    case inProgress(String,String,Int, String)
}

enum FeedbackType {
    case success
    case fail
}

enum LocationType: Int {
    case start = 0
    case end = 1
}

protocol GameViewModelDelegate: class {
    func handleUpdateViews(progressType: ProgressType, spriteImageName: String)
}

class GameViewModel {
    //MARK: Delegate
    weak var delegate: GameViewModelDelegate? 
    
    //MARK: Private variables
    private var games:[Game] = []
    private var gameLevel: Int = 0
    private var currentMarker: Marker!
    private var userAnswer: [Position] = []
    private var gameScore: Int = 0
    private var successFeedbackStrings: [String] = ["Good job, keep up the great work!", "You can do this!", "You are a star!", "Keep rocking!"]
    private var failFeedbackStrings: [String] = ["It's okay. You can keep trying!", "Don't give up yet!", "Tap '?' if you're stuck.", "Try harder."]
    private var currentTargetLanguage: String {
        return games[gameLevel].targetLanguage
    }
    private var currentTargetWord: String {
        return games[gameLevel].word
    }
    
    init(assignedDelegate: GameViewController) {
        self.delegate = assignedDelegate
        getGameData()
        randomizeGameData()
        delegate?.handleUpdateViews(progressType: .inProgress(currentTargetLanguage, currentTargetWord, gameLevel, getFeedbackMessage(forType: nil)), spriteImageName: "sprite-neutral")
    }
    
   //MARK: Public Functions
    func getGames() -> [Game]{
        return games
    }
    
    func updateCurrentMarker(withNewMarker newMarker: Marker) {
        currentMarker = newMarker
    }
    
    func resetGame() {
        randomizeGameData()
        gameLevel = 0
        gameScore = 0
        delegate?.handleUpdateViews(progressType: .inProgress(currentTargetLanguage, currentTargetWord, gameLevel, getFeedbackMessage(forType: nil)), spriteImageName: "sprite-neutral")
    }
    
    func updateMarkerEndPosition(endPosition position: Position) {
        if currentMarker != nil {
            currentMarker.endPosition = position
        }
    }
    
    func getCurrentMarker() -> Marker {
        return currentMarker
    }
    
    func handleUserFinishedAnswer() {
        if isCorrectAnswer() {
            handleIncrementScore()
        } else {
            delegate?.handleUpdateViews(progressType: .inProgress(currentTargetLanguage, currentTargetWord, gameLevel, getFeedbackMessage(forType: .fail)), spriteImageName: "sprite-lose")
        }
        clearUserAnswer()
    }
    
    func addGridToUserAnswer(withGrid grid: Position) {
        userAnswer.append(grid)
    }
    
    func handleIncrementScore() {
        gameScore += 1
        handleShouldIncrementGameLevel()
    }

    func clearCurrentMarker() {
        currentMarker = nil 
    }
    func getCurrentGamesCount() -> Int {
        return games.count
    }
    
    func getColumnCount() -> Int {
        return games[gameLevel].characterGrid.first?.count ?? 0
    }
    
    func getRowCount() -> Int {
        return games[gameLevel].characterGrid.count
    }
    
    func getGame(forLevel level: Int) -> Game {
        return games[level]
    }
    
    func getCurrentGame() -> Game {
        return games[gameLevel]
    }
    
    func getGameLevel() -> Int {
        return gameLevel
    }
    
    func handleShouldIncrementGameLevel() {
        if shouldIncrementGameLevel() {
            incrementGameLevel()
        }
    }
    
    func randomizeGameData() {
           games.shuffle()
    }
    
    //MARK: Private Helper Functions
    private func incrementGameLevel() {
        gameScore = 0
        gameLevel = gameLevel + 1
        if gameLevel == games.count {
            delegate?.handleUpdateViews(progressType: .finished, spriteImageName: "sprite-finish")
        }else {
            delegate?.handleUpdateViews(progressType: .inProgress(currentTargetLanguage, currentTargetWord, gameLevel, getFeedbackMessage(forType: .success)), spriteImageName: "sprite-win")
        }
    }
    
    private func shouldIncrementGameLevel() -> Bool {
        return gameScore == games[gameLevel].wordLocations.count
    }
    
    private func resetScore() {
        gameScore = 0
    }
    
    private func clearUserAnswer() {
        userAnswer = []
    }
    
    private func getFeedbackMessage(forType feedbackType: FeedbackType?) -> String {
        var message = "Find translation(s) for the given english word."
        guard let feedbackType = feedbackType else {
            return message
        }
        
        switch feedbackType {
        case .success:
            message =  successFeedbackStrings.randomElement() ?? message
        case .fail:
            message = failFeedbackStrings.randomElement() ?? message
        }
        
        return message
    }
    
    private func getGameData() {
        let gridData = Grid.all
        for grid in gridData {
            var wordLocations: [WordLocation] = []
            for (value,key) in grid.wordLocations {
                let positions = Position.parse(value)
                let firstPosition = positions.first
                let lastPosition = positions.last
                let location = Location(startLocation: firstPosition, endLocation:lastPosition)
                
                wordLocations.append(WordLocation(word: key, location: location))
            }
            
            let game = Game(gameSourceLanguage: grid.sourceLanguage, gameWord: grid.word, gameCharacterGrid: grid.characterGrid, gameWordLocations: wordLocations, gameTargetLanguage: grid.targetLanguage)
            games.append(game)
        }
    }
    
    private func isCorrectAnswer() -> Bool {
        var correctAnswers: [Location] = games[gameLevel].wordLocations.compactMap({$0.location})
           
           let userAnswers: Location = userAnswer.count == 2 ? Location(startLocation: userAnswer[LocationType.start.rawValue], endLocation: userAnswer[LocationType.end.rawValue]) : Location(startLocation: userAnswer[LocationType.start.rawValue], endLocation: userAnswer[LocationType.start.rawValue])
           
           if correctAnswers.contains(where: {$0.endLocation == userAnswers.endLocation && $0.startLocation == userAnswers.startLocation}) {
               correctAnswers = correctAnswers.filter({$0 != userAnswers})
               guard currentMarker != nil else {
                   return false
               }
               return true
           } else {
               return false
           }
       }
    
}

