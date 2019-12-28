package cases;

import anonstruct.AnonStruct;
import utest.Assert;
import utest.Test;

@:access(anonstruct.AnonPropFloat)
class TestBasicFloat extends Test {

    function testIsInt() {
        var anon = new AnonStruct().setFloat();
        
        Assert.isTrue(anon.validate_isFloat(0.1));
        Assert.isTrue(anon.validate_isFloat(1));
        
        Assert.isFalse(anon.validate_isFloat(''));
        Assert.isFalse(anon.validate_isFloat(null));
        Assert.isFalse(anon.validate_isFloat([]));
        Assert.isFalse(anon.validate_isFloat({}));
        Assert.isFalse(anon.validate_isFloat(true));
        Assert.isFalse(anon.validate_isFloat(AnonStruct));
    }

    function testAllowedNull() {
        var anon = new AnonStruct().setFloat();
        
        Assert.isTrue(anon.validate_allowedNull(null, true));
        Assert.isTrue(anon.validate_allowedNull(1.1, true));
        Assert.isTrue(anon.validate_allowedNull(1.1, false));

        Assert.isFalse(anon.validate_allowedNull(null, false));
    }

    function testMin() {
        var anon = new AnonStruct().setFloat();
        
        Assert.isTrue(anon.validate_min(1.1, null, null));
        Assert.isTrue(anon.validate_min(1.1, 0, null));
        Assert.isTrue(anon.validate_min(1.1, 0, false));
        Assert.isTrue(anon.validate_min(1.1, 1.1, true));

        Assert.isFalse(anon.validate_min(2.1, 2.1, false));
        Assert.isFalse(anon.validate_min(1.1, 2.1, false));
        Assert.isFalse(anon.validate_min(1.1, 2.1, true));
    }

    function testMax() {
        var anon = new AnonStruct().setFloat();
        
        Assert.isTrue(anon.validate_max(0.1, null, null));
        Assert.isTrue(anon.validate_max(0.1, 1.1, null));
        Assert.isTrue(anon.validate_max(0.1, 1.1, false));
        Assert.isTrue(anon.validate_max(0.1, 0.1, true));

        Assert.isFalse(anon.validate_max(2.1, 2.1, false));
        Assert.isFalse(anon.validate_max(2.1, 1.1, false));
        Assert.isFalse(anon.validate_max(2.1, 1.1, true));
    }

    function testStruct() {
        Assert.raises(new AnonStruct().setFloat().validate.bind(''));
        Assert.raises(new AnonStruct().setFloat().refuseNull().validate.bind(null));
        Assert.raises(new AnonStruct().setFloat().greaterThan(1.1).validate.bind(1.1));
        Assert.raises(new AnonStruct().setFloat().greaterOrEqualThan(1.1).validate.bind(0.1));
        Assert.raises(new AnonStruct().setFloat().lessThan(0.1).validate.bind(0.1));
        Assert.raises(new AnonStruct().setFloat().lessOrEqualThan(0.1).validate.bind(1.1));
        Assert.raises(new AnonStruct().setFloat().addValidation(
            function(value:Float):Void if (value == 0.1) throw "Error"
        ).validate.bind(0.1));
    }
}