package cases;

import anonstruct.AnonStruct;
import utest.Assert;
import utest.Test;

@:access(anonstruct.AnonPropInt)
class TestBasicInt extends Test {

    function testIsInt() {
        var anon = new AnonStruct().valueInt();
        
        Assert.isTrue(anon.validate_isInt(0));
        
        Assert.isFalse(anon.validate_isInt(''));
        Assert.isFalse(anon.validate_isInt(null));
        Assert.isFalse(anon.validate_isInt(1.1));
        Assert.isFalse(anon.validate_isInt([]));
        Assert.isFalse(anon.validate_isInt({}));
        Assert.isFalse(anon.validate_isInt(true));
        Assert.isFalse(anon.validate_isInt(AnonStruct));
        Assert.isFalse(anon.validate_isInt(function():Void {}));
        Assert.isFalse(anon.validate_isInt(function(data:Dynamic):Void {}));
    }

    function testAllowedNull() {
        var anon = new AnonStruct().valueInt();
        
        Assert.isTrue(anon.validate_allowedNull(null, true));
        Assert.isTrue(anon.validate_allowedNull(1, true));
        Assert.isTrue(anon.validate_allowedNull(1, false));

        Assert.isFalse(anon.validate_allowedNull(null, false));
    }

    function testMin() {
        var anon = new AnonStruct().valueInt();
        
        Assert.isTrue(anon.validate_min(1, null, null));
        Assert.isTrue(anon.validate_min(1, 0, null));
        Assert.isTrue(anon.validate_min(1, 0, false));
        Assert.isTrue(anon.validate_min(1, 1, true));

        Assert.isFalse(anon.validate_min(2, 2, false));
        Assert.isFalse(anon.validate_min(1, 2, false));
        Assert.isFalse(anon.validate_min(1, 2, true));
    }

    function testMax() {
        var anon = new AnonStruct().valueInt();
        
        Assert.isTrue(anon.validate_max(0, null, null));
        Assert.isTrue(anon.validate_max(0, 1, null));
        Assert.isTrue(anon.validate_max(0, 1, false));
        Assert.isTrue(anon.validate_max(0, 0, true));

        Assert.isFalse(anon.validate_max(2, 2, false));
        Assert.isFalse(anon.validate_max(2, 1, false));
        Assert.isFalse(anon.validate_max(2, 1, true));
    }

    function testStruct() {
        Assert.raises(new AnonStruct().valueInt().validate.bind(''));
        Assert.raises(new AnonStruct().valueInt().refuseNull().validate.bind(null));
        Assert.raises(new AnonStruct().valueInt().greaterThan(1).validate.bind(1));
        Assert.raises(new AnonStruct().valueInt().greaterOrEqualThan(1).validate.bind(0));
        Assert.raises(new AnonStruct().valueInt().lessThan(0).validate.bind(0));
        Assert.raises(new AnonStruct().valueInt().lessOrEqualThan(0).validate.bind(1));
        Assert.raises(new AnonStruct().valueInt().addValidation(
            function(value:Int):Void if (value == 0) throw "Error"
        ).validate.bind(0));
    }
}