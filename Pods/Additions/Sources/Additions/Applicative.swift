//
//  Applicative.swift
//  Additions
//
//  Created by James Froggatt on 05.09.2016.
//
//


/*
inactive
• +>: indicator of need for additional functions
*/

//b(f()): =>
//f().flatMap(b): =>?
//let a = f(); b(a); return a: +>
//let a = f(); a.map(b); return a: +>?

precedencegroup ApplicativePrecedence {
	associativity: left
	higherThan: NilCoalescingPrecedence, DefaultPrecedence
}

///map
infix operator => : ApplicativePrecedence
@_transparent
public func =><In, Out>(a: In, b: (In) throws -> Out) rethrows -> Out {
	return try b(a)
}
@_transparent
public func =><In, Out>(a: In, b: ((In) throws -> Out)?) rethrows -> Out? {
	return try b?(a)
}
@_transparent @discardableResult
public func =><In>(a: In, b: inout In) -> In {
	b = a
	return b
}

infix operator =>? : ApplicativePrecedence
@_transparent
public func =>?<In, Out>(a: In?, b: (In) throws -> Out?) rethrows -> Out? {
	if let a = a {return try b(a)}
	return nil
}
@_transparent
public func =>?<In, Out>(a: In?, b: ((In) throws -> Out?)?) rethrows -> Out? {
	if let a = a {return try b?(a)}
	return nil
}
@_transparent @discardableResult
public func =>?<In>(a: In?, b: inout In) -> In {
	if let a = a {b = a}
	return b
}

///applying
infix operator +> : ApplicativePrecedence
@_transparent @discardableResult
public func +><In, Out>(a: In, b: (In) throws -> Out) rethrows -> In {
	_ = try b(a); return a
}

infix operator +>? : ApplicativePrecedence
@_transparent @discardableResult
public func +>?<In, Out>(a: In?, b: (In) throws -> Out?) rethrows -> In? {
	_ = try a.flatMap(b); return a
}


//deprecated
infix operator ?=> : ApplicativePrecedence
@available(*, deprecated, renamed: "=>?")
public func ?=><In, Out>(a: In?, b: (In) throws -> Out?) rethrows -> Out? {
	return try a.flatMap(b)
}
infix operator ?+> : ApplicativePrecedence
@available(*, deprecated, renamed: "+>?")
public func ?+><In, Out>(a: In?, b: (In) throws -> Out?) rethrows -> In? {
	_ = try a.flatMap(b); return a
}
