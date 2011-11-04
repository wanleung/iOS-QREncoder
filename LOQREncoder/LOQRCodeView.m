//
//  QRCodeView.m
//  CoffeeShop
//
//  Created by Wan Leung Wong <wanleung@linkomnia.com> on 5/9/11.
//  Copyright 2011 LinkOmnia Ltd.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "LOQRCodeView.h"

#import "qrencode.h"

#import <QuartzCore/QuartzCore.h>

@interface LOQRCodeView () {
    @private
        QRcode *qrcode_;
        CGFloat width_;
}
@end

@implementation LOQRCodeView

- (id)initWithEncodeString:(NSString *)aString {
    return [self initWithEncodeString:aString width:200];
}

- (id)initWithEncodeString:(NSString *)aString width:(CGFloat)width {
    self = [self initWithFrame:CGRectMake(0, 0, width, width)];
    qrcode_ = QRcode_encodeString([aString UTF8String], 0, QR_ECLEVEL_H, QR_MODE_8, 1);
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        width_ = frame.size.width;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    CGContextSetGrayFillColor(myContext, 1, 1);
    CGContextFillRect (myContext, CGRectMake (0, 0, width_, width_));
    CGContextSetGrayFillColor(myContext, 0, 1);
    CGContextSetLineWidth(myContext, 0.5);
    int width = qrcode_->width;
    float wl = width_/(float)width;    
    for (int i = 0; i < (width * width);i++) {
        int bx = i % width;
        int by = i / width;
        if (qrcode_->data[i] & 1) {
            CGContextAddRect(myContext, CGRectMake((float)bx * wl, (float)by * wl , wl, wl));
            CGContextDrawPath(myContext, kCGPathFillStroke);
        }
    }
}

- (void)dealloc {
    QRcode_free(qrcode_);
    //[super dealloc];  /// LLVM ARC Support
}
@end
