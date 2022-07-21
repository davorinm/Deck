//
//  LobbyViewController.swift
//  TestApp
//
//  Created by Davorin on 15/08/16.
//  Copyright © 2016 Davorin Mađarić. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController {
    
    private let transitionAnimation = ViewControllerTransitionAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "Wood")!)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Actions
    
    @IBAction func twoPlayerGamePressed(_ sender: Any) {
        let gameC = GameFlowViewController.create(gameMode: .quick(gameType: .twoPlayers))
        self.show(gameC, sender: nil)
    }
    
    @IBAction func threePlayerGamePressed(_ sender: Any) {
        let gameVC = GameFlowViewController.create(gameMode: .quick(gameType: .threePlayers))
        self.show(gameVC, sender: nil)
    }
    
    @IBAction func fourPlayerGamePressed(_ sender: Any) {
        let gameVC = GameFlowViewController.create(gameMode: .quick(gameType: .fourPlayers))
        self.show(gameVC, sender: nil)
    }
    
    @IBAction func networkGamePressed(_ sender: Any) {
        let gameVC = GameFlowViewController.create(gameMode: .network)
        self.show(gameVC, sender: nil)
    }
}
