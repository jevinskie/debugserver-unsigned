#include <dlfcn.h>

#include <mach-o/dyld.h>

#include <CoreFoundation/CoreFoundation.h>
#include <Foundation/Foundation.h>

#include <CydiaSubstrate.h>

typedef CFTypeRef (*MGCopyAnswer_t)(CFTypeRef key);
typedef CFTypeRef (*MGCopyAnswer_sub_t)(CFTypeRef key, int *type_index);

MGCopyAnswer_t MGCopyAnswer;

MGCopyAnswer_sub_t MGCopyAnswer_sub;
MGCopyAnswer_sub_t MGCopyAnswer_sub_orig;

CFTypeRef MGCopyAnswer_sub_hook(CFTypeRef key, int *type_index) {
	NSLog(@"MGCopyAnswer_sub(%@, %p [%d])", key, type_index, type_index ? *type_index : 0);
	if (CFGetTypeID(key) == CFStringGetTypeID() && CFEqual(key, CFSTR("Jailbroken"))) {
		NSLog(@"Intercepting MGCopyAnswer for 'Jailbroken'");
		if (type_index) {
			*type_index = 11;
		}
		return kCFBooleanTrue;
	}
	CFTypeRef res = MGCopyAnswer_sub_orig(key, type_index);
	NSLog(@"MGCopyAnswer_sub(%@, %p [%d]) = %@", key, type_index, type_index ? *type_index : 0, res);
	return res;
}

__attribute__((constructor))
void lockdownd_is_jailbroken_mobilegestalt_ctor(void) {
	MSImageRef mg_img = MSGetImageByName("/usr/lib/libMobileGestalt.dylib");
	if (mg_img) {
		MGCopyAnswer = (MGCopyAnswer_t)MSFindSymbol(mg_img, "MGCopyAnswer");
		if (MGCopyAnswer) {
			MGCopyAnswer_sub = (MGCopyAnswer_sub_t)((uintptr_t)MGCopyAnswer + 4*2);
			NSLog(@"MGCopyAnswer: %p MGCopyAnswer_sub: %p", MGCopyAnswer, MGCopyAnswer_sub);
			MSHookFunction(MGCopyAnswer_sub, MGCopyAnswer_sub_hook, &MGCopyAnswer_sub_orig);
		} else {
			NSLog(@"Couldn't find MGCopyAnswer");
		}
	} else {
		NSLog(@"couldn't get handle for libMobileGestalt.dylib");
	}
}

__attribute__((constructor))
void lockdownd_is_jailbroken_lockdownd_ctor(void) {

}
