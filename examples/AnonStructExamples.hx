package ;

import anonstruct.AnonStruct;

class AnonStructExamples {
    
    static public function main() {
        
        // You can check basic types like strings and ints values

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


        // Or check complex objects
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


        // AnonStruct also check children objects
        validator.propertyObject('child')
            .allowNull()
            .setStruct(validator);
        
        trace(validator.getErrors({a:'', b:10}));                                  // []
        trace(validator.getErrors({a:'', b:10, child:null}));                      // []
        trace(validator.getErrors({a:'', b:10, child:{a:'x', b:5}}));              // [AnonStructError:child.b: Value should be greater than or equal 10]
        trace(validator.getErrors({a:'', b:10, child:{b:20, child:{b:null}}}));    // [AnonStructError:child.child.b: Value cannot be null]


        // And Arrays
        validator.propertyArray('list')
            .allowNull()
            .setStruct(validator);

        trace(validator.getErrors({a:'', b:10}));                                  // []
        trace(validator.getErrors({b:10, list:[]}));                               // []
        trace(validator.getErrors({b:10, list:[{b:10}, {b:0}]}));                  // [AnonStructError:list.[1].b: Value should be greater than or equal 10]


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