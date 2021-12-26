//
//  SettingsPlayerCell.swift
//  CardGame
//
//  Created by Davorin on 04/04/17.
//  Copyright © 2017 DavorinMadaric. All rights reserved.
//

import UIKit
import DMToolbox

class SettingsPlayerCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    private var dataObserver: DisposableEvent?
    
    deinit {
        dataObserver = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataObserver = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dataObserver = nil
    }
    
    func setData(_ cellData: SettingsPlayerData) {
        nameLabel.text = cellData.title
        dataObserver = cellData.status.subscribeWithRaise({ [unowned self] (data) in
            self.updateStatus(status: data)
        })
    }
    
    private func updateStatus(status: SettingsPlayerDataStatus) {
        UIView.animate(withDuration: 0.1, animations: {
            switch status {
            case .notAvailable:
                self.backgroundColor = UIColor.red
            case .playing:
                self.backgroundColor = UIColor.blue
            case .waiting:
                self.backgroundColor = UIColor.green
            }
        }) 
    }
}

class SettingsPlayerData {
    
    let type: SettingsPlayerDataType
    let title: String
    var status: ObservableProperty<SettingsPlayerDataStatus>
    
    init(type: SettingsPlayerDataType, title: String, status: SettingsPlayerDataStatus) {
        self.type = type
        self.title = title
        self.status = ObservableProperty(value: status)
    }
}
