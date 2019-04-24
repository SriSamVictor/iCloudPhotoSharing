//
//  PageViewController.m
//  iCloudPhotoSharingApp
//
//  Created by jeanmartin on 07/02/19.
//  Copyright © 2019 jeanmartin. All rights reserved.
//

#import "PageViewController.h"
#import "ImageViewController.h"

@interface PageViewController (){
    ImageViewController *imageViewController;
}

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    self.delegate = self;
    ImageViewController *vc = (ImageViewController *)[self viewControllerAtIndex:self.particularIndex];
    NSArray *arr = [NSArray arrayWithObject:vc];
    [self setViewControllers:arr direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}
    
#pragma mark - UIPageViewController Delegate and Datasource

-(UIViewController *)viewControllerAtIndex:(NSUInteger)index{
    imageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageViewController"];
    imageViewController.strImages = self.deviceArray[index];
    imageViewController.pageIndex = index;
    return imageViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = ((ImageViewController *)viewController).pageIndex;
    if(index == 0 || index == NSNotFound){
        
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = ((ImageViewController *)viewController).pageIndex;
    if(index == NSNotFound){
        return nil;
    }
    index++;
    if(index == _deviceArray.count){
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

@end
