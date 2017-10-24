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
            
            print("Name --> Old: \(old) New: \(new)")
        }
        
        op.observe(keyPath: \.age) { p, old, new in
            
            print("Name --> Old: \(old) New: \(new)")
        }
        
        op.observe(keyPath: \.id) { p, old, new in
            
            print("Name --> Old: \(old ?? "NULL") New: \(new ?? "NULL")")
        }
        
        op[\.name] = "Name0"
        op[\.name] = "Name1"
        op[\.name] = "Name2"
        
        op[\.age] = 1
        op[\.age] = 2
        op[\.age] = 3
        
        op[\.id] = "ID 1"
        op[\.id] = "ID 2"
        op[\.id] = "ID 3"
        op[\.id] = nil
    }
    
    func testPerformanceExample() {
        self.measure {
        }
    }
}

struct Person {
    
    var name: String = "Name"
    
    var age: Int = 0
    
    var id: String?
}
