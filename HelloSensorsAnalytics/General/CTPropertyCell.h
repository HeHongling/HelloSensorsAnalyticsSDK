//
//  CTPropertyCell.h
//  HelloSensorsAnalytics
//
//  Created by 赫红领 on 2019/1/30.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTPropertyItem.h"
@class CTPropertyCell;


typedef void (^AddButtonClickHandler)(CTPropertyCell *cell);

@interface CTPropertyCell : UITableViewCell
@property (nonatomic, copy) AddButtonClickHandler commonAddButtonHandler;
@property (nonatomic, copy) AddButtonClickHandler arrayAddButtonHandler;
@property (nonatomic, strong) CTPropertyItem *propertyItem;

+ (NSString *)cellIdentifierForItemType:(CTPropertyType)type;
@end
