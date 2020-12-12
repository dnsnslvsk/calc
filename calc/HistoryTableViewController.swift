//
//  HistoryTableViewController.swift
//  calc
//
//  Created by Nesiolovsky on 10.12.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    var delegate: IHistoryCellDelegate?
    var models: [HistoryModel] = []
    var model = HistoryModel(formattedResult: "", inputValues: [], outputValues: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorInset = UIEdgeInsets.zero
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(models[indexPath.row])
        model = models[indexPath.row]
        navigationController?.popViewController(animated: true)
        delegate?.didSelectCell(model)

    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].formattedResult
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

protocol IHistoryCellDelegate {
    func didSelectCell(_ historyCell: HistoryModel)
}


