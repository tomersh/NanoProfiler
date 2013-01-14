NanoProfiler
============

Measure a function's runtime without adding a single line of code to the original function. Nothing more.
Use it when you need to know how long it takes to a function to run, but you don't want to use heavy tools like instruments.

##Usage
```objectivec
//MyClass.m

#import "NanoProfiler.h"

+(void) initialize {
  AddProfiler([MyClass class], @selector(foo));
}

-(void) foo {
...
}
```

Running `[self foo]` will print:

```
*** Timer MyClass_foo started. ***
*** Timer MyClass_foo stopped. runtime: 1.633041 milliseconds ***
```

NanoPrfiler is using [TheWrapper](https://github.com/tomersh/TheWrapper). Check it out!
