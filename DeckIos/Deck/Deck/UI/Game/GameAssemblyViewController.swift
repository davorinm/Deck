//
//  GameAssemblyViewController.swift
//  CardGame
//
//  Created by Davorin Madaric on 22/11/2021.
//  Copyright © 2021 Davorin Madaric. All rights reserved.
//

import UIKit
import DMToolbox

class GameAssemblyViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Initialize notifications
        let gameService: GameService = ServiceLocator.current.get()
        gameService.registerPlayer(name: "123qwe234")
    }
}

extension GameAssemblyViewController {
    class func create() -> GameAssemblyViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameAssemblyViewController") as! GameAssemblyViewController
        return vc
    }
}
