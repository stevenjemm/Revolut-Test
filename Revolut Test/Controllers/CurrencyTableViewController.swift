//
//  CurrencyTableViewController.swift
//  Revolut Test
//
//  Created by Steven Jemmott on 15/10/2019.
//  Copyright © 2019 Revolut Test. All rights reserved.
//

import UIKit

protocol CurrencyTableDelegate: class {
    func addCurrencyPair(_ currencyPair: CurrencyPair)
}

class CurrencyTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    fileprivate let cellId = "cellId"
    var alreadySelected: [CurrencyPair]?
    var currencyModel = CurrencyModel()
    
    weak var delegate: CurrencyTableDelegate?
    var currenciesToDeselect: [Currency] = [Currency]()
    
    fileprivate var selectedCurrency: (from: Currency?, to: Currency?) {
        didSet {
            guard let from = selectedCurrency.from else { return }
            guard let to = selectedCurrency.to else { return }
            let currencyPair = CurrencyPair(from: from, to: to)
            
            delegate?.addCurrencyPair(currencyPair)
        }
    }
    
    
    // MARK: - Outlets
    fileprivate lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.backgroundColor = .systemBackground
        tv.separatorStyle = .none
        tv.tableFooterView = UIView()
//        tv.rowHeight = 70
        tv.allowsMultipleSelection = true
        tv.register(CurrencyTableViewCell.self, forCellReuseIdentifier: cellId)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    fileprivate lazy var closeButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissModalView))
        barButton.tintColor = ColorTheme.accent
        return barButton
    }()
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        if #available(iOS 13, *) {} else {
            navigationItem.rightBarButtonItem = closeButton
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        title = "Select your currency pair"
        tableView.scrollToRow(at: .init(row: 0, section: 0), at: .top, animated: false)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let indexPaths = tableView.indexPathsForSelectedRows {
            for selectedRow in indexPaths {
                tableView.deselectRow(at: selectedRow, animated: true)
            }
            
            selectedCurrency.from = nil
            selectedCurrency.to = nil
        }
        
        removeDeselectState(from: currencyModel.getAll())
        
    }
    
    
    // MARK: - Helper Methods
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    fileprivate func removeDeselectState(from currencyRows: [Currency]) {
        
        for currency in currenciesToDeselect {
            if let cellIndex = currencyRows.firstIndex(where: { $0.shortCode == currency.shortCode }) {
                let cellIndexPath = IndexPath(row: cellIndex, section: 0)
                
                var cellsToDeselect = tableView.visibleCells as! [CurrencyTableViewCell]
                if let cellToDeselect = tableView.cellForRow(at: cellIndexPath) as? CurrencyTableViewCell {
                    if cellsToDeselect.contains(cellToDeselect) {
                        cellToDeselect.alreadyExists = false
                    }
                } else {
                    cellsToDeselect = cellsToDeselect.filter({ $0.currency?.shortCode == currency.shortCode })
                    let _ = cellsToDeselect.map({ $0.alreadyExists = false })
                }
            }
        }
        
        currenciesToDeselect.removeAll()
    }
    
    fileprivate func getCellsToDeselect(_ currency: Currency) {
        guard alreadySelected != nil else { return }

        currenciesToDeselect = currencyModel.getCorrespondingCurrencies(for: currency, in: alreadySelected!)
        
        if !currenciesToDeselect.isEmpty {
            for currency in currenciesToDeselect {
                if let cellIndex = currencyModel.getAll().firstIndex(where: { $0.shortCode == currency.shortCode }) {
                    let cellIndexPath = IndexPath(row: cellIndex, section: 0)
                    
                    var cellsToDeselect = tableView.visibleCells as! [CurrencyTableViewCell]
                    if let cellToDeselect = tableView.cellForRow(at: cellIndexPath) as? CurrencyTableViewCell {
                        if cellsToDeselect.contains(cellToDeselect) {
                            cellToDeselect.alreadyExists = true
                        }
                    } else {
                        cellsToDeselect = cellsToDeselect.filter({ $0.currency?.shortCode == currency.shortCode })
                        let _ = cellsToDeselect.map({ $0.alreadyExists = true })
                    }
                }
            }
        }
    }
    
    @objc fileprivate func dismissModalView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - TableView Delegate & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CurrencyTableViewCell
        
        let currency = currencyModel.currency(at: indexPath.row)
        cell.currency = currency
        cell.alreadyExists = false
  
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! CurrencyTableViewCell

        let currency = currencyModel.currency(at: indexPath.row)

        if currenciesToDeselect.contains(where: { $0.shortCode == currency.shortCode }) {
            cell.alreadyExists = true
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {

        guard let _ = selectedCurrency.to else { return indexPath }

        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CurrencyTableViewCell
        
        
        if let cellCurrency = cell.currency {
            
            guard let _ = selectedCurrency.from else {
                
                selectedCurrency.from = cellCurrency
                getCellsToDeselect(cellCurrency)

                return
            }
            
            guard let _ = selectedCurrency.to else {
                selectedCurrency.to = cellCurrency
                return
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CurrencyTableViewCell
        
        if let alreadySelected = alreadySelected {
            if alreadySelected.contains(where: { $0.from.shortCode == cell.currency?.shortCode }) {
                removeDeselectState(from: currencyModel.getAll())
            }
        }
        
        if let _ = cell.currency {
            guard let _ = selectedCurrency.to else {
                selectedCurrency.from = nil
                return
            }
            selectedCurrency.to = nil
        }
        
    }
}
