//
//  Observer.swift
//  Observer
//
//  Created by Arror on 2017/10/24.
//  Copyright © 2017年 Arror. All rights reserved.
//

import Foundation

public final class Observer<O> {
    
    internal final class OptionalMethod<V> {
        
        typealias OptionalGet = () -> Optional<V>
        typealias OptionalSet = (Optional<V>) -> Void
        
        let oGet: OptionalGet
        let oSet: OptionalSet
        
        init(oGet: @escaping OptionalMethod.OptionalGet, oSet: @escaping OptionalMethod.OptionalSet) {
            
            self.oGet = oGet
            self.oSet = oSet
        }
    }
    
    internal final class Method<V> {
        
        typealias Get = () -> V
        typealias Set = (V) -> Void
        
        let get: Get
        let set: Set
        
        init(get: @escaping Method.Get, set: @escaping Method.Set) {
            
            self.get = get
            self.set = set
        }
    }
    
    public typealias ChangeHandler<V> = (_ o: O, _ old: V, _ new: V) -> Void
    
    public private(set) var value: O
    
    private var dataMapping: [PartialKeyPath<O>: Any] = [:]
    
    private var changeHandlerMapping: [PartialKeyPath<O>: Any] = [:]
    
    public init(_ value: O) {
        
        self.value = value
    }
    
    public subscript<V>(changeKeyPath: WritableKeyPath<O, Optional<V>>) -> Optional<V> {
        get {
            guard
                let data = self.dataMapping[changeKeyPath] as? Observer.OptionalMethod<V> else {
                    
                    return self.value[keyPath: changeKeyPath]
            }
            
            return data.oGet()
        }
        set {
            guard
                let data = self.dataMapping[changeKeyPath] as? Observer.OptionalMethod<V>,
                let handler = self.changeHandlerMapping[changeKeyPath] as? Observer.ChangeHandler<Optional<V>> else {
                    
                    self.value[keyPath: changeKeyPath] = newValue
                    
                    return
            }
            
            let old = self.value[keyPath: changeKeyPath]
            
            data.oSet(newValue)
            
            let new = self.value[keyPath: changeKeyPath]
            
            handler(self.value, old, new)
        }
    }
    
    public subscript<V>(changeKeyPath: WritableKeyPath<O, V>) -> V {
        get {
            guard
                let data = self.dataMapping[changeKeyPath] as? Observer.Method<V> else {
                    
                    return self.value[keyPath: changeKeyPath]
            }
            
            return data.get()
        }
        set {
            guard
                let data = self.dataMapping[changeKeyPath] as? Observer.Method<V>,
                let handler = self.changeHandlerMapping[changeKeyPath] as? Observer.ChangeHandler<V> else {
                    
                    self.value[keyPath: changeKeyPath] = newValue
                    
                    return
            }
            
            let old = self.value[keyPath: changeKeyPath]
            
            data.set(newValue)
            
            let new = self.value[keyPath: changeKeyPath]
            
            handler(self.value, old, new)
        }
    }
    
    public func observe<V>(keyPath: WritableKeyPath<O, V>, changeHandler: @escaping Observer.ChangeHandler<V>) {
        
        self.dataMapping[keyPath] = Observer.Method(get: { [unowned self] () -> V in
            
            return self.value[keyPath: keyPath]
            
            }, set: { [unowned self] v in
                
                self.value[keyPath: keyPath] = v
        })
        
        self.changeHandlerMapping[keyPath] = changeHandler
    }
    
    public func observe<V>(keyPath: WritableKeyPath<O, Optional<V>>, changeHandler: @escaping Observer.ChangeHandler<Optional<V>>) {
        
        self.dataMapping[keyPath] = Observer.OptionalMethod(oGet: { [unowned self] () -> V? in
            
            return self.value[keyPath: keyPath]
            
            }, oSet: { [unowned self] v in
                
                self.value[keyPath: keyPath] = v
        })
        
        self.changeHandlerMapping[keyPath] = changeHandler
    }
}
