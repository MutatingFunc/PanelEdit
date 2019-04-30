//
//  Convenience.swift
//  StandardAdditions
//
//  Created by James Froggatt on 12.07.2016.
//  Copyright © 2016 James Froggatt. All rights reserved.
//

#if canImport(UIKit)
import UIKit

#if canImport(CoreGraphics)
import CoreGraphics

public extension CGRect {
	func insetBy(_ edgeInsets: UIEdgeInsets) -> CGRect {
		return insetBy(top: edgeInsets.top, left: edgeInsets.left, bottom: edgeInsets.bottom, right: edgeInsets.right)
	}
}
#endif

public extension UIAlertController {
	convenience init(_ title: String?, message: String? = nil, style: UIAlertController.Style = .alert) {
		self.init(title: title, message: message, preferredStyle: style)
	}
	@discardableResult func addAction(_ title: String?, style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> ())? = nil) -> UIAlertController {
		self.addAction(UIAlertAction(title: title, style: style, handler: handler))
		return self
	}
	@discardableResult func addAction(if condition: Bool, _ title: String?, style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> ())? = nil) -> UIAlertController {
		if condition {self.addAction(UIAlertAction(title: title, style: style, handler: handler))}
		return self
	}
}

public extension UIViewController {
	@nonobjc func present(in presentingViewController: UIViewController, from source: UIBarButtonItem, animated: Bool, completion: (() -> ())? = nil) {
		self.modalPresentationStyle = presentingViewController.traitCollection.horizontalSizeClass == .compact ? .overCurrentContext : .popover
		self.present(in: presentingViewController, animated: animated, completion: completion)
		self.popoverPresentationController?.barButtonItem = source
	}
	@nonobjc func present(in presentingViewController: UIViewController, from source: UIView, animated: Bool, completion: (() -> ())? = nil) {
		self.modalPresentationStyle = .popover
		self.present(in: presentingViewController, animated: animated, completion: completion)
		self.popoverPresentationController?.setSource(source)
	}
	
	func present(in presentingViewController: UIViewController, animated: Bool, completion: (() -> ())? = nil) {
		presentingViewController.present(self, animated: animated, completion: completion)
	}
}

public extension UIPopoverPresentationController {
	func setSource(_ source: UIView?) {
		self.sourceView = source
		self.sourceRect = source?.bounds ?? .zero
	}
}

public extension UIView {
	@discardableResult func autolayout() -> Self {
		self.translatesAutoresizingMaskIntoConstraints = false
		return self
	}
}

public extension UICollectionView {
	func insertItem(at indices: IndexPath...) {
		self.insertItems(at: indices)
	}
	func reloadItem(at indices: IndexPath...) {
		self.reloadItems(at: indices)
	}
	func deleteItem(at indices: IndexPath...) {
		self.deleteItems(at: indices)
	}
	func insertItem(at indices: Int..., in section: Int = 0) {
		self.insertItems(at: indices.map{IndexPath(row: $0, section: section)})
	}
	func reloadItem(at indices: Int..., in section: Int = 0) {
		self.reloadItems(at: indices.map{IndexPath(row: $0, section: section)})
	}
	func deleteItem(at indices: Int..., in section: Int = 0) {
		self.deleteItems(at: indices.map{IndexPath(row: $0, section: section)})
	}
}
public extension UITableView {
	func insertRow(at indices: IndexPath..., with animation: UITableView.RowAnimation = .automatic) {
		self.insertRows(at: indices, with: animation)
	}
	func reloadRow(at indices: IndexPath..., with animation: UITableView.RowAnimation = .automatic) {
		self.reloadRows(at: indices, with: animation)
	}
	func deleteRow(at indices: IndexPath..., with animation: UITableView.RowAnimation = .automatic) {
		self.deleteRows(at: indices, with: animation)
	}
	func insertRow(at indices: Int..., in section: Int = 0, with animation: UITableView.RowAnimation = .automatic) {
		self.insertRows(at: indices.map{IndexPath(row: $0, section: section)}, with: animation)
	}
	func reloadRow(at indices: Int..., in section: Int = 0, with animation: UITableView.RowAnimation = .automatic) {
		self.reloadRows(at: indices.map{IndexPath(row: $0, section: section)}, with: animation)
	}
	func deleteRow(at indices: Int..., in section: Int = 0, with animation: UITableView.RowAnimation = .automatic) {
		self.deleteRows(at: indices.map{IndexPath(row: $0, section: section)}, with: animation)
	}
}

public extension UIStoryboardSegue {
	var targetNav: UINavigationController? {
		return destination as? UINavigationController
	}
	var target: UIViewController? {
		return targetNav?.topViewController ?? destination
	}
	var targetPopover: UIPopoverPresentationController? {
		return destination.popoverPresentationController
	}
}


#endif
