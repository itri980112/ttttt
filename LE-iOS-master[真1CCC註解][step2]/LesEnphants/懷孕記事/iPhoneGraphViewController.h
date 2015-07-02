//
//  iPhoneGraphViewController.h
//  Graph for iPhone
//
//  Created by Serghei Mazur on 11/26/13.
//  Copyright (c) 2013 Serghei Mazur. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol iPhoneGraphViewControllerDelegate <NSObject>

@optional
- ( void )callBackString:( NSString * )pstrPower CO2:( NSString * )pstrCO2;

@end


@interface iPhoneGraphViewController : UIView
{
    //CCC:一個變數名為delegate , 類型為id ,  並且遵守iPhoneGraphViewControllerDelegate
    id< iPhoneGraphViewControllerDelegate > delegate;
}

@property ( assign, nonatomic ) id< iPhoneGraphViewControllerDelegate > delegate;
@property(retain,nonatomic) NSArray *fistArray;
@property(retain,nonatomic) NSArray *secondArray;
@property(retain,nonatomic) NSString *Xname;
@property(retain,nonatomic) NSString *Yname;
@property(retain,nonatomic) NSArray  *months;

@property (nonatomic, assign, getter = isLinesGraph) BOOL linesGraph; //change style graph (Yes = For lines, No = For charts)

@end
