//
//  ClosureExtensions.swift
//  Additions
//
//  Created by James Froggatt on 16.04.2019.
//

#if canImport(UIKit)
import UIKit

public class UIHandler: NSObject {
	fileprivate static let defaultID = "UIHandler ID"
	
	private let handler: () -> ()
	init(handler: @escaping () -> ()) {
		self.handler = handler
		super.init()
	}
	
	@objc func handle() {
		handler()
	}
}
public protocol UIInvalidatableHandler: UIHandler {
	func invalidate()
}

public class UIControlHandler: UIHandler, UIInvalidatableHandler {
	fileprivate let id: String
	private let control: UIControl
	private let events: UIControl.Event
	init(observing control: UIControl, _ events: UIControl.Event, with handler: @escaping () -> ()) {
		self.id = "\(events.rawValue)"
		self.control = control
		self.events = events
		super.init(handler: handler)
	}
	
	public func invalidate() {
		control.removeHandler(self, for: events)
	}
}
public extension UIControl {
	@discardableResult
	func addHandler(for events: UIControl.Event, _ handler: @escaping () -> ()) -> UIControlHandler {
		let handler = UIControlHandler(observing: self, events, with: handler)
		objc_setAssociatedObject(self, handler.id, handler, .OBJC_ASSOCIATION_RETAIN)
		self.addTarget(handler, action: #selector(handler.handle), for: events)
		return handler
	}
	
	@discardableResult
	func removeHandler(_ handler: UIControlHandler, for events: UIControl.Event) -> Bool {
		var isPresent = false
		isPresent = objc_getAssociatedObject(self, handler.id) != nil
		self.removeTarget(handler, action: #selector(handler.handle), for: events)
		objc_setAssociatedObject(self, handler.id, nil, .OBJC_ASSOCIATION_RETAIN)
		return isPresent
	}
}

public class UIGestureHandler: UIHandler, UIInvalidatableHandler {
	private let recognizer: UIGestureRecognizer
	init(observing recognizer: UIGestureRecognizer, with handler: @escaping () -> ()) {
		self.recognizer = recognizer
		super.init(handler: handler)
	}
	
	public func invalidate() {
		recognizer.removeHandler(self)
	}
}
public extension UIGestureRecognizer {
	@discardableResult
	func addHandler(_ handler: @escaping () -> ()) -> UIGestureHandler {
		let handler = UIGestureHandler(observing: self, with: handler)
		objc_setAssociatedObject(self, UIHandler.defaultID, handler, .OBJC_ASSOCIATION_RETAIN)
		self.addTarget(handler, action: #selector(handler.handle))
		return handler
	}
	
	@discardableResult
	func removeHandler(_ handler: UIGestureHandler) -> Bool {
		var isPresent = false
		isPresent = objc_getAssociatedObject(self, UIHandler.defaultID) != nil
		self.removeTarget(handler, action: #selector(handler.handle))
		objc_setAssociatedObject(self, UIHandler.defaultID, nil, .OBJC_ASSOCIATION_RETAIN)
		return isPresent
	}
}
#endif
