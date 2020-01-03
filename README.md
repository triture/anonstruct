
[![Build Status](https://travis-ci.org/triture/anonstruct.svg?branch=master)](https://travis-ci.org/triture/anonstruct)


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


It's easy to set custom validations:
```haxe
typedef UserLoginData = {

    var user:String;
    var password:String;
    
}

class ValidateUserLoginData extends AnonStruct {
    
    public function new() {
        super();

        this.propertyString('user')
            .refuseEmpty()
            .refuseNull()
            .addValidation(this.checkEmail);

        this.propertyString('password')
            .refuseEmpty()
            .refuseNull()
            .minChar(6)
            .addValidation(
                function (value:String):Void {
                    var hasNumber:Bool = false;

                    for (i in 0 ... value.length) 
                        if ('0123456789'.indexOf(value.charAt(i)) > -1) {
                            hasNumber = true;
                            break;
                        }

                    if (!hasNumber) throw 'The password must include numbers.';
                }
            );
    }

    private function checkEmail(value:String):Void {
        var emailExpression:EReg = ~/[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z][A-Z][A-Z]?/i;
        if (!emailExpression.match(value)) throw 'User must be a valid email address.';
    }
}

class Test {
    static public function test():Void {
        var user:UserLoginData = {
            user : 'someuser@somewhere.com',
            password : 'pass1234'
        }

        var validator:ValidateUserLoginData = new ValidateUserLoginData();
        trace(validator.getErrors(user));                                           // []
        
        user = {
            user : 'wrong_user',
            password : 'pass error'
        }
        trace(validator.getErrors(user));                                           // [AnonStructError:user: user must be a valid email address. , AnonStructError:password: The password must include numbers.]
    }
}

```

---
## AnonStruct

### valueBool():AnonPropBool
Checks if object to be tested is a `bool` value.

### valueString():AnonPropString
Checks if object to be tested is a `string` value.

### valueInt():AnonPropInt
Checks if object to be tested is ai `int` value.

### valueFloat():AnonPropFloat
Checks if object to be tested is a `float` value.

### valueArray():AnonPropArray
Checks if object to be tested is an `array` value.

### valueDate():AnonPropDate
Checks if object to be tested is a `date` value.

### valueObject():AnonPropObject
Checks if object to be tested is an `object` value.

### refuseNull():Void
The object to be tested cannot be `null`.

### allowNull():Void
The object to be tested can be `null`.

### propertyInt(prop:String):AnonPropInt
Checks if the object to be tested have has an `int` property named `prop`.

### propertyFloat(prop:String):AnonPropFloat
Checks if the object to be tested have has a `float` property named `prop`.

### propertyString(prop:String):AnonPropString
Checks if the object to be tested have has a `string` property named `prop`.

### propertyObject(prop:String):AnonPropObject
Checks if the object to be tested have has an `object` property named `prop`.

### propertyArray(prop:String):AnonPropArray
Checks if the object to be tested have has an `array` property named `prop`.

### propertyDate(prop:String):AnonPropDate
Checks if the object to be tested have has a `date` property named `prop`.

### propertyBool(prop:String):AnonPropBool
Checks if the object to be tested have has a `bool` property named `prop`.

### validateAll(data:Dynamic, stopOnFirstError:Bool = false):Void 
Validate `data` against the rules. If `stopOnFirstError` is true, AnonStruct will stop at first error ocurrence.

Throws `Array<AnonStructError>` if `data` don't meet the requirements.

### validate(data:Dynamic):Void
Validate `data` against the rules and stops on first error.

Throws `AnonStructError` if `data` don't meet the requirements.

### getErrors(data:Dynamic):Array<AnonStructError>
Validate `data` against the rules and returns `Array<AnonStructError>`. If no errors found, returns an empty array.

### pass(data:Dynamic):Bool
Validate `data` against the rules and returns `true` if validation succeeds, otherwise `false`.

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

