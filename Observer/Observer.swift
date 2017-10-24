//
//  Observer.swift
//  Observer
//
//  Created by Arror on 2017/10/24.
//  Copyright © 2017年 Arror. All rights reserved.
//

import Foundation

/*
 
 ** Sample
 
 let op = Observer(Person(name: "Name", age: 10))
 
 op.observe(keyPath: \Person.name) { p, old, new in
 
     print("Old: \(old), New: \(new)")
 }
 
 op[\.name] = "Name0"
 
 op[\.name] = "Name1"
 
 op[\.name] = "Name2"
 
 op[\.name] = "Name3"
 
 */

public final class Observer<O> {
    
    internal final class OptionalData<V> {
        
        typealias OptionalGet = () -> Optional<V>
        typealias OptionalSet = (Optional<V>) -> Void
        
        let oGet: OptionalGet
        let oSet: OptionalSet
        
        init(oGet: @escaping OptionalData.OptionalGet, oSet: @escaping OptionalData.OptionalSet) {
            
            self.oGet = oGet
            self.oSet = oSet
        }
    }
    
    internal final class Data<V> {
        
        typealias Get = () -> V
        typealias Set = (V) -> Void
        
        let get: Get
        let set: Set
        
        init(get: @escaping Data.Get, set: @escaping Data.Set) {
            
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
            guard let data = self.dataMapping[changeKeyPath] as? Observer.OptionalData<V> else { fatalError("Can't read before observed.") }
            return data.oGet()
        }
        set {
            guard
                let data = self.dataMapping[changeKeyPath] as? Observer.OptionalData<V>,
                let handler = self.changeHandlerMapping[changeKeyPath] as? Observer.ChangeHandler<Optional<V>> else {
                    
                    fatalError("Can't write before observed.")
            }
            
            let old = self.value[keyPath: changeKeyPath]
            
            data.oSet(newValue)
            
            let new = self.value[keyPath: changeKeyPath]
            
            handler(self.value, old, new)
        }
    }
    
    public subscript<V>(changeKeyPath: WritableKeyPath<O, V>) -> V {
        get {
            guard let data = self.dataMapping[changeKeyPath] as? Observer.Data<V> else { fatalError("Can't read before observed.") }
            return data.get()
        }
        set {
            guard
                let data = self.dataMapping[changeKeyPath] as? Observer.Data<V>,
                let handler = self.changeHandlerMapping[changeKeyPath] as? Observer.ChangeHandler<V> else {
                    
                    fatalError("Can't write before observed.")
            }
            
            let old = self.value[keyPath: changeKeyPath]
            
            data.set(newValue)
            
            let new = self.value[keyPath: changeKeyPath]
            
            handler(self.value, old, new)
        }
    }
    
    public func observe<V>(keyPath: WritableKeyPath<O, V>, changeHandler: @escaping Observer.ChangeHandler<V>) {
        
        self.dataMapping[keyPath] = Observer.Data(get: { [unowned self] () -> V in
            return self.value[keyPath: keyPath]
            }, set: { [unowned self] v in
                self.value[keyPath: keyPath] = v
        })
        
        self.changeHandlerMapping[keyPath] = changeHandler
    }
    
    public func observe<V>(keyPath: WritableKeyPath<O, Optional<V>>, changeHandler: @escaping Observer.ChangeHandler<Optional<V>>) {
        
        self.dataMapping[keyPath] = Observer.OptionalData(oGet: { [unowned self] () -> V? in
            return self.value[keyPath: keyPath]
            }, oSet: { [unowned self] v in
                self.value[keyPath: keyPath] = v
        })
        
        self.changeHandlerMapping[keyPath] = changeHandler
    }
}
