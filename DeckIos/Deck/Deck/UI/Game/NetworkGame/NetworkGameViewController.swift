//
//  NetworkGameViewController.swift
//  TestApp
//
//  Created by Davorin on 15/08/16.
//  Copyright © 2016 Davorin Mađarić. All rights reserved.
//

import UIKit

class NetworkGameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NetworkGameViewModelDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel: NetworkGameViewModel = NetworkGameViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 30
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "MultiplayerViewCell", bundle: nil), forCellReuseIdentifier: "multiplayerCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        viewModel.load()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.unload()
    }
    
    // MARK: - MultiplayerViewModelDelegate
    
    func showError(error: Error) {
        
    }
    
    func showLoading(isLoading: Bool) {
        
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func beginGame(gameId: String) {
        let gameVC = GameViewController(gameMode: .network)
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
    
    func disconnected() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = viewModel.dataAtIndex(index: indexPath.row) else {
            assertionFailure("Data not found")
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "multiplayerCell") as? MultiplayerViewCell else {
            assertionFailure("Cell not found")
            return UITableViewCell()
        }
        
        cell.setData(data: data)
            
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let data = viewModel.dataAtIndex(index: indexPath.row) else {
            return
        }
        
        viewModel.gameRequest(userId: data.userId)
    }
}

extension NetworkGameViewController {
    class func create() -> NetworkGameViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NetworkGameViewController") as! NetworkGameViewController
        return vc
    }
}
