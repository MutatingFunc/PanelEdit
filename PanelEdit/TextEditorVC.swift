//
//  TextEditorVC.swift
//  PanelEdit
//
//  Created by James Froggatt on 30.04.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import UIKit

import Additions

class TextEditorVC: UIViewController {
	typealias Robot = TextEditor
	
	private let textView = UITextView()
	let store: DataStore
	let onChange: (Int) -> ()
	init(store: DataStore = .shared, onChange: @escaping (Int) -> ()) {
		self.store = store
		self.onChange = onChange
		super.init(nibName: nil, bundle: nil)
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var index: Int? = nil {
		didSet {
			title = index =>? String.init ?? "No selection"
			navigationItem.largeTitleDisplayMode = .always
			textView.isEditable = index != nil
			textView.text = index =>? {DataStore.shared.textItems[$0]}
		}
	}
	
	override func loadView() {
		textView.delegate = self
		self.view = textView
	}
}

extension TextEditorVC: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		guard let index = index else {return}
		DataStore.shared.textItems[index] = textView.text
		DispatchQueue.main.async {[onChange] in
			onChange(index)
		}
	}
}
