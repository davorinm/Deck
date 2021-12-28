//
//  GameViewController.swift
//  TestApp
//
//  Created by Davorin on 15/08/16.
//  Copyright © 2016 Davorin Mađarić. All rights reserved.
//

import UIKit
import DeckGame
import DeckCommon

class GameViewController: UIViewController {
    @IBOutlet private weak var gameEndLabel: UILabel!
    
    private var tableView: TableView = TableView(frame: .zero)
    private var deckView: DeckView = DeckView(frame: .zero)
    private var scoreboardView: ScoreboardView = ScoreboardView(frame: .zero)
    
    private var firstPlayerView: PlayerView!
    private var secondPlayerView: PlayerView!
    private var thirdPlayerView: PlayerView!
    private var fourthPlayerView: PlayerView!
    
    private let model: GameViewModel
    
    init(gameMode: GameMode) {
        self.model = GameViewModel(gameMode: gameMode,
                                   deck: Deck(view: deckView),
                                   table: Table(view: tableView))
        
        super.init(nibName: nil, bundle: nil)
        
        // GameViewModel stuff
        
        self.model.playersRegistered = playersRegistered
        
        self.model.gameEnd = { [unowned self] in
            self.gameEndLabel.isHidden = false
            self.gameEndLabel.text = "GAME OVER"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Table View
        
        tableView.awakeFromNib()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        // Deck View
        
        deckView.awakeFromNib()
        deckView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(deckView)
        
        deckView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 80).isActive = true
        deckView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        deckView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        deckView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // Scoreboard View
        
        scoreboardView.awakeFromNib()
        scoreboardView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scoreboardView)
        
        scoreboardView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -80).isActive = true
        scoreboardView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        scoreboardView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        scoreboardView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        model.startGame()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let touchView = touch.view {
            if touchView != firstPlayerView {
                
                firstPlayerView.cancelAction()
                
                print("TTTTTT")
            }
            
            if touchView is DeckView {
                return
            }
            
            if touchView.superview is DeckView {
                return
            }
        }
        
        // TODO: Check if not firstPlayerView cancel action in firstPlayerView
    }
    
    // MARK: - Actions
    
    @IBAction func gameOptionsPressed(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
    private func playersRegistered(players: [Player], gameType: GameType) {
        // Players Views
        
        switch gameType {
        case .twoPlayers:
            firstPlayerView = PlayerView(frame: .zero)
            firstPlayerView.awakeFromNib()
            firstPlayerView.orientation = .bottom
            firstPlayerView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(firstPlayerView)
            
            firstPlayerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            firstPlayerView.widthAnchor.constraint(equalToConstant: 500).isActive = true
            firstPlayerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
            firstPlayerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            
            secondPlayerView = PlayerView(frame: .zero)
            secondPlayerView.awakeFromNib()
            secondPlayerView.orientation = .top
            secondPlayerView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(secondPlayerView)
            
            secondPlayerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            secondPlayerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            secondPlayerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            secondPlayerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
            
        case .threePlayers:
            firstPlayerView = PlayerView(frame: .zero)
            firstPlayerView.awakeFromNib()
            firstPlayerView.orientation = .bottom
            firstPlayerView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(firstPlayerView)
            
            firstPlayerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            firstPlayerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            firstPlayerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
            firstPlayerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            
            secondPlayerView = PlayerView(frame: .zero)
            secondPlayerView.awakeFromNib()
            secondPlayerView.orientation = .topLeft
            secondPlayerView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(secondPlayerView)
            
            secondPlayerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            secondPlayerView.widthAnchor.constraint(equalToConstant: 140).isActive = true
            secondPlayerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            secondPlayerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            thirdPlayerView = PlayerView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            thirdPlayerView.awakeFromNib()
            thirdPlayerView.orientation = .topRight
            thirdPlayerView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(thirdPlayerView)
            
            thirdPlayerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            thirdPlayerView.widthAnchor.constraint(equalToConstant: 140).isActive = true
            thirdPlayerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            thirdPlayerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
        case .fourPlayers:
            firstPlayerView = PlayerView(frame: .zero)
            firstPlayerView.awakeFromNib()
            firstPlayerView.orientation = .bottom
            firstPlayerView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(firstPlayerView)
            
            firstPlayerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            firstPlayerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            firstPlayerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
            firstPlayerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            
            secondPlayerView = PlayerView(frame: .zero)
            secondPlayerView.awakeFromNib()
            secondPlayerView.orientation = .top
            secondPlayerView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(secondPlayerView)
            
            secondPlayerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            secondPlayerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            secondPlayerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            secondPlayerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
            
            thirdPlayerView = PlayerView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            thirdPlayerView.orientation = .left
            thirdPlayerView.awakeFromNib()
            thirdPlayerView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(thirdPlayerView)
            
            thirdPlayerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            thirdPlayerView.widthAnchor.constraint(equalToConstant: 70).isActive = true
            thirdPlayerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            thirdPlayerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            
            fourthPlayerView = PlayerView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            fourthPlayerView.orientation = .right
            fourthPlayerView.awakeFromNib()
            fourthPlayerView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(fourthPlayerView)
            
            fourthPlayerView.widthAnchor.constraint(equalToConstant: 70).isActive = true
            fourthPlayerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            fourthPlayerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            fourthPlayerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        }
        
        // Assign players to views
        // TODO: Make it better!!!, move to upper switch, ...
        for (i, player) in players.enumerated() {
            switch i {
            case 0:
                player.connectPlayerView(playerView: self.firstPlayerView)
                self.firstPlayerView.setPlayer(player)
            case 1:
                player.connectPlayerView(playerView: self.secondPlayerView)
                self.secondPlayerView.setPlayer(player)
            case 2:
                player.connectPlayerView(playerView: self.thirdPlayerView)
                self.thirdPlayerView.setPlayer(player)
            case 3:
                player.connectPlayerView(playerView: self.fourthPlayerView)
                self.fourthPlayerView.setPlayer(player)
            default:
                assertionFailure("More than 4 players?!?")
            }
        }
    }
}
