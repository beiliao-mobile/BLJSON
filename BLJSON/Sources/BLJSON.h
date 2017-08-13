//
// Created by 钟 子豪 on 16/8/27.
// Copyright (c) 2016 Beiliao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * A toolkit to read values from JSON dictionaries safely. Inspired by SwiftyJSON.
 *
 * Reading JSON dictionaries in Objective-C might look like a little bit easier than in Swift, but in fact it's more error prone.
 * How many times you have encountered this crash: -[NSNull integerValue] unrecognized selector sent to instance 0xblahblah ?
 * Or this one: -[NSNull objectForKeyedSubscript:] unrecognized selector sent to instance 0xblahblah.
 * What about this one: -[NSNull objectAtIndexPath:] unrecognized selector sent to instance 0xblahblah.
 *
 * Since Objective-C use NSNull to represent nil in collections, you can't get the nil safe messaging behavior of Objective-C by default.
 * And Objective-C has no equivalent to Swift's guard-let key word, so in order to be safe, you have to check if the dictionary value is the type you're expecting, like this:
 *
 * if ([JSONDictionary[@"data"] isKindOfClass:[NSDictionary class]]) {
 *     NSDictionary *data = JSONDictionary[@"data"];
 *     if ([data[@"user"] isKindOfClass:[NSStriNSDictionaryng class]]) {
 *         NSDictionary *data = data[@"user"];
 *         if ([data[@"userName"] isKindOfClass:[NSString class]]) {
 *              // Finally...
 *         }
 *     }
 * }
 *
 * Sensing the pyramid of doom?
 *
 * You're god damn right!
 *
 * Tired of writing these type checking code? With BLJSON, your life is much more easier, like this:
 *
 * BLJSONMake(JSONDictionary)[@"data"][@"user"][@"userName"].string
 *
 * That's it. BLJSON will handle NSNull and treat it as nil instead of crashing. Extra bounus: string and number values can be transformed to each other automatically. If you're
 * asking for an
 * integer value but the value is in fact a string, BLJSON will try to parse the string to an integer by calling -[NSString integerValue] and vice versa. This behavior is really
 * helpful to prevent crash when the backend data type is wrong.
 *
 */
@interface BLJSON : NSObject

/**
 * The JSONObject to intialized this instance, must be valid JSON type or nil.
 */
@property (nonatomic, copy, readonly, nullable) id JSONObject;

/**
 * Retrieve dictionary value of the JSONObject. Return nil if JSONObject isn't a dictionary.
 */
@property (nonatomic, copy, readonly, nullable) NSDictionary *dictionary;

/**
 * Retrieve array value of the JSONObject. Return nil if JSONObject isn't an array.
 */
@property (nonatomic, copy, readonly, nullable) NSArray *array;

/**
 * Retrieve string value of the JSONObject. Return nil if JSONObject is neither a string nor a number.
 */
@property (nonatomic, copy, readonly, nullable) NSString *string;

/**
 * Retrieve number value of the JSONObject. Return nil if JSONObject is neither a number nor a string, or JSONObject is a string but can't be transform to valid number.
 */
@property (nonatomic, copy, readonly, nullable) NSNumber *number;

/**
 * Retrieve integer value of the JSONObject. Return 0 if JSONObject is neither a number nor a string, or JSONObject is a string but can't be transform to valid number.
 */
@property (nonatomic, readonly) NSInteger integerValue;

/**
 * Retrieve double value of the JSONObject. Return 0 if JSONObject is neither a number nor a string, or JSONObject is a string but can't be transform to valid number.
 */
@property (nonatomic, readonly) double doubleValue;

/**
 * Retrieve float value of the JSONObject. Return 0 if JSONObject is neither a number nor a string, or JSONObject is a string but can't be transform to valid number.
 */
@property (nonatomic, readonly) float floatValue;

/**
 * Retrieve int (32bit) value of the JSONObject. Return 0 if JSONObject is neither a number nor a string, or JSONObject is a string but can't be transform to valid number.
 */
@property (nonatomic, readonly) int intValue;

/**
 * Retrieve boolean value of the JSONObject. Return NO if JSONObject is neither a number nor a string, or JSONObject is a string but can't be transform to valid boolean.
 */
@property (nonatomic, readonly) BOOL boolValue;

/**
 * Retrieve int (64bit) value of the JSONObject. Return 0 if JSONObject is neither a number nor a string, or JSONObject is a string but can't be transform to valid number.
 */
@property (nonatomic, readonly) int64_t longLongValue;

/**
 * Create a BLJSON instance from a JSON object
 * @param JSONObject A valid JSON object
 * @return Newly created BLJSON instance
 */
- (instancetype)initWithJSONObject:(nullable id)JSONObject;

/**
 * This method exists to make the square brackets syntax available and chainable. It returns a newly created BLJSON instance with the value of the specified key in the JSONObject
 * dictionary, and If JSONObject isn't a dictionary, this method simplely return nil.
 * @param key The key will be used to retrieve value from the JSONObject dictionary.
 * @return Returns a newly created BLJSON instances with the value of the specified key in the JSONObject dictionary.
 */
- (nullable instancetype)objectForKeyedSubscript:(NSString *)key;

@end

/**
 * Short hand initializer
 * @param JSONObject Same as -[BLJSON initWithJSONObject:]
 * @return Same as -[BLJSON initWithJSONObject:]
 */
BLJSON *BLJSONMake(id _Nullable JSONObject);


NS_ASSUME_NONNULL_END
