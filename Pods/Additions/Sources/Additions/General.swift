//
//  General.swift
//  Additions
//
//  Created by James Froggatt on 27.09.2016.
//
//

//Adrian Zubarev, Swift Evolution, Jun 27, 2017
public func ??<T>(optional: T?, noreturnOrError: @autoclosure () throws -> Never) rethrows -> T {
	switch optional {
	case .some(let value): return value
	case .none: try noreturnOrError()
	}
}

extension Equatable where Self: AnyObject {
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		return lhs === rhs
	}
}
extension Hashable where Self: AnyObject {
	#if swift(>=4.2)
	func hash(into hasher: inout Hasher) {
		ObjectIdentifier(self).hash(into: &hasher)
	}
	#else
	var hashValue: Int {return ObjectIdentifier(self).hashValue}
	#endif
}

extension Sequence {
	public var isEmpty: Bool {
		var iterator = self.makeIterator()
		return iterator.next() == nil
	}
}
extension Optional: IteratorProtocol where Wrapped: IteratorProtocol {
	public typealias Element = Wrapped.Element
	public mutating func next() -> Wrapped.Element? {
		return self?.next()
	}
}
extension Optional: Sequence where Wrapped: Sequence {
	public typealias Iterator = Wrapped.Iterator?
	public func makeIterator() -> Wrapped.Iterator? {
		return self?.makeIterator()
	}
}

public extension Optional {
	func map<T>(_ keyPath: KeyPath<Wrapped, T>) -> T? {
		return self.map{$0[keyPath: keyPath]}
	}
	func flatMap<T>(_ keyPath: KeyPath<Wrapped, T?>) -> T? {
		return self.flatMap{$0[keyPath: keyPath]}
	}
}
public extension Sequence {
	func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
		return self.map{$0[keyPath: keyPath]}
	}
	func compactMap<T>(_ keyPath: KeyPath<Element, T?>) -> [T] {
		return self.compactMap{$0[keyPath: keyPath]}
	}
	func flatMap<Sequence: Swift.Sequence>(_ keyPath: KeyPath<Element, Sequence>) -> [Sequence.Element] {
		return self.flatMap{$0[keyPath: keyPath]}
	}
	func filter(by keyPath: KeyPath<Element, Bool>) -> [Element] {
		return self.filter{$0[keyPath: keyPath]}
	}
}
public extension Collection {
	subscript(ifPresent index: Index) -> Iterator.Element? {
		get {return self.indices.contains(index) ? self[index] : nil}
	}
}

public extension RangeReplaceableCollection {
	///removes the element at the source index and inserts it at the destination
	mutating func move(from fromIndex: Index, to toIndex: Index) {
		insert(remove(at: fromIndex), at: toIndex)
	}
}

public extension Comparable {
	///return the bound which self is beyond, otherwise self
	func clamped(to range: ClosedRange<Self>) -> Self {
		return max(min(self, range.upperBound), range.lowerBound)
	}
	
	///clamps self
	mutating func clamp(to range: ClosedRange<Self>) {
		self = self.clamped(to: range)
	}
}

public extension Comparable where Self: Strideable, Self.Stride: SignedInteger {
	///return the bound which self is beyond, otherwise self
	func clamped(to range: CountableRange<Self>) -> Self {
		return max(min(self, range.upperBound.advanced(by: -1)), range.lowerBound)
	}
	///return the bound which self is beyond, otherwise self
	func clamped(to range: CountableClosedRange<Self>) -> Self {
		return max(min(self, range.upperBound), range.lowerBound)
	}
	
	///clamps self
	mutating func clamp(to range: CountableRange<Self>) {
		self = self.clamped(to: range)
	}
	///clamps self
	mutating func clamp(to range: CountableClosedRange<Self>) {
		self = self.clamped(to: range)
	}
}

private struct StrideToCollection<Index: Strideable>: BidirectionalCollection {
	subscript(position: Index) -> Index {
		guard indices.contains(position) else {fatalError("Index out of bounds")}
		return position
	}
	init(from: Index, to: Index, by: Index.Stride) {startIndex = from; endIndex = to; stride = by}
	var startIndex: Index
	var endIndex: Index
	var stride: Index.Stride
	var indices: Range<Index> {return startIndex..<endIndex}
	func index(after i: Index) -> Index {return i.advanced(by: 1)}
	func index(before i: Index) -> Index {return i.advanced(by: -1)}
	func index(of element: Index) -> Index? {return indices.contains(element) ? element : nil}
	func contains(_ element: Index) -> Bool {return indices.contains(element)}
}
public extension FixedWidthInteger {
	///return the bound which self is beyond, otherwise self
	func clamped<Range>(to range: Range) -> Self where Range: RangeExpression, Range.Bound == Self {
		let range = range.relative(to: StrideToCollection(from: Self.min, to: Self.max, by: 1))
		switch self {
		case range: return self
		case ...range.lowerBound: return range.lowerBound
		case _: return range.upperBound.advanced(by: -1)
		}
	}
}
public extension FloatingPoint {
	///return the bound which self is beyond, otherwise self
	func clamped<Range>(to range: Range) -> Self where Range: RangeExpression, Range.Bound == Self {
		let range = range.relative(to: StrideToCollection(from: -Self.greatestFiniteMagnitude, to: Self.greatestFiniteMagnitude, by: 1))
		switch self {
		case range: return self
		case ...range.lowerBound: return range.lowerBound
		case _: return range.upperBound.advanced(by: -1)
		}
	}
}
