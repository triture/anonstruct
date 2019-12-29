package cases;

import utest.Assert;
import utest.Test;
import anonstruct.AnonStruct;

@:access(anonstruct.AnonPropString)
class TestBasicString extends Test {

    function testIsString() {
        var anon = new AnonStruct().valueString();
        
        Assert.isTrue(anon.validate_isString(''));
        Assert.isTrue(anon.validate_isString(""));

        Assert.isFalse(anon.validate_isString(null));
        Assert.isFalse(anon.validate_isString(1));
        Assert.isFalse(anon.validate_isString(1.1));
        Assert.isFalse(anon.validate_isString([]));
        Assert.isFalse(anon.validate_isString({}));
        Assert.isFalse(anon.validate_isString(true));
        Assert.isFalse(anon.validate_isString(AnonStruct));
    }

    function testAllowedNull() {
        var anon = new AnonStruct().valueString();
        
        Assert.isTrue(anon.validate_allowedNull(null, true));
        Assert.isTrue(anon.validate_allowedNull('', true));
        Assert.isTrue(anon.validate_allowedNull('', false));

        Assert.isFalse(anon.validate_allowedNull(null, false));
    }

    function testAllowedEmpty() {
        var anon = new AnonStruct().valueString();

        Assert.isTrue(anon.validate_allowedEmpty('', true));
        Assert.isTrue(anon.validate_allowedEmpty('  ', true));
        Assert.isTrue(anon.validate_allowedEmpty('xx', true));
        Assert.isTrue(anon.validate_allowedEmpty('xx', false));

        Assert.isFalse(anon.validate_allowedEmpty('', false));
        Assert.isFalse(anon.validate_allowedEmpty(' ', false));
        Assert.isFalse(anon.validate_allowedEmpty('\n', false));
        Assert.isFalse(anon.validate_allowedEmpty('\n \n', false));
    }

    function testMinChar() {
        var anon = new AnonStruct().valueString();

        Assert.isTrue(anon.validate_minChar('', null));
        Assert.isTrue(anon.validate_minChar('', 0));
        Assert.isTrue(anon.validate_minChar('', -1));
        Assert.isTrue(anon.validate_minChar('a', 1));
        Assert.isTrue(anon.validate_minChar('a', -1));

        Assert.isFalse(anon.validate_minChar('a', 2));
    }

    function testMaxChar() {
        var anon = new AnonStruct().valueString();

        Assert.isTrue(anon.validate_maxChar('', null));
        Assert.isTrue(anon.validate_maxChar('', 0));
        Assert.isTrue(anon.validate_maxChar('', -1));
        Assert.isTrue(anon.validate_maxChar('a', 1));
        Assert.isTrue(anon.validate_maxChar('a', -1));

        Assert.isFalse(anon.validate_maxChar('abc', 2));
    }

    function testStartsWith() {
        var anon = new AnonStruct().valueString();

        Assert.isTrue(anon.validate_startsWith('', null));
        Assert.isTrue(anon.validate_startsWith('', ''));
        Assert.isTrue(anon.validate_startsWith('abcd', ''));
        Assert.isTrue(anon.validate_startsWith('abcd', 'ab'));
        Assert.isTrue(anon.validate_startsWith('abcd', 'abcd'));

        Assert.isFalse(anon.validate_startsWith('abcd', 'abx'));
    }

    function testEndsWith() {
        var anon = new AnonStruct().valueString();

        Assert.isTrue(anon.validate_endsWith('', null));
        Assert.isTrue(anon.validate_endsWith('', ''));
        Assert.isTrue(anon.validate_endsWith('abcd', ''));
        Assert.isTrue(anon.validate_endsWith('abcd', 'cd'));
        Assert.isTrue(anon.validate_endsWith('abcd', 'abcd'));

        Assert.isFalse(anon.validate_endsWith('abcd', 'xcd'));
    }

    function testAllowedChars() {
        var anon = new AnonStruct().valueString();

        Assert.equals(anon.validate_allowedChars('abc', null), '');
        Assert.equals(anon.validate_allowedChars('abc', ''), '');
        Assert.equals(anon.validate_allowedChars('abc', 'abc'), '');
        Assert.equals(anon.validate_allowedChars('abc', 'abcde'), '');
        Assert.equals(anon.validate_allowedChars('abc ', 'abcde'), ' ');
        Assert.equals(anon.validate_allowedChars('abc x', 'abcde'), ' ');
        Assert.equals(anon.validate_allowedChars('abc x', 'abcde '), 'x');
    }

    function testAllowedOptions() {
        var anon = new AnonStruct().valueString();

        Assert.isTrue(anon.validate_allowedOptions('a', null, null));
        Assert.isTrue(anon.validate_allowedOptions('a', [], null));
        Assert.isTrue(anon.validate_allowedOptions('a', ['a', 'b', 'c'], null));
        Assert.isTrue(anon.validate_allowedOptions('a', ['a', 'b', 'c'], false));
        Assert.isTrue(anon.validate_allowedOptions('A', ['a', 'b', 'c'], false));

        Assert.isFalse(anon.validate_allowedOptions('A', ['a', 'b', 'c'], true));
        Assert.isFalse(anon.validate_allowedOptions('a', ['A', 'b', 'c'], true));
        Assert.isFalse(anon.validate_allowedOptions('x', ['A', 'b', 'c'], false));
        Assert.isFalse(anon.validate_allowedOptions('X', ['A', 'b', 'c'], true));
    }

    function testStruct() {
        Assert.raises(new AnonStruct().valueString().validate.bind(0));
        Assert.raises(new AnonStruct().valueString().refuseNull().validate.bind(null));
        Assert.raises(new AnonStruct().valueString().refuseEmpty().validate.bind(''));
        Assert.raises(new AnonStruct().valueString().minChar(3).validate.bind('ab'));
        Assert.raises(new AnonStruct().valueString().maxChar(2).validate.bind('abc'));
        Assert.raises(new AnonStruct().valueString().startsWith('abx').validate.bind('abcde'));
        Assert.raises(new AnonStruct().valueString().endsWith('xde').validate.bind('abcde'));
        Assert.raises(new AnonStruct().valueString().allowChars('abc').validate.bind('abcx'));
        Assert.raises(new AnonStruct().valueString().setAllowedOptions(['a', 'b']).validate.bind('c'));
        
        Assert.raises(
            new AnonStruct().valueString()
            .addValidation(
                function(value:String):Void if (value == "error") throw "Error"
            ).validate.bind("error")
        );
    }
}