
[![Build Status](https://travis-ci.org/triture/anonstruct.svg?branch=master)](https://travis-ci.org/triture/anonstruct.svg)


# Anonymous Structures

Structural validation for dynamic / anonymous objects at runtime.

## Overview
You can check basic types like strings and ints values. For example:
```haxe
var validator:AnonStruct = new AnonStruct();
validator.valueString()
    .allowEmpty()
    .refuseNull()
    .startsWith('This')
    .setAllowedOptions(['This is an example', 'Something']);

trace(validator.pass('This is an example'));        // true
trace(validator.pass(''));                          // true
trace(validator.pass('  \n  '));                    // true
trace(validator.pass('Something'));                 // false
trace(validator.pass('This test!'));                // false
trace(validator.pass(null));                        // false
trace(validator.pass(42));                          // false

trace(validator.getErrors('This is an example'));   // []
trace(validator.getErrors(''));                     // []
trace(validator.getErrors('  \n  '));               // []
trace(validator.getErrors('Something'));            // [AnonStructError:Value must starts with This]
trace(validator.getErrors('This test!'));           // [AnonStructError:This test! is not allowed. Allowed values are: This is an example, Something.]
trace(validator.getErrors(null));                   // [AnonStructError:Value cannot be null]
trace(validator.getErrors(42));                     // [AnonStructError:Value must be String]

```


For complex objects, you can describe the expected data structure:
```haxe
var validator:AnonStruct = new AnonStruct();
validator.propertyString('a')
    .allowEmpty()
    .allowNull();

validator.propertyInt('b')
    .refuseNull()
    .greaterOrEqualThan(10);

trace(validator.pass({a:'', b:10, c:[]}));          // true
trace(validator.pass({b:10}));                      // true
trace(validator.pass({b:5}));                       // false
trace(validator.pass({c:5}));                       // false
```

AnonStruct also check children objects ...
```haxe
validator.propertyObject('child')
    .allowNull()
    .setStruct(validator);

trace(validator.getErrors({a:'', b:10}));                                  // []
trace(validator.getErrors({a:'', b:10, child:null}));                      // []
trace(validator.getErrors({a:'', b:10, child:{a:'x', b:5}}));              // [AnonStructError:child.b: Value should be greater than or equal 10]
trace(validator.getErrors({a:'', b:10, child:{b:20, child:{b:null}}}));    // [AnonStructError:child.child.b: Value cannot be null]

```


... and arrays.
```haxe
validator.propertyArray('list')
    .allowNull()
    .setStruct(validator);

trace(validator.getErrors({a:'', b:10}));                                  // []
trace(validator.getErrors({b:10, list:[]}));                               // []
trace(validator.getErrors({b:10, list:[{b:10}, {b:0}]}));                  // [AnonStructError:list.[1].b: Value should be greater than or equal 10]
```

---
## AnonStruct

### valueBool():AnonPropBool
### valueString():AnonPropString
### valueInt():AnonPropInt
### valueFloat():AnonPropFloat
### valueArray():AnonPropArray
### valueDate():AnonPropDate
### valueObject():AnonPropObject
### refuseNull():Void
### allowNull():Void
### propertyInt(prop:String):AnonPropInt
### propertyFloat(prop:String):AnonPropFloat
### propertyString(prop:String):AnonPropString
### propertyObject(prop:String):AnonPropObject
### propertyArray(prop:String):AnonPropArray
### propertyDate(prop:String):AnonPropDate
### propertyBool(prop:String):AnonPropBool
### validateAll(data:Dynamic, stopOnFirstError:Bool = false):Void 
### validate(data:Dynamic):Void
### getErrors(data:Dynamic):Array<AnonStructError>
### pass(data:Dynamic):Bool

---
## AnonPropDate

### addErrorLabel(label:String):AnonPropDate
### addValidation(func:DateTime->Void):AnonPropDate
### refuseNull():AnonPropDate
### allowNull():AnonPropDate
### greaterOrEqualThan(date:Null<DateTime>):AnonPropDate
### greaterThan(date:Null<DateTime>):AnonPropDate
### greaterThan(date:Null<DateTime>):AnonPropDate
### lessThan(date:Null<DateTime>):AnonPropDate
### lessOrEqualThan(date:Null<DateTime>):AnonPropDate

---
## AnonPropArray

### minLen(len:Int):AnonPropArray
### maxLen(len:Int):AnonPropArray
### addErrorLabel(label:String):AnonPropArray
### setStruct(structure:AnonStruct):AnonPropArray
### refuseNull():AnonPropArray
### allowNull():AnonPropArray
### addValidation(func:Array<Dynamic>->Void):AnonPropArray

---
## AnonPropObject

### addErrorLabel(label:String):AnonPropObject
### addValidation(func:Dynamic->Void):AnonPropObject
### refuseNull():AnonPropObject
### allowNull():AnonPropObject
### setStruct(structure:AnonStruct):AnonPropObject

---
## AnonPropString

### setAllowedOptions(values:Null<Array<String>>, matchCase:Bool = true):AnonPropString
### addErrorLabel(label:String):AnonPropString
### addValidation(func:String->Void):AnonPropString
### startsWith(value:Null<String>):AnonPropString
### endsWith(value:Null<String>):AnonPropString
### refuseNull():AnonPropString
### allowNull():AnonPropString
### refuseEmpty():AnonPropString
### allowEmpty():AnonPropString
### maxChar(chars:Null<Int>):AnonPropString
### minChar(chars:Null<Int>):AnonPropString
### allowChars(chars:Null<String>):AnonPropString

---
## AnonPropInt

### addErrorLabel(label:String):AnonPropInt
### addValidation(func:Int->Void):AnonPropInt
### refuseNull():AnonPropInt
### allowNull():AnonPropInt
### lessThan(maxValue:Null<Int>):AnonPropInt
### lessOrEqualThan(maxValue:Null<Int>):AnonPropInt
### greaterThan(minValue:Null<Int>):AnonPropInt
### greaterOrEqualThan(minValue:Null<Int>):AnonPropInt

---
## AnonPropFloat

### addErrorLabel(label:String):AnonPropFloat
### addValidation(func:Float->Void):AnonPropFloat
### refuseNull():AnonPropFloat
### allowNull():AnonPropFloat
### lessThan(maxValue:Null<Float>):AnonPropFloat
### lessOrEqualThan(maxValue:Null<Float>):AnonPropFloat
### greaterThan(minValue:Null<Float>):AnonPropFloat
### greaterOrEqualThan(minValue:Null<Float>):AnonPropFloat

---
## AnonPropBool

### addErrorLabel(label:String):AnonPropBool
### addValidation(func:Bool->Void):AnonPropBool
### expectedValue(value:Bool):AnonPropBool
### refuseNull():AnonPropBool
### allowNull():AnonPropBool

