package cases;

import utest.Assert;
import anonstruct.AnonStruct;
import utest.Test;

@:access(anonstruct.AnonPropArray)
class TestBasicArray extends Test {

    function testIsArray() {
        var anon = new AnonStruct().valueArray();
        
        Assert.isTrue(anon.validate_isArray([]));

        Assert.isFalse(anon.validate_isArray(null));
        Assert.isFalse(anon.validate_isArray(1));
        Assert.isFalse(anon.validate_isArray(1.1));
        Assert.isFalse(anon.validate_isArray(''));
        Assert.isFalse(anon.validate_isArray({}));
        Assert.isFalse(anon.validate_isArray(true));
        Assert.isFalse(anon.validate_isArray(AnonStruct));
    }

    function testAllowedNull() {
        var anon = new AnonStruct().valueArray();
        
        Assert.isTrue(anon.validate_allowedNull(null, true));
        Assert.isTrue(anon.validate_allowedNull([], true));
        Assert.isTrue(anon.validate_allowedNull([], false));

        Assert.isFalse(anon.validate_allowedNull(null, false));
    }

    function testMinLen() {
        var anon = new AnonStruct().valueArray();

        Assert.isTrue(anon.validate_minLen([], null));
        Assert.isTrue(anon.validate_minLen([], 0));
        Assert.isTrue(anon.validate_minLen([], -1));
        Assert.isTrue(anon.validate_minLen([0], 1));
        Assert.isTrue(anon.validate_minLen([0], -1));

        Assert.isFalse(anon.validate_minLen([0], 2));
    }

    function testMaxLen() {
        var anon = new AnonStruct().valueArray();

        Assert.isTrue(anon.validate_maxLen([], null));
        Assert.isTrue(anon.validate_maxLen([], 0));
        Assert.isTrue(anon.validate_maxLen([], -1));
        Assert.isTrue(anon.validate_maxLen([0], 1));
        Assert.isTrue(anon.validate_maxLen([0], -1));

        Assert.isFalse(anon.validate_maxLen([0, 0], 1));
    }

    function testStruct() {
        Assert.raises(new AnonStruct().valueArray().validate.bind(0));
        Assert.raises(new AnonStruct().valueArray().refuseNull().validate.bind(null));
        Assert.raises(new AnonStruct().valueArray().minLen(3).validate.bind([0, 1]));
        Assert.raises(new AnonStruct().valueArray().maxLen(2).validate.bind([0, 1, 2]));
        
        Assert.raises(
            new AnonStruct().valueArray()
            .addValidation(
                function(value:Array<Dynamic>):Void if (value[0] == 0) throw "Error"
            ).validate.bind([0])
        );
    }

}