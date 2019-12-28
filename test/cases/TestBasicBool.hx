package cases;

import anonstruct.AnonStruct;
import utest.Assert;
import utest.Test;

@:access(anonstruct.AnonPropBool)
class TestBasicBool extends Test {

    function testIsBool() {
        var anon = new AnonStruct().setBool();
        
        Assert.isTrue(anon.validate_isBool(true));
        Assert.isTrue(anon.validate_isBool(false));
        
        Assert.isFalse(anon.validate_isBool(''));
        Assert.isFalse(anon.validate_isBool(null));
        Assert.isFalse(anon.validate_isBool([]));
        Assert.isFalse(anon.validate_isBool({}));
        Assert.isFalse(anon.validate_isBool(1));
        Assert.isFalse(anon.validate_isBool(1.1));
        Assert.isFalse(anon.validate_isBool(AnonStruct));
    }

    function testAllowedNull() {
        var anon = new AnonStruct().setBool();
        
        Assert.isTrue(anon.validate_allowedNull(null, true));
        Assert.isTrue(anon.validate_allowedNull(true, true));
        Assert.isTrue(anon.validate_allowedNull(true, false));

        Assert.isFalse(anon.validate_allowedNull(null, false));
    }

    function testExpected() {
        var anon = new AnonStruct().setBool();
        
        Assert.isTrue(anon.validate_expected(true, null));
        Assert.isTrue(anon.validate_expected(false, null));
        Assert.isTrue(anon.validate_expected(true, true));
        Assert.isTrue(anon.validate_expected(false, false));

        Assert.isFalse(anon.validate_expected(false, true));
        Assert.isFalse(anon.validate_expected(true, false));
    }

    function testStruct() {
        Assert.raises(new AnonStruct().setBool().validate.bind(0));
        Assert.raises(new AnonStruct().setBool().refuseNull().validate.bind(null));
        Assert.raises(new AnonStruct().setBool().expectedValue(true).validate.bind(false));
        Assert.raises(new AnonStruct().setBool().expectedValue(false).validate.bind(true));
        Assert.raises(new AnonStruct().setBool().addValidation(
            function(value:Bool):Void if (value) throw "Error"
        ).validate.bind(true));
    }
}