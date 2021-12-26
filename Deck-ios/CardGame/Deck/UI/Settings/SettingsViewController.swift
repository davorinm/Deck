//
//  SettingsViewController.swift
//  TestApp
//
//  Created by Davorin on 16/08/16.
//  Copyright © 2016 Davorin Mađarić. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    private let viewModel = SettingsViewModel()
    private var refreshControl: RefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        refreshControl = RefreshControl(with: table)
        refreshControl.refreshHandler = {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
                self.refreshControl.endRefreshing()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.refreshControl.startRefreshing()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(8), execute: {
            self.refreshControl.endRefreshing()
        })
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = viewModel.dataForItem(indexPath.row)
        switch cellData.type {
        case .player:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell") as? SettingsPlayerCell {
                cell.setData(cellData)
                return cell
            }
        }
        
        return UITableViewCell()
    }
}
