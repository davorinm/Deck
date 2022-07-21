//
//  GameEndViewController.swift
//  CardGame
//
//  Created by Davorin Madaric on 22/11/2021.
//  Copyright © 2021 Davorin Madaric. All rights reserved.
//

import UIKit

class GameEndViewController: UIViewController {
    
    
    
    
    
    
    
}

extension GameEndViewController {
    class func create() -> GameEndViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameEndViewController") as! GameEndViewController
        return vc
    }
}
