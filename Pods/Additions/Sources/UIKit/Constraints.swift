//
//  Constraints.swift
//  StandardAdditions
//
//  Created by James Froggatt on 16.08.2016.
//  Copyright © 2016 James Froggatt. All rights reserved.
//

#if !swift(>=4.2)
extension NSLayoutConstraint {
	public typealias Axis = UILayoutConstraintAxis
}
#endif
#if canImport(UIKit)
import UIKit

@available(iOSApplicationExtension 9, iOS 9, *)
public protocol LayoutAnchorFrame {
	var topAnchor: NSLayoutYAxisAnchor {get}
	var bottomAnchor: NSLayoutYAxisAnchor {get}
	var centerYAnchor: NSLayoutYAxisAnchor {get}
	var centerXAnchor: NSLayoutXAxisAnchor {get}
	var leadingAnchor: NSLayoutXAxisAnchor {get}
	var trailingAnchor: NSLayoutXAxisAnchor {get}
	var leftAnchor: NSLayoutXAxisAnchor {get}
	var rightAnchor: NSLayoutXAxisAnchor {get}
	var heightAnchor: NSLayoutDimension {get}
	var widthAnchor: NSLayoutDimension {get}
}

@available(iOSApplicationExtension 9, iOS 9, *)
extension UIView: LayoutAnchorFrame {}
@available(iOSApplicationExtension 9, iOS 9, *)
extension UILayoutGuide: LayoutAnchorFrame {}

@available(iOSApplicationExtension 9, iOS 9, *)
public struct LayoutAnchorFrameSide: OptionSet {
	
	public struct Vertical: OptionSet {
		public typealias `Self` = Vertical
		public let rawValue: UInt8
		public init(rawValue: UInt8) {
			self.rawValue = rawValue
		}
		public init(componentOf sides: LayoutAnchorFrameSide) {
			self = []
			if sides.contains(.top) {self.insert(.top)}
			if sides.contains(.bottom) {self.insert(.bottom)}
		}
		
		public static let verticalSides   = [.top, .bottom] as Self
		
		public static let top      = Self(rawValue: 1 << 0)
		public static let bottom   = Self(rawValue: 1 << 1)
	}
	
	public struct Horizontal: OptionSet {
		public typealias `Self` = Horizontal
		public let rawValue: UInt8
		public init(rawValue: UInt8) {
			self.rawValue = rawValue
		}
		public init(componentOf sides: LayoutAnchorFrameSide) {
			self = []
			if sides.contains(.leading) {self.insert(.leading)}
			if sides.contains(.trailing) {self.insert(.trailing)}
			if sides.contains(.left) {self.insert(.left)}
			if sides.contains(.right) {self.insert(.right)}
		}
			
		public static let horizontalSides = [.leading, .trailing] as Self
		
		public static let leading  = Self(rawValue: 1 << 0)
		public static let trailing = Self(rawValue: 1 << 1)
		public static let left     = Self(rawValue: 1 << 2)
		public static let right    = Self(rawValue: 1 << 3)
	}
	
	public typealias `Self` = LayoutAnchorFrameSide
	public let rawValue: UInt8
	public init(rawValue: UInt8) {
		self.rawValue = rawValue
	}
	
	public init(_ horizontal: Horizontal, _ vertical: Vertical) {
		self = []
		if vertical.contains(.top) {self.insert(.top)}
		if vertical.contains(.bottom) {self.insert(.bottom)}
		if horizontal.contains(.leading) {self.insert(.leading)}
		if horizontal.contains(.trailing) {self.insert(.trailing)}
		if horizontal.contains(.left) {self.insert(.left)}
		if horizontal.contains(.right) {self.insert(.right)}
	}
	public init(_ horizontal: Horizontal) {self.init(horizontal, [])}
	public init(_ vertical: Vertical) {self.init([], vertical)}
	
	public init(_ dimensions: LayoutAnchorFrameDimension) {
		self = []
		if dimensions.contains(.height) {self.insert(.verticalSides)}
		if dimensions.contains(.width) {self.insert(.horizontalSides)}
	}
	
	public var verticalComponent: Vertical {
		return Vertical(componentOf: self)
	}
	public var horizontalComponent: Horizontal {
		return Horizontal(componentOf: self)
	}
	
	public static let allSides = [.verticalSides, .horizontalSides] as Self
	public static let verticalSides   = Self(Vertical.verticalSides)
	public static let horizontalSides = Self(Horizontal.horizontalSides)
	
	public static let top      = Self(rawValue: 1 << 0)
	public static let bottom   = Self(rawValue: 1 << 1)
	public static let leading  = Self(rawValue: 1 << 2)
	public static let trailing = Self(rawValue: 1 << 3)
	public static let left     = Self(rawValue: 1 << 4)
	public static let right    = Self(rawValue: 1 << 5)
}
@available(iOSApplicationExtension 9, iOS 9, *)
public struct LayoutAnchorFrameCenter: OptionSet {
	public typealias `Self` = LayoutAnchorFrameCenter
	public let rawValue: UInt8
	public init(rawValue: UInt8) {
		self.rawValue = rawValue
	}
	public init(_ dimensions: LayoutAnchorFrameDimension) {
		self.rawValue = dimensions.rawValue
	}
	public init(_ axes: NSLayoutConstraint.Axis) {
		self.rawValue = LayoutAnchorFrameDimension(axes).rawValue
	}
	
