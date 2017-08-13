//
// Created by 钟 子豪 on 16/8/27.
// Copyright (c) 2016 Beiliao. All rights reserved.
//

#import "BLJSON.h"

NS_ASSUME_NONNULL_BEGIN

BLJSON *BLJSONMake(id _Nullable JSONObject) {
    return [[BLJSON alloc] initWithJSONObject:JSONObject];
}

@implementation BLJSON

- (instancetype)initWithJSONObject:(nullable id)JSONObject {


    self = [super init];
    if (self) {
        if (!JSONObject || JSONObject == [NSNull null]) {
            return nil;
        }

        BOOL isValidJSONObject = [JSONObject isKindOfClass:[NSString class]] ||
            [JSONObject isKindOfClass:[NSNumber class]] ||
            [JSONObject isKindOfClass:[NSArray class]] ||
            [JSONObject isKindOfClass:[NSDictionary class]];

        if (!isValidJSONObject) {
            return nil;
        }

        _JSONObject = [JSONObject copyWithZone:nil];
    }

    return self;
}

- (nullable instancetype)objectForKeyedSubscript:(NSString *)key {
    if (!key) {
        return nil;
    }
    else {
        return BLJSONMake(self.dictionary[key]);
    }
}

- (nullable NSDictionary *)dictionary {
    if ([self.JSONObject isKindOfClass:[NSDictionary class]]) {
        return self.JSONObject;
    }

    return nil;
}

- (nullable NSArray *)array {
    if ([self.JSONObject isKindOfClass:[NSArray class]]) {
        return self.JSONObject;
    }

    return nil;
}

- (nullable NSString *)string {
    if ([self.JSONObject isKindOfClass:[NSString class]]) {
        return self.JSONObject;
    }
    else if ([self.JSONObject isKindOfClass:[NSNumber class]]) {
        return ((NSNumber *)self.JSONObject).stringValue;
    }
    else {
        return nil;
    }
}

- (nullable NSNumber *)number {
    if ([self.JSONObject isKindOfClass:[NSNumber class]]) {
        return self.JSONObject;
    }
    else if ([self.JSONObject isKindOfClass:[NSString class]]) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        return [formatter numberFromString:self.JSONObject];
    }
    else {
        return nil;
    }
}

- (NSInteger)integerValue {
    if ([self.JSONObject respondsToSelector:@selector(integerValue)]) {
        return [self.JSONObject integerValue];
    }

    return 0;
}

- (double)doubleValue {
    if ([self.JSONObject respondsToSelector:@selector(doubleValue)]) {
        return [self.JSONObject doubleValue];
    }

    return 0;
}


- (float)floatValue {
    if ([self.JSONObject respondsToSelector:@selector(floatValue)]) {
        return [self.JSONObject floatValue];
    }

    return 0;
}

- (int)intValue {
    if ([self.JSONObject respondsToSelector:@selector(intValue)]) {
        return [self.JSONObject intValue];
    }

    return 0;
}

- (BOOL)boolValue {
    if ([self.JSONObject respondsToSelector:@selector(boolValue)]) {
        return [self.JSONObject boolValue];
    }

    return NO;
}

- (int64_t)longLongValue {
    if ([self.JSONObject respondsToSelector:@selector(longLongValue)]) {
        return [self.JSONObject longLongValue];
    }

    return 0;
}


@end


NS_ASSUME_NONNULL_END
