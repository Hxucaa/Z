//
//  Chain.swift
//  XListing
//
//  Created by Lance Zhu 2015-09-12.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation

public struct Chain {
    public typealias Done = (Void -> Void)
    public typealias Block = Done -> Void
    private var chains: [Block]
    
    public init(_ blocks: Block...) {
        chains = blocks
    }
    
    public mutating func append(block: Block) {
        chains.append(block)
    }
    
    public func run() {
        recursion(0)
    }
    
    private func recursion(index: Int) {
        chains[index] { index + 1 < self.chains.count ? self.recursion(index + 1) : () }
    }
}