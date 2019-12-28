package cases;

import datetime.DateTime;
import anonstruct.AnonStruct;
import utest.Assert;
import utest.Test;

@:access(anonstruct.AnonPropDate)
class TestBasicDate extends Test {

    function testIsInt() {
        var anon = new AnonStruct().setDate();

        Assert.isTrue(anon.validate_isDateTime(DateTime.fromString('2020-01-01 00:00:00')));
        Assert.isTrue(anon.validate_isDateTime('2020-01-01 00:00:00'));
        Assert.isTrue(anon.validate_isDateTime('2020-01-01'));
        Assert.isTrue(anon.validate_isDateTime(63713433600)); // same as '2020-01-01 00:00:00'
        Assert.isTrue(anon.validate_isDateTime(Date.now()));
        
        Assert.isFalse(anon.validate_isDateTime('xxx'));
        Assert.isFalse(anon.validate_isDateTime(''));
        Assert.isFalse(anon.validate_isDateTime(null));
        Assert.isFalse(anon.validate_isDateTime([]));
        Assert.isFalse(anon.validate_isDateTime({}));
        Assert.isFalse(anon.validate_isDateTime(true));
        Assert.isFalse(anon.validate_isDateTime(AnonStruct));
    }

    function testAllowedNull() {
        var anon = new AnonStruct().setDate();
        
        Assert.isTrue(anon.validate_allowedNull(null, true));
        Assert.isTrue(anon.validate_allowedNull('2020-01-01 00:00:00', true));
        Assert.isTrue(anon.validate_allowedNull('2020-01-01 00:00:00', false));

        Assert.isFalse(anon.validate_allowedNull(null, false));
    }

    function testMin() {
        var anon = new AnonStruct().setDate();
        
        Assert.isTrue(anon.validate_min('2020-01-01 00:00:00', null, null));
        Assert.isTrue(anon.validate_min('2020-01-01 00:00:01', '2020-01-01 00:00:00', null));
        Assert.isTrue(anon.validate_min('2020-01-01 00:00:01', '2020-01-01 00:00:00', false));
        Assert.isTrue(anon.validate_min('2020-01-01 00:00:00', '2020-01-01 00:00:00', true));

        Assert.isFalse(anon.validate_min('2020-01-01 00:00:00', '2020-01-01 00:00:00', false));
        Assert.isFalse(anon.validate_min('2020-01-01 00:00:00', '2020-01-01 00:00:01', false));
        Assert.isFalse(anon.validate_min('2020-01-01 00:00:00', '2020-01-01 00:00:01', true));
    }

    function testMax() {
        var anon = new AnonStruct().setDate();
        
        Assert.isTrue(anon.validate_max('2020-01-01 00:00:00', null, null));
        Assert.isTrue(anon.validate_max('2020-01-01 00:00:00', '2020-01-01 00:00:01', null));
        Assert.isTrue(anon.validate_max('2020-01-01 00:00:00', '2020-01-01 00:00:01', false));
        Assert.isTrue(anon.validate_max('2020-01-01 00:00:00', '2020-01-01 00:00:00', true));

        Assert.isFalse(anon.validate_max('2020-01-01 00:00:00', '2020-01-01 00:00:00', false));
        Assert.isFalse(anon.validate_max('2020-01-01 00:00:01', '2020-01-01 00:00:00', false));
        Assert.isFalse(anon.validate_max('2020-01-01 00:00:01', '2020-01-01 00:00:00', true));
    }

    function testStruct() {
        Assert.raises(new AnonStruct().setDate().validate.bind('abcd'));
        Assert.raises(new AnonStruct().setDate().validate.bind('0'));
        Assert.raises(new AnonStruct().setDate().refuseNull().validate.bind(null));
        Assert.raises(new AnonStruct().setDate().greaterThan('2020-01-01 00:00:00').validate.bind('2020-01-01 00:00:00'));
        Assert.raises(new AnonStruct().setDate().greaterOrEqualThan('2020-01-01 00:00:01').validate.bind('2020-01-01 00:00:00'));
        Assert.raises(new AnonStruct().setDate().lessThan('2020-01-01 00:00:00').validate.bind('2020-01-01 00:00:00'));
        Assert.raises(new AnonStruct().setDate().lessOrEqualThan('2020-01-01 00:00:01').validate.bind('2020-01-01 00:00:00'));
        Assert.raises(new AnonStruct().setDate().addValidation(
            function(value:DateTime):Void if (value == '2020-01-01 00:00:00') throw "Error"
        ).validate.bind(DateTime.fromString('2020-01-01 00:00:00')));
    }
}