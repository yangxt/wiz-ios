//
//  WizEditNoteBase.h
//  Wiz
//
//  Created by wiz on 12-2-2.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "WizDocumentEdit.h"

#define ATTACHMENTTEMPFLITER @"attchmentTempFliter"
@class ELCImagePickerController;
@interface WizEditNoteBase : UIViewController<AVAudioRecorderDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate,WizDocumentEditDelegate>
{
    WizDocumentEdit* docEdit;
    float currentTime;
    NSMutableArray* picturesArray;
    NSMutableArray* audiosArray;
}
@property (nonatomic, retain)  WizDocumentEdit* docEdit;
@property (nonatomic, retain)  NSMutableArray* picturesArray;
@property (nonatomic, retain)  NSMutableArray* audiosArray;
@property (readonly) float currentTime;
- (void) audioStartRecode;
- (void) audioStopRecord;
- (BOOL) takePhoto;
-(BOOL) selectePhotos;
- (void) attachmentAddDone;
@end
