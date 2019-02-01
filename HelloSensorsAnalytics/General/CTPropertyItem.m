//
//  CTPropertyItem.m
//  HelloSensorsAnalytics
//
//  Created by 赫红领 on 2019/1/30.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import "CTPropertyItem.h"

@interface CTPropertyItem()
//@property (nonatomic, assign, readwrite) CTPropertyType valueType;
@property (nonatomic, strong, readwrite) NSMutableArray<CTPropertyItem *> *subItems;
@end

@implementation CTPropertyItem

+ (CTPropertyItem *)stringItem {
    CTPropertyItem *item = [CTPropertyItem new];
    item.valueType = CTPropertyTypeArray;
    return item;
}

+ (CTPropertyItem *)boolItem {
    CTPropertyItem *item = [CTPropertyItem new];
    item.valueType = CTPropertyTypeBool;
    return item;
}

+ (CTPropertyItem *)numericItem {
    CTPropertyItem *item = [CTPropertyItem new];
    item.valueType = CTPropertyTypeNumber;
    return item;
}

+ (CTPropertyItem *)dateItem {
    CTPropertyItem *item = [CTPropertyItem new];
    item.valueType = CTPropertyTypeDate;
    return item;
}

+ (CTPropertyItem *)arrayItem {
    CTPropertyItem *item = [CTPropertyItem new];
    item.valueType = CTPropertyTypeArray;
    item.subItems = [NSMutableArray array];
    return item;
}

+ (CTPropertyItem *)childItem {
    CTPropertyItem *item = [CTPropertyItem new];
    item.valueType = CTPropertyTypeChild;
    return item;
}


- (void)addChildItem:(CTPropertyItem *)childItem {
    [self.subItems addObject:childItem];
    childItem.superItem = self;
}

- (void)removeChildItem:(CTPropertyItem *)childItem {
    [self.subItems removeObject:childItem];
}
@end


@implementation CTPropertyItem (Transform)
//
//+ (NSDictionary *)propertiesWithItemArray:(NSArray<PropertyItem *> *)array {
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//
//    //    for (PropertyItem *item in items) {
//    //        if (item.valueType == CTPropertyTypeChild) {
//    //            continue;
//    //        } else if (item.valueType == CTPropertyTypeArray) {
//    //            NSMutableArray *stringArray = [NSMutableArray new];
//    //            for (PropertyItem *subItem in item.subItems) {
//    //                [stringArray addObject:subItem.value];
//    //            }
//    //            item.value = [stringArray copy];
//    //        }
//    //        [dict setValue:item.value forKey:item.key];
//    //    }
//    return [dict copy];
//}

@end

