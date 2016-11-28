/*
 
 * AMERICA ONLINE CONFIDENTIAL INFORMATION
 
 *
 
 * Copyright (c) 2016 AOL Inc
 
 *
 
 * All Rights Reserved.  Unauthorized reproduction, transmission, or
 
 * distribution of this software is a violation of applicable laws.
 
 */

#import "NSData+AESCrypt.h"
#import <CommonCrypto/CommonCryptor.h>

const int kKeySize = 32;

@implementation NSData (AESCrypt)

- (NSData *)AES128EncryptWithKey:(NSString *)key {
    char keyPtr[kKeySize + 1]; // room for terminator (unused)
    [key getCString:keyPtr maxLength:sizeof( keyPtr ) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc( bufferSize );
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt( kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionECBMode,
                                          keyPtr,
                                          kKeySize,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes],
                                          dataLength, /* input */
                                          buffer,
                                          bufferSize, /* output */
                                          &numBytesEncrypted );
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free( buffer ); //free the buffer
    return nil;
}

@end
