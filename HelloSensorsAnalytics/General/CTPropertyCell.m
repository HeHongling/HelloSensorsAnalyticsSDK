//
//  CTPropertyCell.m
//  HelloSensorsAnalytics
//
//  Created by 赫红领 on 2019/1/30.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import "CTPropertyCell.h"



@interface CTPropertyCell ()
@property (weak, nonatomic) IBOutlet UITextField *itemKeyField;
@property (weak, nonatomic) IBOutlet UITextField *itemValueField;

@end


@implementation CTPropertyCell

+ (NSString *)cellIdentifierForItemType:(CTPropertyType)type {
    switch (type) {
        case CTPropertyTypeString: return @"StringCell";
        case CTPropertyTypeDate: return @"DateCell";
        case CTPropertyTypeArray: return @"ArrayCell";
        case CTPropertyTypeBool: return @"BoolCell";
        case CTPropertyTypeNumber: return @"NumberCell";
        case CTPropertyTypeChild: return @"ChildCell";
        default: break;
    }
    return @"UndefineCell";
}

- (IBAction)keyFieldFinishEdit:(UITextField *)sender {
    
}

- (IBAction)valueFieldFinishEdit:(UITextField *)sender {
    
}

- (IBAction)didTappedCommonAddButton:(UIButton *)sender {
    if (self.commonAddButtonHandler) {
        self.commonAddButtonHandler(self);
    }
}

- (IBAction)didTappedArrayAddButton:(UIButton *)sender {
    if (self.arrayAddButtonHandler) {
        self.arrayAddButtonHandler(self);
    }
}

@end
