package cases;

import anonstruct.AnonStruct;
import utest.Assert;
import utest.Test;

@:access(anonstruct.AnonPropFunction)
class TestBasicFunction extends Test {

    function testIsFunction() {
        var anon = new AnonStruct().valueFunction();

        Assert.isTrue(anon.validate_isFunction(function() {}));
        Assert.isTrue(anon.validate_isFunction(function(data:Dynamic):Void {}));

        Assert.isFalse(anon.validate_isFunction({}));
        Assert.isFalse(anon.validate_isFunction({a:1}));
        Assert.isFalse(anon.validate_isFunction(Date.now()));
        Assert.isFalse(anon.validate_isFunction(''));
        Assert.isFalse(anon.validate_isFunction(null));
        Assert.isFalse(anon.validate_isFunction([]));
        Assert.isFalse(anon.validate_isFunction(1));
        Assert.isFalse(anon.validate_isFunction(1.1));
        Assert.isFalse(anon.validate_isFunction(AnonStruct));
    }

    function testAllowedNull() {
        var anon = new AnonStruct().valueFunction();
        
        Assert.isTrue(anon.validate_allowedNull(null, true));
        Assert.isTrue(anon.validate_allowedNull(function() {}, true));
        Assert.isTrue(anon.validate_allowedNull(function(data:Dynamic):Void {}, false));

        Assert.isFalse(anon.validate_allowedNull(null, false));
    }

    function testStruct() {
        Assert.raises(new AnonStruct().valueFunction().validate.bind(''));
        Assert.raises(new AnonStruct().valueFunction().refuseNull().validate.bind(null));
        Assert.raises(new AnonStruct().valueFunction().addValidation(
            function(func:Dynamic):Void {
                if (func(1, 1) == 2) throw "Error";
            }
        ).validate.bind(
                function(a:Int, b:Int):Int return a + b
            )
        );
    }

}