
[![Build Status](https://travis-ci.org/triture/anonstruct.svg?branch=master)](https://travis-ci.org/triture/anonstruct.svg)


# AnonStruct

Structural validation for dynamic / anonymous objects at runtime.

## Overview
You can check basic types like strings and ints values. For example:
```haxe
var validator:AnonStruct = new AnonStruct();
validator.setString()
    .allowEmpty()
    .refuseNull()
    .startsWith('This')
    .setAllowedOptions(['This is an example', 'Something']);

trace(validator.pass('This is an example'));    // true
trace(validator.pass(''));                      // true
trace(validator.pass('  \n  '));                // true
trace(validator.pass('Something'));             // false
trace(validator.pass('This test!'));            // false
trace(validator.pass(null));                    // false
trace(validator.pass(42));                      // false

trace(validator.getErrors('This is an example'));    // []
trace(validator.getErrors(''));                      // []
trace(validator.getErrors('  \n  '));                // []
trace(validator.getErrors('Something'));             // [AnonError:Value must starts with This]
trace(validator.getErrors('This test!'));            // [AnonError:This test! is not allowed. Allowed values are: This is an example, Something.]
trace(validator.getErrors(null));                    // [AnonError:Value cannot be null]
trace(validator.getErrors(42));                      // [AnonError:Value must be String]

```


For complex objects, you can describe the expected data structure:
```haxe
var validator:AnonStruct = new AnonStruct();
validator.valueString('a')
    .allowEmpty()
    .allowNull();

validator.valueInt('b')
    .refuseNull()
    .greaterOrEqualThan(10);

trace(validator.pass({a:'', b:10, c:[]}));          // true
trace(validator.pass({b:10}));                      // true
trace(validator.pass({b:5}));                       // false
trace(validator.pass({c:5}));                       // false
```

AnonStruct also check children objects ...
```haxe
validator.valueObject('child')
    .allowNull()
    .setStruct(validator);

trace(validator.getErrors({a:'', b:10}));                                  // []
trace(validator.getErrors({a:'', b:10, child:null}));                      // []
trace(validator.getErrors({a:'', b:10, child:{a:'x', b:5}}));              // [AnonError:child.b: Value should be greater than or equal 10]
trace(validator.getErrors({a:'', b:10, child:{b:20, child:{b:null}}}));    // [AnonError:child.child.b: Value cannot be null]
```


... and arrays.
```haxe
validator.valueArray('list')
    .allowNull()
    .setStruct(validator);

trace(validator.getErrors({a:'', b:10}));                                  // []
trace(validator.getErrors({b:10, list:[]}));                               // []
trace(validator.getErrors({b:10, list:[{b:10}, {b:0}]}));                  // [AnonError:list.[1].b: Value should be greater than or equal 10]
```