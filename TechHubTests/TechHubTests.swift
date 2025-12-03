//
//  TechHubTests.swift
//  TechHubTests
//
//  Created by saboor on 03/12/2025.
//

import Testing
@testable import TechHub

struct TechHubTests  {

    @Suite("Arithmatic") struct Arithmatic {
        var myMath : MyMath
        private init(myMath: MyMath = MyMath()) {
            self.myMath = myMath
        }
       // var myMath = MyMath()
        @Test("Addition") func add() {
            // arrage
            let a = 10
            let b = 5
            // act
            let sum = myMath.add(a, b)
            // expect
            #expect(sum == 15)
        }
        @Test("Subtraction") func subtract()  {
            // arrage
            let a = 10
            let b = 5
            // act
            let result = myMath.subtract(a, b)
            // expect
            #expect(result == 5)
        }
        @Test("Multiplication") func multiply()  {
            // arrage
            let a = 10
            let b = 5
            // act
            let result = myMath.multiply(a, b)
            // assert
            #expect(result == 50)
        }
    }
    
    @Suite struct Cool {
        var myMath : MyMath
        private init(myMath: MyMath = MyMath()) {
            self.myMath = myMath
        }
        
        @Test("Swap") func swap() {
            // arrage
            var a = 10
            var b = 5
            // act
            myMath.swap(a: &a, b: &b)
            // expect
            #expect(a == 5,"a is not equal to 5")
            #expect(b == 10,"b is not equal to 10")
        }
        
        @Test("Average") func average() {
            // arrage
            var a = 10
            var b = 5
            // act
            let result = myMath.average(a, b)
            // expect
            #expect(result <= 7.5)
        }
    }


}
