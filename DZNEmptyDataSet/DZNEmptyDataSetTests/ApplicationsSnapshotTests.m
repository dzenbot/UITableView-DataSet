//
//  DZNEmptyDataSetTests.m
//  DZNEmptyDataSetTests
//
//  Created by Ignacio Romero on 2/28/17.
//  Copyright © 2017 DZN. All rights reserved.
//

#import <FBSnapshotTestCase/FBSnapshotTestCase.h>
#import <DZNEmptyDataSet/DZNEmptyDataSet.h>

#import "Application.h"
#import "DetailViewController.h"

@interface ApplicationsSnapshotTests : FBSnapshotTestCase
@end

@implementation ApplicationsSnapshotTests

- (void)setUp {
    [super setUp];
    
    self.recordMode = NO;
    
    // Snaphot tests are not yet configured to be running for multiple hardware configuration (device type, system version, screen density, etc.).
    // We make sure tests are only ran for @2x iPhone simulators, with iOS 10 or above.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIDevice *device = [UIDevice currentDevice];
        UIScreen *screen = [UIScreen mainScreen];
        CGFloat width = screen.bounds.size.width;
        CGFloat height = screen.bounds.size.height;
        CGFloat minLength = MIN(width,height);
        CGFloat maxLength = MAX(width,height);
        // Using XCTAssert instead of NSAssert since these do not cause the tests to fail.
        XCTAssert([device.model containsString:@"iPhone"], @"Please run snapshot tests on an iPhone.");
        XCTAssert((minLength==375)&&(maxLength==667), @"Please run snapshot tests on an iPhone 6, 6s, 7, or 8.");
        XCTAssert([device.systemVersion doubleValue] > 11.0, @"Please run snapshot tests on a simulator with iOS 11.0 or above.");
        XCTAssert(screen.scale == 2.0, @"Please run snapshot tests on a @2x density simulator.");
    });
}

- (void)tearDown {
    [super tearDown];
}

- (void)testApplicationEmptyDataSets
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"applications" ofType:@"json"];
    NSArray *applications = [Application applicationsFromJSONAtPath:path];
    
    for (Application *app in applications) {
        
        DetailViewController *vc = [[DetailViewController alloc] initWithApplication:app];
        
        [self verifyView:vc.view withIdentifier:app.displayName];
    }
}

#pragma mark - FBSnapshotTestCase

- (NSString *)getReferenceImageDirectoryWithDefault:(NSString *)dir
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [[bundle infoDictionary] valueForKey:@"XCodeProjectPath"];
    return [NSString stringWithFormat:@"%@/DZNEmptyDataSetTests/ReferenceImages", path];
}

- (void)verifyView:(UIView *)view withIdentifier:(NSString *)identifier
{
    NSLog(@"%@", identifier);
    FBSnapshotVerifyViewWithOptions(view, identifier, FBSnapshotTestCaseDefaultSuffixes(), 0);
}

@end
