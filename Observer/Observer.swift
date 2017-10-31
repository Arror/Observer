//
//  Observer.swift
//  Observer
//
//  Created by Arror on 2017/10/24.
//  Copyright © 2017年 Arror. All rights reserved.
//

import Foundation

public final class Observer<O> {
    
    public typealias ChangeHandler<V> = (_ o: Observer<O>, _ old: V, _ new: V) -> Void
    
    public private(set) var value: O
    
    private var setMethodMapping: [PartialKeyPath<O>: Any] = [:]
    
    private var changeHandlerMapping: [PartialKeyPath<O>: Any] = [:]
    
    public init(_ value: O) {
        
        self.value = value
    }
    
    public init?(_ optionalValue: Optional<O>) {
        
        guard let value = optionalValue else { return nil }
        
        self.value = value
    }
    
    public subscript<V>(changeKeyPath: WritableKeyPath<O, Optional<V>>) -> Optional<V> {
        get {
            return self.value[keyPath: changeKeyPath]
        }
        set {
            guard
                let setMethod = self.setMethodMapping[changeKeyPath] as? (Optional<V>) -> Void,
                let changeHandler = self.changeHandlerMapping[changeKeyPath] as? Observer.ChangeHandler<Optional<V>> else {
                    
                    self.value[keyPath: changeKeyPath] = newValue
                    
                    return
            }
            
            let old = self.value[keyPath: changeKeyPath]
            
            setMethod(newValue)
            
            let new = self.value[keyPath: changeKeyPath]
            
            changeHandler(self, old, new)
        }
    }
    
    public subscript<V>(changeKeyPath: WritableKeyPath<O, V>) -> V {
        get {
            return self.value[keyPath: changeKeyPath]
        }
        set {
            guard
                let setMethod = self.setMethodMapping[changeKeyPath] as? (V) -> Void,
                let changeHandler = self.changeHandlerMapping[changeKeyPath] as? Observer.ChangeHandler<V> else {
                    
                    self.value[keyPath: changeKeyPath] = newValue
                    
                    return
            }
            
            let old = self.value[keyPath: changeKeyPath]
            
            setMethod(newValue)
            
            let new = self.value[keyPath: changeKeyPath]
            
            changeHandler(self, old, new)
        }
    }
    
    public func observe<V>(keyPath: WritableKeyPath<O, V>, changeHandler: @escaping Observer.ChangeHandler<V>) {
        
        self.setMethodMapping[keyPath] = { [unowned self] v in
            
            self.value[keyPath: keyPath] = v
        }
        
        self.changeHandlerMapping[keyPath] = changeHandler
    }
    
    public func observe<V>(keyPath: WritableKeyPath<O, Optional<V>>, changeHandler: @escaping Observer.ChangeHandler<Optional<V>>) {
        
        self.setMethodMapping[keyPath] = { [unowned self] v in
            
            self.value[keyPath: keyPath] = v
        }
        
        self.changeHandlerMapping[keyPath] = changeHandler
    }
}

extension Observer where O: Comparable {
    
    public static func <(lhs: Observer<O>, rhs: Observer<O>) -> Bool {
        
        return lhs.value < rhs.value
    }
}

extension Observer where O: Equatable {
    
    public static func ==(lhs: Observer<O>, rhs: Observer<O>) -> Bool {
        
        return lhs.value == rhs.value
    }
}

extension Observer where O: Hashable {
    
    public var hashValue: Int {
        
        return self.value.hashValue
    }
}

extension Observer where O: CustomStringConvertible {
    
    public var description: String {
        
        return self.value.description
    }
}

extension Observer where O: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        return self.value.debugDescription
    }
}
