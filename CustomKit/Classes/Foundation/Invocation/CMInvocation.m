//
//  MDInvocation.m
//  MomoChat
//
//  Created by Zero.D.Saber on 2019/9/20.
//  Copyright © 2019 wemomo.com. All rights reserved.
//

#import "CMInvocation.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@implementation CMInvocation

#pragma mark - Invoke

+ (id)cm_target:(id)target invokeSelectorWithArgs:(SEL)selector, ... {
    va_list args;
    va_start(args, selector);
    id result = [self cm_target:target invokeSelector:selector args:args];
    va_end(args);
    
    return result;
}

+ (id)cm_target:(id)target invokeSelector:(SEL)selector args:(va_list)args {
    if (![target respondsToSelector:selector]) {
        NSAssert2(NO, @"%@ doesNotRecognizeSelector: %@", target, NSStringFromSelector(selector));
        return nil;
    }
    
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = selector;
    
    [self buildInvocation:invocation singature:signature args:args];
    
    [invocation invoke];
    
    id result = [self returnValueWithInvocation:invocation singature:signature];
    
    return result;
}

#pragma mark - Private

+ (void)buildInvocation:(NSInvocation *)invocation singature:(NSMethodSignature *)signature args:(va_list)args {
    NSUInteger argsCount = signature.numberOfArguments;
    for (NSUInteger index = 2; index < argsCount; ++index) {
        const char *argType = [signature getArgumentTypeAtIndex:index];
        while (*argType == _C_CONST || // const
               *argType == 'n' || // in
               *argType == 'N' || // inout
               *argType == 'o' || // out
               *argType == 'O' || // bycopy
               *argType == 'R' || // byref
               *argType == 'V') { // oneway
            argType++; // cutoff useless prefix
        }
        
        BOOL unsupportedType = NO;
        switch (*argType) {
            case _C_VOID:
            case _C_BOOL:
            case _C_CHR:
            case _C_UCHR:
            case _C_SHT:
            case _C_USHT:
            case _C_INT:
            case _C_UINT:
            case _C_LNG:
            case _C_ULNG: {
                int arg = va_arg(args, int);
                [invocation setArgument:&arg atIndex:index];
            } break;
            case _C_FLT: {
                double arg = va_arg(args, double);
                float argf = arg;
                [invocation setArgument:&argf atIndex:index];
            } break;
            case _C_DBL: {
                double arg = va_arg(args, double);
                [invocation setArgument:&arg atIndex:index];
            } break;
            case _C_LNG_LNG:
            case _C_ULNG_LNG: {
                long long arg = va_arg(args, long long);
                [invocation setArgument:&arg atIndex:index];
            } break;
            case 'D': {
                long double arg = va_arg(args, long double);
                [invocation setArgument:&arg atIndex:index];
            } break;
            case _C_CHARPTR:
            case _C_PTR: {
                void *arg = va_arg(args, void *);
                [invocation setArgument:&arg atIndex:index];
            } break;
            case _C_SEL: {
                SEL arg = va_arg(args, SEL);
                [invocation setArgument:&arg atIndex:index];
            } break;
            case _C_CLASS: {
                Class arg = va_arg(args, Class);
                [invocation setArgument:&arg atIndex:index];
            } break;
            case _C_ID: {
                id arg = va_arg(args, id);
                [invocation setArgument:&arg atIndex:index];
            } break;
            case _C_STRUCT_B: {
                if (strcmp(argType, @encode(CGPoint)) == 0) {
                    CGPoint arg = va_arg(args, CGPoint);
                    [invocation setArgument:&arg atIndex:index];
                } else if (strcmp(argType, @encode(CGSize)) == 0) {
                    CGSize arg = va_arg(args, CGSize);
                    [invocation setArgument:&arg atIndex:index];
                } else if (strcmp(argType, @encode(CGRect)) == 0) {
                    CGRect arg = va_arg(args, CGRect);
                    [invocation setArgument:&arg atIndex:index];
                } else if (strcmp(argType, @encode(CGVector)) == 0) {
                    CGVector arg = va_arg(args, CGVector);
                    [invocation setArgument:&arg atIndex:index];
                } else if (strcmp(argType, @encode(CGAffineTransform)) == 0) {
                    CGAffineTransform arg = va_arg(args, CGAffineTransform);
                    [invocation setArgument:&arg atIndex:index];
                } else if (strcmp(argType, @encode(CATransform3D)) == 0) {
                    CATransform3D arg = va_arg(args, CATransform3D);
                    [invocation setArgument:&arg atIndex:index];
                } else if (strcmp(argType, @encode(NSRange)) == 0) {
                    NSRange arg = va_arg(args, NSRange);
                    [invocation setArgument:&arg atIndex:index];
                } else if (strcmp(argType, @encode(UIOffset)) == 0) {
                    UIOffset arg = va_arg(args, UIOffset);
                    [invocation setArgument:&arg atIndex:index];
                } else if (strcmp(argType, @encode(UIEdgeInsets)) == 0) {
                    UIEdgeInsets arg = va_arg(args, UIEdgeInsets);
                    [invocation setArgument:&arg atIndex:index];
                } else {
                    unsupportedType = YES;
                }
            } break;
            default: {
                unsupportedType = YES;
            } break;
        }
    }
}

