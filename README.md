
Reading JSON dictionaries in Objective-C might look like a little bit easier than in Swift, but in fact it's more error prone.

How many times you have encountered this crash: -[NSNull integerValue] unrecognized selector sent to instance 0xblahblah ?

Or this one: -[NSNull objectForKeyedSubscript:] unrecognized selector sent to instance 0xblahblah.

What about this one: -[NSNull objectAtIndexPath:] unrecognized selector sent to instance 0xblahblah.

Since Objective-C use NSNull to represent nil in collections, you can't get the nil safe messaging behavior of Objective-C by default.
 And Objective-C has no equivalent to Swift's guard-let key word, so in order to be safe, you have to check if the dictionary value is the type you're expecting, like this:

```objc
if ([JSONDictionary[@"data"] isKindOfClass:[NSDictionary class]]) {
    NSDictionary *data = JSONDictionary[@"data"];
    if ([data[@"user"] isKindOfClass:[NSStriNSDictionaryng class]]) {
        NSDictionary *data = data[@"user"];
        if ([data[@"userName"] isKindOfClass:[NSString class]]) {
              // Finally...
        }
    }
}
```
 
Sensing the pyramid of doom? With BLJSON, your life is much more easier, like this:

```objc
BLJSONMake(JSONDictionary)[@"data"][@"user"][@"userName"].string
```
  
That's it. BLJSON will handle NSNull and treat it as nil instead of crashing. 

Extra bonus: string and number values can be transformed to each other automatically. If you're asking for an integer value but the value is in fact a string, BLJSON will try to parse the string to an integer by calling -[NSString integerValue] and vice versa. This behavior is really helpful to prevent crash when the backend data type is wrong.

-----

# 中文说明
在 Objective-C 中读取 JSON 字典值看起来好像比在 Swift 中要简单一些，但实际上更容易出错。以下的崩溃应该都不陌生：

```objc
-[NSNull integerValue] unrecognized selector sent to instance 0xblahblah

-[NSNull objectForKeyedSubscript:] unrecognized selector sent to instance 0xblahblah.

-[NSNull objectAtIndexPath:] unrecognized selector sent to instance 0xblahblah.
```

因为 Objective-C 在集合类型中用 `NSNull` 来代表 `nil`，导致不能像`nil`一样向其调用任意方法而不崩溃。Objective-C 不像 Swift 一样有`guard let` 关键字，如果要安全地处理 JSON 字典中的元素，你必须要检查该元素的类型是否是你期望的，如下：

```objc
if ([JSONDictionary[@"data"] isKindOfClass:[NSDictionary class]]) {
    NSDictionary *data = JSONDictionary[@"data"];
    if ([data[@"user"] isKindOfClass:[NSStriNSDictionaryng class]]) {
        NSDictionary *data = data[@"user"];
        if ([data[@"userName"] isKindOfClass:[NSString class]]) {
              // 终于可以拿到值了
        }
    }
}
```

感到嵌套层级过深的问题了吗？用 BLJSON 来处理这种情况，生活可以轻松又愉快，如下：

```objc
BLJSONMake(JSONDictionary)[@"data"][@"user"][@"userName"].string
```
  
就这样。 BLJSON 会把`NSNull`转换成`nil`，避免向`NSNull`发送消息而导致崩溃。

还有个有用的小功能：BLJSON 能够自动处理数字和字符串之间的转换。如果你尝试将一个值解释成整数，但实际上这个值的类型是字符串，BLJSON 会尝试调用`-[NSString integerValue] `将这个值转换成整数，数字转字符串反之亦然。这个功能能够在服务端错误地设置了数据的类型时避免 App 的崩溃。
