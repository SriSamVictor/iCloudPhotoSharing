//
//  GalleryViewController.m
//  iCloudPhotoSharingApp
//
//  Created by jeanmartin on 05/02/19.
//  Copyright © 2019 jeanmartin. All rights reserved.
//

#import "GalleryViewController.h"
#import "GalleryCollectionViewCell.h"
#import "ImageViewController.h"
#import "PageViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface GalleryViewController (){
    NSArray *picturePathArray;
    UIImage *collectImage;
    NSMutableArray *imageArray;
    UIImage *image;
    NSInteger deleteButton;
    NSInteger cancelButton;
}

@end

@implementation GalleryViewController
@synthesize collectedImageArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.deleteBtnOutlet.hidden = NO;
    self.cancelButtonOutlet.hidden = YES;
    [self.deleteBtnOutlet addTarget:self action:@selector(touchDownMethod:) forControlEvents:UIControlEventTouchDown];
    [self.cancelButtonOutlet addTarget:self action:@selector(touchUpInsideMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.collectionView reloadData];
    [self.collectionView setAllowsMultipleSelection:YES];
}
-(void)touchDownMethod:(UIButton *)sender{
    NSLog(@"Touch Down Method");
    deleteButton = sender.tag;
    self.deleteBtnOutlet.hidden = YES;
    self.cancelButtonOutlet.hidden = NO;
}
-(void)touchUpInsideMethod:(UIButton *)sender {
    NSLog(@"Touch Up Inside");
    cancelButton = sender.tag;
    self.deleteBtnOutlet.hidden = NO;
    self.cancelButtonOutlet.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    NSLog(@"Collection Images--- %@",collectedImageArray);
        [self getImagesStroage];
}
-(void)getImagesStroage{
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *searchFolderName = @"Pictures";
        NSString *newVideoDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.lastPathComponent == %@", searchFolderName];
        NSArray *matchingPaths = [[[NSFileManager defaultManager] subpathsAtPath:newVideoDirectory] filteredArrayUsingPredicate:predicate];
        NSString *picPath = [matchingPaths objectAtIndex:0];
        NSString *finalPath = [newVideoDirectory stringByAppendingPathComponent:picPath];
        self->picturePathArray = [fileManager contentsOfDirectoryAtPath:finalPath error:&error];
        self->imageArray = [[NSMutableArray alloc]init];
        for(int i = 0; i < [self->picturePathArray count]; i++){
            NSString *pictureStr = [self->picturePathArray objectAtIndex:i];
            NSString *fullPathPicStr = [finalPath stringByAppendingPathComponent:pictureStr];
            [self->imageArray addObject:fullPathPicStr];
        }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
}
#pragma mark - UICollectionview delegate and datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return imageArray.count;
}
// Layout: Set cell size
-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            return CGSizeMake(collectionView.frame.size.width/3, collectionView.frame.size.height/2);
        }
        else {
            return CGSizeMake(collectionView.frame.size.width/4, collectionView.frame.size.height/4);
        }
    }
   else
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            return CGSizeMake(collectionView.frame.size.width/2, collectionView.frame.size.height/3);
        }
        else {
            return CGSizeMake(collectionView.frame.size.width/2, collectionView.frame.size.height/3);
        }
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        NSInteger numberOfItemsInCollection = [collectionView numberOfItemsInSection:0];
        GalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
        if(numberOfItemsInCollection > 0){
                    self.collectionImagesView.hidden = NO;
                    self.noRecordsFoundView.hidden = YES;
                    cell.collectionImageView.layer.cornerRadius = 5.0;
                    cell.collectionImageView.clipsToBounds = YES;
                    NSURL  *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",[self->imageArray objectAtIndex:indexPath.row]]];
                    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
                    cell.collectionImageView.image = image;
                }else{
                    self.collectionImagesView.hidden = YES;
                    self.noRecordsFoundView.hidden = NO;
                }
         return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PageViewController *pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
        pageViewController.deviceArray = imageArray;
        pageViewController.particularIndex = indexPath.row;
        //    NSURL  *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",[imageArray objectAtIndex:indexPath.row]]];
        //    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
        //    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
        //    imageViewController.imageView = image;
        [self.navigationController pushViewController:pageViewController animated:YES];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell=[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = nil;
}
- (IBAction)galleryBackBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)deleteBtnAction:(id)sender {
    
}
@end
