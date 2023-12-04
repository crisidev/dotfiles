#include <CoreGraphics/CoreGraphics.h>

CGWindowID getDotWindowID() {
  CFArrayRef windowInfo = CGWindowListCopyWindowInfo(
      kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
  CFIndex count = CFArrayGetCount(windowInfo);

  for (CFIndex i = 0; i < count; i++) {
    CFDictionaryRef window = CFArrayGetValueAtIndex(windowInfo, i);
    CFStringRef windowName = CFDictionaryGetValue(window, kCGWindowName);

    if (windowName && CFStringCompare(windowName, CFSTR("StatusIndicator"),
                                      0) == kCFCompareEqualTo) {
      return (CGWindowID)(uintptr_t)CFDictionaryGetValue(window,
                                                         kCGWindowNumber);
    }
  }

  return kCGNullWindowID;
}

int main() {
  CGWindowID id = getDotWindowID();

  if (id == kCGNullWindowID) {
    exit(1);
  } else {
    exit(0);
  }
}
