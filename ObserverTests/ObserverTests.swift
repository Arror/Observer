//
//  ObserverTests.swift
//  ObserverTests
//
//  Created by Arror on 2017/10/24.
//  Copyright © 2017年 Arror. All rights reserved.
//

import XCTest
@testable import Observer

class ObserverTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        
        let op = Observer(Person())
        
        op.observe(keyPath: \.name) { p, old, new in
            
            print("Struct  ==  \t\tName --> \t\tOld: \(old) \t\tNew: \(new)")
        }
        
        op.observe(keyPath: \.id) { p, old, new in
            
            print("Struct  ==  \t\tID --> \t\tOld: \(old ?? "NULL") \t\tNew: \(new ?? "NULL")")
        }
        
        print("\n--------------------------------------------------------------------------------\n")
        
        op[\.name] = "Name0"
        op[\.name] = "Name1"
        op[\.name] = "Name2"
        op[\.name] = "Name3"
        
        print("\n--------------------------------------------------------------------------------\n")
        
        op[\.id] = "ID 1"
        op[\.id] = "ID 2"
        op[\.id] = "ID 3"
        op[\.id] = nil
        
        print("\n--------------------------------------------------------------------------------\n")
        
        op.observe(keyPath: \.ref.value) { p, old, new in
            
            print("StructClass  ==  \t\tRef->Value --> \t\tOld: \(old) \t\tNew: \(new)")
        }
        
        op[\.ref.value] = "Value0"
        op[\.ref.value] = "Value1"
        op[\.ref.value] = "Value2"
        op[\.ref.value] = "Value3"
        
        print("\n--------------------------------------------------------------------------------\n")
        
        
        let orp = Observer(Student())
        
        orp.observe(keyPath: \.name) { p, old, new in
            
            print("Class  ==  \t\tName --> \t\tOld: \(old) \t\tNew: \(new)")
        }
        
        orp.observe(keyPath: \.id) { p, old, new in
            
            print("Class  ==  \t\tID --> \t\tOld: \(old ?? "NULL") \t\tNew: \(new ?? "NULL")")
        }
        
        orp[\.name] = "Name0"
        orp[\.name] = "Name1"
        orp[\.name] = "Name2"
        orp[\.name] = "Name3"
        
        print("\n--------------------------------------------------------------------------------\n")
        
        orp[\.id] = "ID 1"
        orp[\.id] = "ID 2"
        orp[\.id] = "ID 3"
        orp[\.id] = nil
        
        print("\n--------------------------------------------------------------------------------\n")
        
        orp.observe(keyPath: \.structural.value) { p, old, new in
            
            print("ClassStruct  ==  \t\tStructural->Value --> \t\tOld: \(old) \t\tNew: \(new)")
        }
        
        orp[\.structural.value] = "Value0"
        orp[\.structural.value] = "Value1"
        orp[\.structural.value] = "Value2"
        orp[\.structural.value] = "Value3"
        
        print("\n--------------------------------------------------------------------------------\n")
    }
    
    func testPerformanceExample() {
        self.measure {
        }
    }
}

class Student {
    
    var name: String = "Name"
    
    var id: String?
    
    var structural = Structural()
}

struct Structural {
    
    var value: String = "Value"
}

struct Person {
    
    var name: String = "Name"
    
    var id: String?
    
    let ref = Ref()
}

class Ref {
    
    var value: String = "Value"
}
