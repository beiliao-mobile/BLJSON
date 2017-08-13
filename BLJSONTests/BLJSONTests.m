//
//  BLJSONTests.m
//  BLJSONTests
//
//  Created by 钟 子豪 on 16/8/27.
//  Copyright (c) 2016 Beiliao. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BLJSON.h"

@interface BLJSONTests : XCTestCase

@end

@implementation BLJSONTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWillReturnNilForInvalidCases {
    XCTAssertNil(BLJSONMake([NSObject new]));
    XCTAssertNil(BLJSONMake(nil));
    XCTAssertNil(BLJSONMake([NSNull null]));
}

- (void)testCanCreateNewInstanceFromKeyedSubscript {
    XCTAssert([BLJSONMake(self.sampleDictionary)[@"data"] isKindOfClass:[BLJSON class]]);
}

- (void)testCanReadValuesFromDictionary {
    XCTAssert([BLJSONMake(self.sampleDictionary)[@"data"].dictionary isKindOfClass:[NSDictionary class]]);

    NSArray *array = @[@1, @2, @3];
    XCTAssert([BLJSONMake(self.sampleDictionary)[@"likedUserIDs"].array isEqualToArray:array]);

    XCTAssertEqual(BLJSONMake(self.sampleDictionary)[@"createdAt"].number.integerValue, 140000000);

    XCTAssert([BLJSONMake(self.sampleDictionary)[@"title"].string isEqualToString:@"Winter is coming"]);
}

- (void)testCanReadValueFromNestedDictionary {
    BLJSON *json = BLJSONMake(self.sampleDictionary);

    XCTAssertEqualObjects(json[@"data"][@"author"][@"userID"].number, @666);

    XCTAssertEqualObjects(json[@"data"][@"author"][@"userName"].string, @"Jon Snow");

    NSArray *array = @[@1, @2, @3];
    XCTAssertEqualObjects(json[@"data"][@"author"][@"followerIDs"].array, array);

    NSDictionary *dictionary = @{
        @"country": @"The North",
        @"castle": @"Winter Fell",
    };
    XCTAssertEqualObjects(BLJSONMake(self.sampleDictionary[@"data"][@"author"][@"address"]).dictionary, dictionary);
}

- (void)testCanTransformBetweenNumberAndStringAutomatically {
    BLJSON *json = BLJSONMake(self.sampleDictionary);
    XCTAssertEqualObjects(json[@"createdAt"].string, @"140000000");
    XCTAssertEqualObjects(json[@"modifiedAt"].number, @140000000);
}

- (void)testCanHandleNSNullSafely {
    XCTAssertNil(BLJSONMake(self.sampleDictionary)[@"data"][@"author"][@"address2"][@"country"].string);
    XCTAssertNil(BLJSONMake(self.sampleDictionary)[@"data"][@"author"][@"address2"][@"castle"].string);
}

- (void)testCanTransformToPrimitiveTypes {
    XCTAssertEqual(BLJSONMake(self.sampleDictionary)[@"modifiedAt"].integerValue, 140000000);
    XCTAssertEqual(BLJSONMake(self.sampleDictionary)[@"createdAt"].integerValue, 140000000);

    XCTAssertEqual(BLJSONMake(self.sampleDictionary)[@"modifiedAt"].intValue, 140000000);
    XCTAssertEqual(BLJSONMake(self.sampleDictionary)[@"createdAt"].intValue, 140000000);

    XCTAssertEqual(BLJSONMake(self.sampleDictionary)[@"modifiedAt"].longLongValue, 140000000);
    XCTAssertEqual(BLJSONMake(self.sampleDictionary)[@"createdAt"].longLongValue, 140000000);

    XCTAssertEqualWithAccuracy(BLJSONMake(self.sampleDictionary)[@"favoriteRate"].doubleValue, 42.3762, 0.001);
    XCTAssertEqualWithAccuracy(BLJSONMake(self.sampleDictionary)[@"favoriteRate"].floatValue, 42.3762, 0.001);

    XCTAssertTrue(BLJSONMake(self.sampleDictionary)[@"recommended"].boolValue);
    XCTAssertFalse(BLJSONMake(self.sampleDictionary)[@"hidden"].boolValue);
    XCTAssertTrue(BLJSONMake(self.sampleDictionary)[@"sticky"].boolValue);
    XCTAssertFalse(BLJSONMake(self.sampleDictionary)[@"hasAttachments"].boolValue);
}

- (NSDictionary *)sampleDictionary {
    return @{
        @"title": @"Winter is coming",
        @"createdAt": @140000000,
        @"modifiedAt": @"140000000",
        @"data": @{
            @"content": @"foo bar",
            @"timelineID": @233,
            @"author": @{
                @"userID": @666,
                @"userName": @"Jon Snow",
                @"followerIDs": @[@1, @2, @3],
                @"address": @{
                    @"country": @"The North",
                    @"castle": @"Winter Fell",
                },
                @"address2": [NSNull null],
            }
        },
        @"likedUserIDs": @[@1, @2, @3],
        @"favoriteRate": @42.3762,
        @"recommended": @YES,
        @"hidden": @NO,
        @"sticky": @"1",
        @"hasAttachments": @"0"
    };
}

@end
