//
//  CoreGraphics.swift
//  Additions
//
//  Created by James Froggatt on 30.01.2019.
//

#if canImport(CoreGraphics)
import CoreGraphics

public extension CGRect {
	func insetBy(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> CGRect {
		return CGRect(x: self.origin.x + left, y: self.origin.y + top, width: self.width - (left + right), height: self.height - (top + bottom))
	}
	func insetBy(_ all: CGFloat) -> CGRect {
		return insetBy(dx: all, dy: all)
	}
}
#endif
