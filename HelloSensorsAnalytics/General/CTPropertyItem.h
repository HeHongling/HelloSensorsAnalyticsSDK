//
//  CTPropertyItem.h
//  HelloSensorsAnalytics
//
//  Created by 赫红领 on 2019/1/30.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CTPropertyType) {
    CTPropertyTypeNumber,
    CTPropertyTypeBool,
    CTPropertyTypeString,
    CTPropertyTypeArray,
    CTPropertyTypeDate,
    CTPropertyTypeChild
};


@interface CTPropertyItem : NSObject
@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) id value;
@property (nonatomic, assign) CTPropertyType valueType;
@property (nonatomic, weak) CTPropertyItem *superItem;


+ (CTPropertyItem *)stringItem;
+ (CTPropertyItem *)boolItem;
+ (CTPropertyItem *)numericItem;
+ (CTPropertyItem *)dateItem;
+ (CTPropertyItem *)arrayItem;
+ (CTPropertyItem *)childItem;

- (void)addChildItem:(CTPropertyItem *)childItem;
- (void)removeChildItem:(CTPropertyItem *)childItem;
@end


@interface CTPropertyItem (Transform)
+ (NSDictionary *)propertiesWithRootItems:(NSArray <CTPropertyItem *>*)array;
@end
