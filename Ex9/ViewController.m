//
//  ViewController.m
//  Ex9
//
//  Created by Xurxo Méndez Pérez on 26/12/13.
//  Copyright (c) 2013 SmartGalApps. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

typedef void (^MyBlockType)(float y);

int GlobalInt = 0;
int (^getGlobalInt)(void) = ^{ return GlobalInt; };

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"------------------------");
    
    int multiplier = 7;
    int (^myBlock)(int) = ^(int num) {
        return num * multiplier;
    };
    NSLog(@"myBlock: %d", myBlock(4));
    
    NSLog(@"------------------------");
    
    NSArray *stringsArray = @[ @"string 1",
                               @"String 21",
                               @"string 12",
                               @"String 11",
                               @"String 02" ];
    
    static NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch | NSNumericSearch |
    NSWidthInsensitiveSearch | NSForcedOrderingSearch;
    NSLocale *currentLocale = [NSLocale currentLocale];
    
    NSComparator finderSortBlock = ^(id string1, id string2) {
        
        NSRange string1Range = NSMakeRange(0, [string1 length]);
        return [string1 compare:string2 options:comparisonOptions range:string1Range locale:currentLocale];
    };
    
    NSArray *finderSortArray = [stringsArray sortedArrayUsingComparator:finderSortBlock];
    NSLog(@"finderSortArray: %@", finderSortArray);
    
    NSLog(@"------------------------");
    
    __block NSUInteger orderedSameCount = 0;
    
    NSArray *diacriticInsensitiveSortArray = [stringsArray sortedArrayUsingComparator:^(id string1, id string2) {
        
        NSRange string1Range = NSMakeRange(0, [string1 length]);
        NSComparisonResult comparisonResult = [string1 compare:string2 options:NSDiacriticInsensitiveSearch range:string1Range locale:currentLocale];
        
        if (comparisonResult == NSOrderedSame) {
            orderedSameCount++;
        }
        return comparisonResult;
    }];
    
    NSLog(@"diacriticInsensitiveSortArray: %@", diacriticInsensitiveSortArray);
    NSLog(@"orderedSameCount: %d", orderedSameCount);
    
    NSLog(@"------------------------");
    
    [self operateWithX:3.0 withBlock:^(float y) {
        NSLog(@"operateWithX: %f", y + 5.0);
    }];
    NSLog(@"------------------------");

    float (^oneFrom)(float);
    
    oneFrom = ^(float aFloat) {
        float result = aFloat - 1.0;
        return result;
    };
    
    NSLog(@"oneFrom: %f", oneFrom(10));
    
    NSLog(@"------------------------");
    
    NSLog(@"%d", getGlobalInt());
    
    NSLog(@"------------------------");
    
    int x = 15;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"dispatch: %d", x * 8);
    });
    
    NSLog(@"------------------------");
    
    float (^distanceTraveled)(float, float, float) =
    ^(float startingSpeed, float acceleration, float time) {
        
        float distance = (startingSpeed * time) + (0.5 * acceleration * time * time);
        return distance;
    };
    
    
    NSLog(@"distanceTraveled: %f", distanceTraveled(0.0, 9.8, 1.0));
    
    NSLog(@"------------------------");
    
    NSArray *array = @[@"A", @"B", @"C", @"A", @"B", @"Z", @"G", @"are", @"Q"];
    NSSet *filterSet = [NSSet setWithObjects: @"A", @"Z", @"Q", nil];
    
    BOOL (^test)(id obj, NSUInteger idx, BOOL *stop);
    
    test = ^(id obj, NSUInteger idx, BOOL *stop) {
        
        if (idx < 7) {
            if ([filterSet containsObject: obj]) {
                return YES;
            }
        }
        return NO;
    };
    
    NSIndexSet *indexes = [array indexesOfObjectsPassingTest:test];
    
    NSLog(@"indexes: %@", indexes);
    
    
    NSLog(@"------------------------");
}

- (void)operateWithX:(float)x withBlock:(MyBlockType)block
{
    float y = 2 * x;
    
    block(y);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
