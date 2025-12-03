//
//  MyMath.swift
//  TechHub
//
//  Created by saboor on 03/12/2025.
//

import Foundation

final class MyMath {
    // MARK: - Arithmatics
    func add(_ a: Int,_ b: Int) -> Int {
        return a + b
    }
    func subtract(_ a: Int,_ b: Int) -> Int {
        return a - b
    }
    func multiply(_ a: Int,_ b: Int) -> Int {
        return a * b
    }
    // MARK: - Cool
    func swap(a: inout Int, b: inout Int) {
       a = a + b
       b = a - b
       a = a -  b
    }
    func average(_ a: Int,_ b: Int) -> Double {
        return Double((a + b )/2)
    }
    
}
