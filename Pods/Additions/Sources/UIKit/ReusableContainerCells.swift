//
//  ReusableContainerCells.swift
//  Additions
//
//  Created by James Froggatt on 30.01.2019.
//

#if canImport(UIKit)
import UIKit

public class TableViewCell<ViewType: UIView>: UITableViewCell, ReuseIdentifiable {
	private var containedView: ViewType!
	@available(iOSApplicationExtension 9, iOS 9, *)
	public func withInitialContent(_ view: ViewType) -> Self {
		if self.containedView == nil {
			return self.withContent(view)
		}
		return self
	}
	@available(iOSApplicationExtension 9, iOS 9, *)
	public func withContent(_ view: ViewType) -> Self {
		if self.containedView === view {
			return self
		} else {
			self.containedView?.removeFromSuperview()
		}
		view.removeFromSuperview()
		self.containedView = view
		self.contentView.addSubview(containedView.autolayout(), constraining: .allSides)
		return self
	}
}

public class CollectionViewCell<ViewType: UIView>: UICollectionViewCell, ReuseIdentifiable {
	private var containedView: ViewType!
	@available(iOSApplicationExtension 9, iOS 9, *)
	public func withInitialContent(_ view: ViewType) -> Self {
		if self.containedView == nil {
			return self.withContent(view)
		}
		return self
	}
	@available(iOSApplicationExtension 9, iOS 9, *)
	public func withContent(_ view: ViewType) -> Self {
		if self.containedView === view {
			return self
		} else {
			self.containedView?.removeFromSuperview()
		}
		view.removeFromSuperview()
		self.containedView = view
		self.contentView.addSubview(containedView.autolayout(), constraining: .allSides)
		return self
	}
}
#endif
