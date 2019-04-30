//
//  SidebarVC.swift
//  PanelEdit
//
//  Created by James Froggatt on 30.04.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import UIKit

import Additions

class SidebarVC: UIViewController {
	typealias Robot = Sidebar
	
	private let tableView = UITableView()
	let store: DataStore
	init(store: DataStore = .shared) {
		self.store = store
		super.init(nibName: nil, bundle: nil)
		self.title = "Items"
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var items: [String] {return store.textItems}
	
	func reload(index: Int?) {
		let selection = tableView.indexPathForSelectedRow
		index
			=>? {tableView.reloadRow(at: $0, with: .none)}
			?? tableView.reloadData()
		selection
			=>? {tableView.selectRow(at: $0, animated: false, scrollPosition: .none)}
	}
	
	override func loadView() {
		tableView.dataSource = self
		tableView.delegate = self
		self.view = tableView
	}
}

extension SidebarVC: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell(style: .default, reuseIdentifier: nil) +> {
			$0.textLabel?.text = items[indexPath.row]
		}
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		Robot().selectRow(indexPath.row)
	}
}
