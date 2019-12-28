package cases;

import anonstruct.AnonStruct;
import utest.Assert;
import utest.Test;

@:access(anonstruct.AnonPropInt)
class TestBasicInt extends Test {

    function testIsInt() {
        var anon = new AnonStruct().setInt();
        
        Assert.isTrue(anon.validate_isInt(0));
        
        Assert.isFalse(anon.validate_isInt(''));
        Assert.isFalse(anon.validate_isInt(null));
        Assert.isFalse(anon.validate_isInt(1.1));
        Assert.isFalse(anon.validate_isInt([]));
        Assert.isFalse(anon.validate_isInt({}));
        Assert.isFalse(anon.validate_isInt(true));
        Assert.isFalse(anon.validate_isInt(AnonStruct));
    }

    function testAllowedNull() {
        var anon = new AnonStruct().setInt();
        
        Assert.isTrue(anon.validate_allowedNull(null, true));
        Assert.isTrue(anon.validate_allowedNull(1, true));
        Assert.isTrue(anon.validate_allowedNull(1, false));

        Assert.isFalse(anon.validate_allowedNull(null, false));
    }

    function testMin() {
        var anon = new AnonStruct().setInt();
        
        Assert.isTrue(anon.validate_min(1, null, null));
        Assert.isTrue(anon.validate_min(1, 0, null));
        Assert.isTrue(anon.validate_min(1, 0, false));
        Assert.isTrue(anon.validate_min(1, 1, true));

        Assert.isFalse(anon.validate_min(2, 2, false));
        Assert.isFalse(anon.validate_min(1, 2, false));
        Assert.isFalse(anon.validate_min(1, 2, true));
    }

    function testMax() {
        var anon = new AnonStruct().setInt();
        
        Assert.isTrue(anon.validate_max(0, null, null));
        Assert.isTrue(anon.validate_max(0, 1, null));
        Assert.isTrue(anon.validate_max(0, 1, false));
        Assert.isTrue(anon.validate_max(0, 0, true));

        Assert.isFalse(anon.validate_max(2, 2, false));
        Assert.isFalse(anon.validate_max(2, 1, false));
        Assert.isFalse(anon.validate_max(2, 1, true));
    }

    function testStruct() {
        Assert.raises(new AnonStruct().setInt().validate.bind(''));
        Assert.raises(new AnonStruct().setInt().refuseNull().validate.bind(null));
        Assert.raises(new AnonStruct().setInt().greaterThan(1).validate.bind(1));
        Assert.raises(new AnonStruct().setInt().greaterOrEqualThan(1).validate.bind(0));
        Assert.raises(new AnonStruct().setInt().lessThan(0).validate.bind(0));
        Assert.raises(new AnonStruct().setInt().lessOrEqualThan(0).validate.bind(1));
        Assert.raises(new AnonStruct().setInt().addValidation(
            function(value:Int):Void if (value == 0) throw "Error"
        ).validate.bind(0));
    }
}