	public static let center  = [centerX, centerY] as Self
	
	public static let centerX = Self(rawValue: 1 << 0)
	public static let centerY = Self(rawValue: 1 << 1)
}
@available(iOSApplicationExtension 9, iOS 9, *)
public struct LayoutAnchorFrameDimension: OptionSet {
	public typealias `Self` = LayoutAnchorFrameDimension
	public let rawValue: UInt8
	public init(rawValue: UInt8) {
		self.rawValue = rawValue
	}
	public init(_ centers: LayoutAnchorFrameCenter) {
		self.rawValue = centers.rawValue
	}
	public init(_ axes: NSLayoutConstraint.Axis) {
		switch axes {case .horizontal: self = .width; case .vertical: self = .height}
	}
	
	public static let bothDimensions = [width, height] as Self
	
	public static let width  = Self(rawValue: 1 << 0)
	public static let height = Self(rawValue: 1 << 1)
}

@available(iOSApplicationExtension 9, iOS 9, *)
public extension UIView {
	func addSubview(_ subview: UIView, constraining sides: Side, to frame: LayoutAnchorFrame? = nil, padding: CGFloat = 0) {
		let frame = frame ?? self
		self.addSubview(subview)
		frame.constrain(sides, to: subview, padding: padding)
	}
	func addSubview(_ subview: UIView, constraining centers: Center, to frame: LayoutAnchorFrame? = nil, offset: CGFloat = 0) {
		let frame = frame ?? self
		self.addSubview(subview)
		frame.constrain(centers, to: subview, offset: offset)
	}
}

@available(iOSApplicationExtension 9, iOS 9, *)
public extension LayoutAnchorFrame {
	typealias Side = LayoutAnchorFrameSide
	typealias Center = LayoutAnchorFrameCenter
	typealias Dimension = LayoutAnchorFrameDimension
	
	@available(*, deprecated, renamed: "constrainSubview(_:_:padding:)")
	func constrain(subview: UIView, _ sides: Side, padding: CGFloat = 0) {constrainSubview(subview, sides, padding: padding)}
	@available(*, deprecated, renamed: "constrain(_:to:padding:)")
	func constrainSubview(_ subview: UIView, _ sides: Side, padding: CGFloat = 0) {constrain(sides, to: subview, padding: padding)}
	func constrain(_ sides: Side, to view: UIView, padding: CGFloat = 0) {
		let (vertical, horizontal) = (sides.verticalComponent, sides.horizontalComponent)
		constrain(horizontal, to: view, horizontal, padding: padding)
		constrain(vertical, to: view, vertical, padding: padding)
	}
	
	func constrain(_ sides: Side.Vertical, to view: UIView, _ toSides: Side.Vertical, padding: CGFloat = 0) {
		if sides.contains(.top) {
			view.topAnchor.constraint(equalTo: self.topAnchor, constant: padding).isActive = true
		}
		if sides.contains(.bottom) {
			self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: padding).isActive = true
		}
	}
	
	func constrain(_ sides: Side.Horizontal, to view: UIView, _ toSides: Side.Horizontal, padding: CGFloat = 0) {
		if sides.contains(.leading) {
			view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding).isActive = true
		}
		if sides.contains(.trailing) {
			self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding).isActive = true
		}
		if sides.contains(.left) {
			view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: padding).isActive = true
		}
		if sides.contains(.right) {
			self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: padding).isActive = true
		}
	}
	
	@available(*, deprecated, renamed: "constrainSubview(_:_:offset:)")
	func constrain(subview: UIView, _ centers: Center, offset: CGFloat = 0) {constrainSubview(subview, centers, offset: offset)}
	@available(*, deprecated, renamed: "constrain(_:to:offset:)")
	func constrainSubview(_ subview: UIView, _ centers: Center, offset: CGFloat = 0) {constrain(centers, to: subview, offset: offset)}
	func constrain(_ centers: Center, to view: UIView, offset: CGFloat = 0) {
		if centers.contains(.centerX) {
			view.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: offset).isActive = true
		}
		if centers.contains(.centerY) {
			view.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: offset).isActive = true
		}
	}
	
	@available(*, deprecated, renamed: "constrain(_:to:scale:padding:)")
	func constrainSubview(_ subview: UIView, _ dimensions: Dimension, scale: CGFloat = 1, padding: CGFloat = 0) {constrain(dimensions, to: subview, scale: scale, padding: padding)}
	func constrain(_ dimensions: Dimension, to view: UIView, scale: CGFloat = 1, padding: CGFloat = 0) {
		if dimensions.contains(.width) {
			view.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: scale, constant: -padding).isActive = true
		}
		if dimensions.contains(.height) {
			view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: scale, constant: -padding).isActive = true
		}
	}
	
	func constrain(_ dimensions: Dimension, to constant: CGFloat) {
		if dimensions.contains(.width) {
			self.widthAnchor.constraint(equalToConstant: constant).isActive = true
		}
		if dimensions.contains(.height) {
			self.heightAnchor.constraint(equalToConstant: constant).isActive = true
		}
	}
}
#endif
