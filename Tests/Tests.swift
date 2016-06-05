//
//  EonilJSONTests.swift
//  EonilJSONTests
//
//  Created by Hoon H. on 2016/06/05.
//  Copyright © 2016 Eonil. All rights reserved.
//

import XCTest
@testable import EonilJSON

class EonilJSONTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }


    func test1() throws {
        let	a1	=	"{ \"aaa\" : 123 }"
        let	a2	=	a1.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        let	a3	=	try JSON.deserialize(a2)

        let	a4	=	JSON.Value.Object([
            "aaa"	:	JSON.Value.Number(JSON.Number.Integer(123))
            ])
        
        XCTAssert(a3 == a4)
    }

    func test2() throws {
        let	d1	=	"This is a dynamic text." as JSON.Value
        let	a1	=	[
            "aaa"	:	nil,
            "bbb"	:	true,
            "ccc"	:	123,
            "ddd"	:	456.789,
            "eee"	:	d1,
            "fff"	:	[d1, d1, d1],
            "ggg"	:	[
                "f1"	:	d1,
                "f2"	:	d1,
                "f3"	:	d1,
            ],
            ] as JSON.Value


        let	a2 = try JSON.serialize(a1)
        print(a2)

        let	a3 = try JSON.deserialize(a2)
        print(a3)

        XCTAssert(a3 == a1)

        print(a3.object!["aaa"]!)
//        let	v1 = a3.object!["aaa"]!
        XCTAssert(a3.object!["aaa"]! == nil)
        XCTAssert(a3.object!["fff"]! == [d1, d1, d1])
    }
}
















/////	MARK:
//extension RFC4627 {
//	struct Test {
//		static func run() throws {
//			func tx(c:() throws ->()) throws {
//				try c()
//			}
//
//			try tx {
//			}
//			try tx {
////				let	a1	=	[
////					"aaa"	:	nil,
////					"bbb"	:	true,
////					"ccc"	:	123,
////					"ddd"	:	456.789,
////					"eee"	:	"Here be a dragon.",
////					"fff"	:	["xxx", "yyy", "zzz"],
////					"ggg"	:	[
////						"f1"	:	"v1",
////						"f2"	:	"v2",
////						"f3"	:	"v3",
////						],
////					] as Value
////				
////				print(a1.object!["aaa"]!)
//////				let	v1 = a1.object!["aaa"]!
////				assert(a1.object!["aaa"]! == nil)
////				
////				let	a2	=	try JSON.serialize(a1)!
////				print(a2)
////				
////				let	a3	=	try JSON.deserialize(a2)!
////				print(a3)
////				
////				assert(a3 == a1)
//			}
//			
//			try tx {
//
//			}
//
//		}
//	}
//}
//
//
//
//










