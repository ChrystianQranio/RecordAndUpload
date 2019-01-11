//
//  UIButton+UIActivityIndicatorForSDWebImage.m
//  Pods
//
//  Created by Rafael Nobre on 07/07/14.
//
//

#import "UIButton+UIActivityIndicatorForSDWebImage.h"
#import "UIView+UIActivityIndicatorForSDWebImage.h"

@implementation UIButton (UIActivityIndicatorForSDWebImage)

@dynamic activityIndicator;

#pragma mark - Methods

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle {
    [self setImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil usingActivityIndicatorStyle:activityStyle];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStye {
    [self setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil usingActivityIndicatorStyle:activityStye];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle{
    [self setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil usingActivityIndicatorStyle:activityStyle];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(SDWebImageCompletionBlock)completedBlock usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle {
    [self setImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock usingActivityIndicatorStyle:activityStyle];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle {
    [self setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock usingActivityIndicatorStyle:activityStyle];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle {
    
    [self addActivityIndicatorWithStyle:activityStyle];
    
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:url
                 forState:state
         placeholderImage:placeholder
                  options:options
                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageUrl) {
                    if (completedBlock) {
                        completedBlock(image, error, cacheType, imageUrl);
                    }
                    [weakSelf removeActivityIndicator];
                }
     ];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle {
    [self setImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil usingActivityIndicatorStyle:activityStyle];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStye {
    [self setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil usingActivityIndicatorStyle:activityStye];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle{
    [self setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil usingActivityIndicatorStyle:activityStyle];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(SDWebImageCompletionBlock)completedBlock usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle {
    [self setImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock usingActivityIndicatorStyle:activityStyle];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle {
    [self setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock usingActivityIndicatorStyle:activityStyle];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle {
    
    [self addActivityIndicatorWithStyle:activityStyle];
    
    __weak typeof(self) weakSelf = self;
    [self sd_setBackgroundImageWithURL:url
                           forState:state
                   placeholderImage:placeholder
                            options:options
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageUrl) {
                              if (completedBlock) {
                                  completedBlock(image, error, cacheType, imageUrl);
                              }
                              [weakSelf removeActivityIndicator];
                          }
     ];
}

@end