+ (id)returnValueWithInvocation:(NSInvocation *)invocation singature:(NSMethodSignature *)signature {
    NSUInteger length = signature.methodReturnLength;
    if (length == 0) return nil;
    
    char *retType = (char *)signature.methodReturnType;
    while (*retType == _C_CONST || // const
           *retType == 'n' || // in
           *retType == 'N' || // inout
           *retType == 'o' || // out
           *retType == 'O' || // bycopy
           *retType == 'R' || // byref
           *retType == 'V') { // oneway
        retType++; // cutoff useless prefix
    }
    
    switch (*retType) {
        case _C_VOID: {
            return nil;
        } break;
        case _C_BOOL: {
            BOOL retValue;
            [invocation getReturnValue:&retValue];
            return @(retValue);
        } break;
        case _C_CHR: {
            char retValue;
            [invocation getReturnValue:&retValue];
            return @(retValue);
        } break;
        case _C_UCHR: {
            unsigned char retValue;
            [invocation getReturnValue:&retValue];
            return @(retValue);
        } break;
        case _C_SHT: {
            short retValue;
            [invocation getReturnValue:&retValue];
            return @(retValue);
        } break;
        case _C_USHT: {
            unsigned short retValue;
            [invocation getReturnValue:&retValue];
            return @(retValue);
        } break;
        case _C_INT: {
            int retValue;
            [invocation getReturnValue:&retValue];
            return @(retValue);
        } break;
        case _C_UINT: {
            unsigned int retValue;
            [invocation getReturnValue:&retValue];
            return @(retValue);
        } break;
        case _C_LNG: {
            long retValue;
            [invocation getReturnValue:&retValue];
            return @(retValue);
        } break;
        case _C_ULNG: {
            unsigned long retValue;
            [invocation getReturnValue:&retValue];
            return @(retValue);
        } break;
        case _C_FLT: {
            float retValue;
            [invocation getReturnValue:&retValue];
            return @(retValue);
        } break;
        case _C_DBL: {
            double retValue;
            [invocation getReturnValue:&retValue];
            return @(retValue);
        } break;
        case _C_LNG_LNG: {
            long long retValue;
            [invocation getReturnValue:&retValue];
            return @(retValue);
        } break;
        case _C_ULNG_LNG: {
            unsigned long long retValue;
            [invocation getReturnValue:&retValue];
            return @(retValue);
        } break;
        case 'D': {
            long double retValue;
            [invocation getReturnValue:&retValue];
            return [NSNumber numberWithDouble:retValue];
        } break;
        case _C_CLASS: {
            Class retValue;
            [invocation getReturnValue:&retValue];
            return retValue;
        } break;
        case _C_ID: {
            __autoreleasing id retValue;
            [invocation getReturnValue:&retValue];
            return retValue;
        } break;
        default: {
            const char *objCType = signature.methodReturnType;
            char *buf = calloc(1, length);
            if (!buf) return nil;
            
            [invocation getReturnValue:buf];
            NSValue *retValue = [NSValue valueWithBytes:buf objCType:objCType];
            free(buf);
            return retValue;
        } break;
    }
}

@end
