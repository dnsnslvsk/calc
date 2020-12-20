//
//  HistoryTableViewController.swift
//  calc
//
//  Created by Nesiolovsky on 10.12.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
	
	// MARK: - Internal properties
	
	var delegate: IHistoryCellDelegate?
	var models: [HistoryCellModel] = []
	var model = HistoryCellModel(formattedResult: "", inputValues: [], outputValues: [])
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.separatorInset = UIEdgeInsets.zero
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "historyCell")
		tableView.rowHeight = UITableView.automaticDimension
	}
}

extension HistoryTableViewController {
	
	// MARK: - UITableViewDelegate implementation
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		model = models[indexPath.row]
		navigationController?.popViewController(animated: true)
		delegate?.didSelectHistoryCell(model)
	}
}

extension HistoryTableViewController {
	
	// MARK: - UITableViewDataSource implementation
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return models.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
		cell.textLabel?.text = models[indexPath.row].formattedResult
		cell.textLabel?.numberOfLines = 0
		return cell
	}
}


// MARK: - IHistoryCellDelegate

protocol IHistoryCellDelegate {
	func didSelectHistoryCell(_ historyCell: HistoryCellModel)
}


