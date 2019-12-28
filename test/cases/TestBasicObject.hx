package cases;

import utest.Assert;
import anonstruct.AnonStruct;
import utest.Test;

class TestBasicObject extends Test {
    
    function testSimpleObject() {
        
        var anon = new AnonStruct();

        anon.valueString('first_name')
            .refuseEmpty()
            .refuseEmpty();

        anon.valueString('last_name')
            .refuseEmpty()
            .refuseEmpty()
            .minChar(4);

        anon.valueInt('age')
            .refuseNull()
            .greaterOrEqualThan(18)
            .lessOrEqualThan(100);


        Assert.isTrue(
            anon.pass(
                {
                    first_name : "John",
                    last_name : "Smith",
                    age : 52
                }
            )
        );

        Assert.isTrue(
            anon.pass(
                {
                    first_name : "John",
                    last_name : "Smith",
                    other_things : null,
                    age : 52
                }
            )
        );

        Assert.isFalse(
            anon.pass(
                {
                    first_name : "John",
                    last_name : "Doe",
                    age : 52
                }
            )
        );

        Assert.isFalse(
            anon.pass(
                {
                    last_name : "Smith",
                    age : 52
                }
            )
        );

        Assert.isFalse(
            anon.pass(
                {
                    first_name : "John",
                    last_name : "Smith",
                    age : 17
                }
            )
        );

    }

    function testComplexObject() {

        var validateAddress = new AnonStruct();
        
        validateAddress.valueString('country')
            .setAllowedOptions(
                [
                    'Brazil',
                    'Chile',
                    'Argentina'
                ], false
            );
        
        validateAddress.valueString('city')
            .allowNull()
            .allowEmpty();

        validateAddress.valueString('state')
            .allowNull()
            .allowEmpty()
            .minChar(2)
            .maxChar(3);

        var validatePerson = new AnonStruct();

        validatePerson.valueString('first_name')
            .refuseEmpty()
            .refuseEmpty();

        validatePerson.valueString('last_name')
            .refuseEmpty()
            .refuseEmpty()
            .minChar(4);

        validatePerson.valueInt('age')
            .refuseNull()
            .greaterOrEqualThan(18)
            .lessOrEqualThan(100);

        validatePerson.valueObject('address')
            .allowNull()
            .setStruct(validateAddress);

        
        Assert.isTrue(
            validatePerson.pass(
                {
                    first_name : "John",
                    last_name : "Smith",
                    age : 52,
                    address : {
                        country : "Brazil",
                        state : "SP",
                        city : "São Paulo"
                    }
                }
            )
        );

        Assert.isTrue(
            validatePerson.pass(
                {
                    first_name : "John",
                    last_name : "Smith",
                    age : 52,
                    address : {
                        country : "brazil"
                    }
                }
            )
        );

        Assert.isTrue(
            validatePerson.pass(
                {
                    first_name : "John",
                    last_name : "Smith",
                    age : 52
                }
            )
        );

        Assert.isFalse(
            validatePerson.pass(
                {
                    first_name : "John",
                    last_name : "Smith",
                    age : 52,
                    address : {
                        country : "Brazil",
                        state : "LONG STATE"
                    }
                }
            )
        );

        Assert.isFalse(
            validatePerson.pass(
                {
                    first_name : "John",
                    last_name : "Smith",
                    age : 52,
                    address : {
                        country : "Wrong Country",
                        state : "SP",
                        city : "São Paulo"
                    }
                }
            )
        );
        
    }

}