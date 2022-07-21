//
//  SettingsViewModel.swift
//  CardGame
//
//  Created by Davorin on 04/04/17.
//  Copyright © 2017 DavorinMadaric. All rights reserved.
//

import Foundation
import DMToolbox

enum SettingsPlayerDataType {
    case player
}

enum SettingsPlayerDataStatus: Int {
    case playing
    case waiting
    case notAvailable
}

class SettingsViewModel {
    
    private var data = [SettingsPlayerData(type: .player, title: "00", status: .notAvailable),
                        SettingsPlayerData(type: .player, title: "01", status: .playing),
                        SettingsPlayerData(type: .player, title: "02", status: .waiting),
                        SettingsPlayerData(type: .player, title: "03", status: .playing),
                        SettingsPlayerData(type: .player, title: "04", status: .notAvailable),
                        SettingsPlayerData(type: .player, title: "05", status: .notAvailable),
                        SettingsPlayerData(type: .player, title: "06", status: .waiting),
                        SettingsPlayerData(type: .player, title: "07", status: .notAvailable),
                        SettingsPlayerData(type: .player, title: "08", status: .notAvailable),
                        SettingsPlayerData(type: .player, title: "09", status: .waiting),
                        SettingsPlayerData(type: .player, title: "10", status: .notAvailable),
                        SettingsPlayerData(type: .player, title: "11", status: .notAvailable),
                        SettingsPlayerData(type: .player, title: "12", status: .waiting),
                        SettingsPlayerData(type: .player, title: "13", status: .notAvailable),
                        SettingsPlayerData(type: .player, title: "14", status: .playing),
                        SettingsPlayerData(type: .player, title: "15", status: .playing),
                        SettingsPlayerData(type: .player, title: "16", status: .waiting),
                        SettingsPlayerData(type: .player, title: "17", status: .notAvailable),
                        SettingsPlayerData(type: .player, title: "18", status: .playing),
                        SettingsPlayerData(type: .player, title: "19", status: .playing),
                        SettingsPlayerData(type: .player, title: "20", status: .notAvailable),
                        SettingsPlayerData(type: .player, title: "21", status: .notAvailable),
                        SettingsPlayerData(type: .player, title: "22", status: .playing),
                        SettingsPlayerData(type: .player, title: "23", status: .waiting),
                        SettingsPlayerData(type: .player, title: "24", status: .playing),
                        SettingsPlayerData(type: .player, title: "25", status: .notAvailable),
                        SettingsPlayerData(type: .player, title: "26", status: .notAvailable),
                        SettingsPlayerData(type: .player, title: "27", status: .waiting),
                        SettingsPlayerData(type: .player, title: "28", status: .notAvailable),
                        SettingsPlayerData(type: .player, title: "29", status: .notAvailable),
                        SettingsPlayerData(type: .player, title: "30", status: .waiting),
                        SettingsPlayerData(type: .player, title: "31", status: .notAvailable),
                        SettingsPlayerData(type: .player, title: "32", status: .notAvailable),
                        SettingsPlayerData(type: .player, title: "33", status: .waiting),
                        SettingsPlayerData(type: .player, title: "34", status: .notAvailable),
                        SettingsPlayerData(type: .player, title: "35", status: .playing),
                        SettingsPlayerData(type: .player, title: "36", status: .playing),
                        SettingsPlayerData(type: .player, title: "37", status: .waiting),
                        SettingsPlayerData(type: .player, title: "38", status: .notAvailable),
                        SettingsPlayerData(type: .player, title: "39", status: .playing),
                        SettingsPlayerData(type: .player, title: "40", status: .playing)]
    
    init() {
        let timer = Timer(fire: Date(), interval: 0.1, repeats: true) { (timer) in
            self.fireTimer()
        }
        
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
    }
    
    // MARK: - Timer
    
    @objc func fireTimer() {        
        let index = Random.randomInt(0, max: self.data.count-1)
        let status = Random.randomInt(0, max: 3-1)
        
        data[index].status.value = SettingsPlayerDataStatus(rawValue: status)!
    }
    
    // MARK: - Table
    
    func numberOfItems() -> Int {
        return data.count
    }
    
    func dataForItem(_ index: Int) -> SettingsPlayerData {
        return data[index]
    }
}
