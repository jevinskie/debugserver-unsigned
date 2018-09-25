#include <CoreFoundation/CFBase.h>
#include <Foundation/Foundation.h>
#include <Security/Security.h>

%hookf(OSStatus, SecKeyRawVerify, SecKeyRef key, SecPadding padding, const uint8_t *signedData, size_t signedDataLen, const uint8_t *sig, size_t sigLen) {
	NSLog(@"Forcing SecKeyRawVerify to return success");
	return errSecSuccess;
}
