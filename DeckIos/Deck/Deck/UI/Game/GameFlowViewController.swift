//
//  GameFlowViewController.swift
//  CardGame
//
//  Created by Davorin Madaric on 22/11/2021.
//  Copyright © 2021 Davorin Madaric. All rights reserved.
//

import UIKit
import DMToolbox

class GameFlowViewController: UIViewController {
    @IBOutlet private weak var containerView: UIView!
    
    var gameMode: GameMode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gameService: GameService = ServiceLocator.current.get()
        gameService.state.subscribe(self) { [unowned self] (gameState) in
            self.stateUpdated(gameState: gameState)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let gameService: GameService = ServiceLocator.current.get()
        gameService.prepareGame(gameMode: gameMode)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let gameService: GameService = ServiceLocator.current.get()
        gameService.disassembleGame()
    }
    
    // MARK: - Model state updated
    
    private func stateUpdated(gameState: GameState) {
        switch gameState {
        case .initialized:
            break
        case .assembling(let gameMode):
            switch gameMode {
            case .quick:
                let vc = GameAssemblyViewController.create()
                self.embed(container: containerView, child: vc)
            case .network:
                let vc = NetworkGameViewController.create()
                self.embed(container: containerView, child: vc)
            }
        case .playing(let gameType):
            let vc = GameViewController(gameMode: .quick(gameType: gameType))
            self.embed(container: containerView, child: vc)
            break
        case .gameEnd:
            let vc = GameEndViewController.create()
            self.embed(container: containerView, child: vc)
        }
    }
}

extension GameFlowViewController {
    class func create(gameMode: GameMode) -> GameFlowViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameFlowViewController") as! GameFlowViewController
        vc.gameMode = gameMode
        return vc
    }
}
