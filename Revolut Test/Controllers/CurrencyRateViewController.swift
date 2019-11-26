//
//  CurrencyRateViewController.swift
//  Revolut Test
//
//  Created by Steven Jemmott on 15/10/2019.
//  Copyright © 2019 Revolut Test. All rights reserved.
//

import UIKit

class CurrencyRateViewController: UIViewController {

    
    // MARK: - Outlets
    fileprivate lazy var addCurrencyPairView: AddCurrencyPairView = {
        let pairView = AddCurrencyPairView(layoutMode: .vertical)
        pairView.delegate = self
        pairView.translatesAutoresizingMaskIntoConstraints = false
        return pairView
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tv = UITableView(frame: self.view.frame, style: .plain)
        tv.dataSource = self
        tv.delegate = self
        tv.backgroundColor = .systemBackground
        tv.separatorStyle = .none
        tv.tableFooterView = UIView()
        tv.register(AddCurrencyPairCell.self, forCellReuseIdentifier: AddCurrencyPairCell.cellId)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var currencyTableViewController: CurrencyTableViewController = {
        let tableVC = CurrencyTableViewController()
        tableVC.delegate = self
        return tableVC
    }()
    
    
    // MARK: - Properties
    var currencyPairModel = CurrencyPairModel()
    
    fileprivate lazy var apiTimer: Timer = {
        var timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fetchRates), userInfo: nil, repeats: true)
        return timer
    }()
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .systemBackground
        setupTableView()
 
        apiTimer.fire()
//        apiTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fetchRates), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Invalidating...")
        apiTimer.invalidate()
    }

    
    // MARK: - Helper Methods
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    @objc fileprivate func fetchRates() {
        guard let urlString = currencyPairModel.getUrlComponent().url?.absoluteString else { return }
        
        CurrencyNetwork.shared.fetchData(from: urlString) { [weak self] (result: Result<[String: Double], Error>) in
            switch result {
            case .success(let rateResults):
                DispatchQueue.main.async {
                    let cells = self?.tableView.visibleCells as! [AddCurrencyPairCell]
                    for cell in cells {
                        for key in rateResults.keys {
                            if key == cell.currencyPair.currencyPairKey {
                                cell.currencyPair.addRate(rateResults)
                                
                                self?.tableView.beginUpdates()
                                cell.rate = cell.currencyPair?.getRate()
                                self?.tableView.endUpdates()
                                
                            }
                        }
                    }
                }
            case .failure(let error):
                self?.showAlert(with: "Error!", message: error.localizedDescription)
            }
        }
    }
}


// MARK: - Extension TableView DataSource & Delegate
extension CurrencyRateViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if currencyPairModel.isEmpty {
            tableView.setupEmptyState(with: addCurrencyPairView)
            return 0
        }
        
        tableView.restore()
        return currencyPairModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AddCurrencyPairCell.cellId, for: indexPath) as! AddCurrencyPairCell

        var currencyPair = currencyPairModel.currencyPair(at: indexPath.row)
        cell.currencyPair = currencyPair
        cell.rate = currencyPair.getRate()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = AddCurrencyPairView(layoutMode: .horizontal)
        header.backgroundColor = .systemBackground
        header.delegate = self
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if currencyPairModel.isEmpty {
            title = ""
            navigationController?.setNavigationBarHidden(true, animated: true)
            return 0
        }
        navigationController?.setNavigationBarHidden(false, animated: true)
        title = "Rates & converter"
        return 80
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            do {
                try currencyPairModel.removeCurrency(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .top)
            } catch {
                self.showAlert(with: "Error deleting currency!", message: error.localizedDescription)
            }
        }
    }
}


// MARK: - Extension Delegate Methods
extension CurrencyRateViewController: AddCurrencyPairViewDelegate, CurrencyTableDelegate {

    func addCurrencyPairButtonTapped() {
        let navController = UINavigationController(rootViewController: currencyTableViewController)
        currencyTableViewController.alreadySelected = currencyPairModel.getAllCurrencies()
        self.present(navController, animated: true, completion: nil)
    }
    
    func addCurrencyPair(_ currencyPair: CurrencyPair) {
        self.dismiss(animated: true) { [weak self] in
            
            do {
                try self?.currencyPairModel.add(currencyPair)
//                self?.tableView.beginUpdates()
//                self?.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
//                self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
//                self?.tableView.endUpdates()
                self?.tableView.reloadData()
                
            } catch {
                self?.showAlert(with: "Error adding currency pair!", message: error.localizedDescription)
            }
            
        }
    }
}
