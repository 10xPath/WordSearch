//
//  GameViewController.swift
//  WordSearch
//
//  Created by John N on 5/2/20.
//  Copyright © 2020 Examplingo. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var markerView: MarkerView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var promptView: UIView!
    @IBOutlet weak var feedbackView: UIView!
    @IBOutlet weak var scoreValueLabel: UILabel!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var englishWordLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var crosswordHeightConstraint: NSLayoutConstraint!
    
    private var viewModel: GameViewModel!
    private var cellSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupViews()
        setCrosswordHeightConstraint()
    }
    
    func setupViewModel() {
        viewModel = GameViewModel(assignedDelegate: self)
    }
    
    func setupViews() {
        setupHintButton()
        setupFeedbackView()
        setupMarkerView()
        setupScoreView()
        setupPromptView()
        setupCollectionView()
    }
    
    private func setCrosswordHeightConstraint() {
        DispatchQueue.main.async {
            let height = self.collectionView.collectionViewLayout.collectionViewContentSize.height
            self.crosswordHeightConstraint.constant = height
            self.view.setNeedsLayout()
        }
    }
    
    func setupMarkerView() {
        markerView.delegate = self
    }
    
    func setupScoreView() {
        scoreView.layer.cornerRadius = 8
        scoreView.layer.masksToBounds = true
        scoreView.backgroundColor = .themeGreen
    }
    
    func setupPromptView() {
        promptView.layer.cornerRadius = 8
        promptView.layer.masksToBounds = true
        promptView.backgroundColor = .themeGrey
    }
    
    func setupHintButton() {
        hintButton.setTitleColor(.themeYellow, for: .normal)
    }
    
    func setupFeedbackView() {
        feedbackView.layer.cornerRadius = 8
        feedbackView.layer.masksToBounds = true
        feedbackView.backgroundColor = .themePurple
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .themeBlue
        collectionView.register(UINib(nibName: "LetterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "letterCollectionViewCell")
        collectionView.layer.cornerRadius = 8
        collectionView.layer.masksToBounds = true
        collectionView.reloadData()
    }
    
    @IBAction func hintButtonAction(_ sender: Any) {
        let wordsArray = viewModel.getCurrentGame().wordLocations.compactMap({$0.word})
        let wordsString = wordsArray.joined(separator: ",")
        let hintString = wordsArray.count > 1 ? "The words are " +  wordsString : "The word is " + wordsString
        let alertController = UIAlertController(title: "Hint", message: hintString, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getColumnCount()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.getRowCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "letterCollectionViewCell", for: indexPath) as! LetterCollectionViewCell
        let letter = viewModel.getCurrentGame().characterGrid[indexPath.section][indexPath.row]
        cell.letterLabel.text = letter
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var collectionViewSize = collectionView.frame.size
        collectionViewSize.width = collectionViewSize.width/CGFloat((viewModel.getCurrentGame().characterGrid[0].count))
        collectionViewSize.height = collectionViewSize.width
        self.cellSize = collectionViewSize
        return collectionViewSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension GameViewController: MarkerViewDelegate {
    func touchesBeganAtPoint(point: CGPoint) {
        let gridPosition = self.gridPositionForItemAtPoint(point: point)
        self.storeGridPositionForItemAtPoint(point: point)
        let newMarker = Marker(markCellSize: cellSize)
        newMarker.startPosition = gridPosition
        newMarker.endPosition = gridPosition
        viewModel.updateCurrentMarker(withNewMarker: newMarker)
        
        markerView.addMark(mark: viewModel.getCurrentMarker())
    }
    func touchesMovedAtPoint(point: CGPoint) {
        let gridPosition: Position = self.gridPositionForItemAtPoint(point: point)
        viewModel.updateMarkerEndPosition(endPosition: gridPosition)
    }
    func touchesEndedAtPoint(point: CGPoint) {
        self.storeGridPositionForItemAtPoint(point: point)
        viewModel.handleUserFinishedAnswer()
        clearMark()
    }
    func touchesCanceled() {
        
    }
    
    
    // MARK: - Mark Image View Delegate Helpers
    
    private func storeGridPositionForItemAtPoint(point: CGPoint) {
        guard let indexPath = collectionView.indexPathForItem(at: point) else {
            return
        }
        let gridPosition = self.gridPositionForIndexPath(indexPath: indexPath)
        
        viewModel.addGridToUserAnswer(withGrid: gridPosition)
    }
    
    private func gridPositionForItemAtPoint(point: CGPoint) -> Position {
        guard let indexPath = collectionView.indexPathForItem(at: point) else {
            clearMark()
            return Position(column: 0, row: 0)
        }
        return gridPositionForIndexPath(indexPath: indexPath)
    }
    
    private func gridPositionForIndexPath(indexPath: IndexPath) -> Position {
        let gridPosition =  Position(column: indexPath.item, row: indexPath.section)
        return gridPosition
    }
    
    private func clearMark() {
        markerView.clear()
        viewModel.clearCurrentMarker()
    }
}

extension GameViewController: GameViewModelDelegate {
    func handleUpdateViews(progressType: ProgressType, spriteImageName: String) {
        characterImageView.image = UIImage(named: spriteImageName)
        switch progressType {
        case .inProgress(let targetLanguage, let targetWord, let score, let feedback):
            promptLabel.text = "\"\(feedback)\"-"
            englishWordLabel.text = "\"\(targetWord.uppercased())\""
            scoreValueLabel.text = "\(score)"
            targetLabel.text = "language: \(targetLanguage)"
            
            collectionView.isUserInteractionEnabled =  true
            collectionView.alpha = 1.0
            
            markerView.isUserInteractionEnabled = true
            
            promptLabel.isHidden = false
            hintButton.isHidden = false
            
            UIView.animate(withDuration: 1.0) {
                 self.characterImageView.transform = self.characterImageView.transform.rotated(by: CGFloat.pi)
                 self.characterImageView.transform = self.characterImageView.transform.rotated(by: CGFloat.pi)
             }
            
            collectionView.reloadData()
            
        case .finished:
            
            
            collectionView.isUserInteractionEnabled =  false
            collectionView.alpha = 0.5
            
            promptLabel.text = "\"GOOD JOB! You did it.\"-"
            markerView.isUserInteractionEnabled = false
            
            englishWordLabel.text = "--"
            hintButton.isHidden = true
        }
    }
}
