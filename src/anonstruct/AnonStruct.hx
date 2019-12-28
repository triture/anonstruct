package anonstruct;

import datetime.DateTime;
import haxe.ds.StringMap;

class AnonStruct {

    private var _allowNull:Bool = false;

    private var propMap:StringMap<AnonProp>;
    private var currentStruct:Null<AnonProp> = null;

    private var _validateFunc:Array<Dynamic->Void> = [];

    public function new() {
        this.propMap = new StringMap<AnonProp>();
    }

    public function addValidation(func:Dynamic->Void):Void {
        this._validateFunc.push(func);
    }

    public function setBool():AnonPropBool {
        var value:AnonPropBool = new AnonPropBool();
        this.currentStruct = value;
        return value;
    }

    public function setString():AnonPropString {
        var value:AnonPropString = new AnonPropString();
        this.currentStruct = value;
        return value;
    }

    public function setInt():AnonPropInt {
        var value:AnonPropInt = new AnonPropInt();
        this.currentStruct = value;
        return value;
    }

    public function setFloat():AnonPropFloat {
        var value:AnonPropFloat = new AnonPropFloat();
        this.currentStruct = value;
        return value;
    }

    public function setArray():AnonPropArray {
        var value:AnonPropArray = new AnonPropArray();
        this.currentStruct = value;
        return value;
    }

    public function setDate():AnonPropDate {
        var value:AnonPropDate = new AnonPropDate();
        this.currentStruct = value;
        return value;
    }


    public function refuseNull():Void this._allowNull = false;
    public function allowNull():Void this._allowNull = true;


    public function valueInt(prop:String):AnonPropInt {
        var propInt:AnonPropInt = new AnonPropInt();
        this.propMap.set(prop, propInt);
        return propInt;
    }

    public function valueFloat(prop:String):AnonPropFloat {
        var propFloat:AnonPropFloat = new AnonPropFloat();
        this.propMap.set(prop, propFloat);
        return propFloat;
    }

    public function valueString(prop:String):AnonPropString {
        var propString:AnonPropString = new AnonPropString();
        this.propMap.set(prop, propString);
        return propString;
    }

    public function valueObject(prop:String):AnonPropObject {
        var propObject:AnonPropObject = new AnonPropObject();
        this.propMap.set(prop, propObject);
        return propObject;
    }

    public function valueDate(prop:String):AnonPropDate {
        var propDate:AnonPropDate = new AnonPropDate();
        this.propMap.set(prop, propDate);
        return propDate;
    }

    public function valueBool(prop:String):AnonPropBool {
        var propBool:AnonPropBool = new AnonPropBool();
        this.propMap.set(prop, propBool);
        return propBool;
    }

    public function validateAll(data:Dynamic):Void {
        var errors:Array<AnonError> = [];

        if (data == null && !this._allowNull) {
            errors.push(new AnonError("", "", AnonMessages.NULL_VALUE_NOT_ALLOWED));
        } else {

            if (this.currentStruct != null) this.currentStruct.validate(data);

            for (key in this.propMap.keys()) {

                var value:Dynamic = Reflect.getProperty(data, key);

                try {
                    this.propMap.get(key).validate(value);
                } catch (e:AnonError) {
                    errors.push(e);
                } catch (e:Dynamic) {

                    if (Std.is(e, Array)) {

                        var erroList:Array<AnonError> = cast e;
                        for (item in erroList) errors.push(item);

                    } else {
                        errors.push(new AnonError(this.propMap.get(key).propLabel, key, Std.string(e)));
                    }
                }

            }

            for (func in this._validateFunc) {
                try {
                    func(data);
                } catch (e:Dynamic) {
                    errors.push(new AnonError("", "", Std.string(e)));
                }
            }
        }

        if (errors.length > 0) throw(errors);

    }

    public function validate(data:Dynamic):Void {

        if (data == null && !this._allowNull) {
            throw new AnonError("", "", AnonMessages.NULL_VALUE_NOT_ALLOWED);
        } else {

            if (this.currentStruct != null) this.currentStruct.validate(data);

            for (key in this.propMap.keys()) {

                var value:Dynamic = Reflect.getProperty(data, key);

                try {
                    this.propMap.get(key).validate(value);
                } catch (e:AnonError) {
                    throw e;
                } catch (e:Dynamic) {
                    throw new AnonError(this.propMap.get(key).propLabel, key, Std.string(e));
                }

            }

            for (func in this._validateFunc) {
                try {
                    func(data);
                } catch (e:Dynamic) {
                    throw new AnonError("", "", Std.string(e));
                }
            }
        }

    }
}

private class AnonProp {

    private var _validateFunc:Array<Dynamic> = [];
    public var propLabel:String = "";

    public function new() {}

    public function validate(value:Dynamic):Void {}

    private function validateFuncs(val:Dynamic):Void {
        for (func in this._validateFunc) func(val);
    }
}

private class AnonPropDate extends AnonProp {

    private var _allowNull:Bool = false;

    private var _minDate:Null<DateTime>;
    private var _maxDate:Null<DateTime>;

    private var _minEqual:Bool;
    private var _maxEqual:Bool;

    public function new() {
        super();
    }

    public function addErrorLabel(label:String):AnonPropDate {
        this.propLabel = label;
        return this;
    }

    public function addValidation(func:DateTime->Void):AnonPropDate {
        this._validateFunc.push(func);
        return this;
    }

    public function refuseNull():AnonPropDate {
        this._allowNull = false;
        return this;
    }

    public function allowNull():AnonPropDate {
        this._allowNull = true;
        return this;
    }

    public function greaterOrEqualThan(date:Null<DateTime>):AnonPropDate {
        this._minDate = date;
        this._minEqual = true;
        return this;
    }

    public function greaterThan(date:Null<DateTime>):AnonPropDate {
        this._minDate = date;
        this._minEqual = false;
        return this;
    }

    public function lessThan(date:Null<DateTime>):AnonPropDate {
        this._minDate = date;
        this._maxEqual = false;
        return this;
    }

    public function lessOrEqualThan(date:Null<DateTime>):AnonPropDate {
        this._minDate = date;
        this._maxEqual = true;
        return this;
    }

    override public function validate(value:Dynamic):Void {

        if (value == null && !this._allowNull) {
            throw AnonMessages.NULL_VALUE_NOT_ALLOWED;
        } else if (value != null) {

            var date:Null<DateTime> = null;

            if (Std.is(value, String)) {
                // check if is string date format
                try {
                    date = DateTime.fromString(value);
                } catch (e:Dynamic) {
                    throw AnonMessages.DATE_VALUE_INVALID;
                }
            } else if (Std.is(value, Date)) {

                date = DateTime.fromDate(cast(value, Date));

                if (this._minDate != null && ((this._minEqual && date < this._minDate) || (!this._minEqual && date <= this._minDate)))
                    throw (
                        this._minEqual
                        ? AnonMessages.DATE_VALUE_MUST_BE_BEFORE_OR_EQUAL
                        : AnonMessages.DATE_VALUE_MUST_BE_BEFORE
                    ).split('?VALUE0').join(this._minDate.toString());

                if (this._maxDate != null && ((this._maxEqual && date > this._maxDate) || (!this._maxEqual && date >= this._maxDate)))
                    throw (
                        this._maxEqual
                        ? AnonMessages.DATE_VALUE_MUST_BE_AFTER_OR_EQUAL
                        : AnonMessages.DATE_VALUE_MUST_BE_AFTER
                    ).split('?VALUE0').join(this._maxDate.toString());

                this.validateFuncs(date);

            } else throw AnonMessages.DATE_VALUE_INVALID;
        }
    }

}

private class AnonPropArray extends AnonProp {

    private var _maxLen:Null<Int> = null;
    private var _minLen:Null<Int> = null;

    private var _allowNull:Bool = false;
    private var _childStruct:Null<AnonStruct> = null;

    public function new() {
        super();
    }

    public function addErrorLabel(label:String):AnonPropArray {
        this.propLabel = label;
        return this;
    }

    public function setStruct(structure:AnonStruct):AnonPropArray {
        this._childStruct = structure;
        return this;
    }

    public function refuseNull():AnonPropArray {
        this._allowNull = false;
        return this;
    }

    public function allowNull():AnonPropArray {
        this._allowNull = true;
        return this;
    }

    override public function validate(value:Dynamic):Void {

        if (value == null && !this._allowNull) {
            throw AnonMessages.NULL_VALUE_NOT_ALLOWED;
        } else if (value != null) {
            if (!Std.is(value, Array)) {
                throw AnonMessages.ARRAY_VALUE_INVALID;
            } else {

                var val:Array<Dynamic> = cast value;

                if (this._minLen != null && val.length < this._minLen)
                    throw (
                        this._minLen <= 1
                        ? AnonMessages.ARRAY_VALUE_MIN_ITEM_SINGLE
                        : AnonMessages.ARRAY_VALUE_MIN_ITEM_PLURAL
                    ).split('?VALUE0').join(Std.string(this._minLen));

                if (this._maxLen != null && val.length > this._maxLen)
                    throw (
                        this._maxLen <= 1
                        ? AnonMessages.ARRAY_VALUE_MAX_ITEM_SINGLE
                        : AnonMessages.ARRAY_VALUE_MAX_ITEM_PLURAL
                    ).split('?VALUE0').join(Std.string(this._maxLen));

                if (this._childStruct != null) {

                    for (item in val) this._childStruct.validate(item);

                }
            }
        }

    }

}

private class AnonPropObject extends AnonProp {

    private var _allowNull:Bool = false;
    private var _struct:Null<AnonStruct> = null;

    public function new() {
        super();
    }

    public function addErrorLabel(label:String):AnonPropObject {
        this.propLabel = label;
        return this;
    }

    public function addValidation(func:Dynamic->Void):AnonPropObject {
        this._validateFunc.push(func);
        return this;
    }

    public function refuseNull():AnonPropObject {
        this._allowNull = false;
        return this;
    }

    public function allowNull():AnonPropObject {
        this._allowNull = true;
        return this;
    }

    public function setStruct(structure:AnonStruct):AnonPropObject {
        this._struct = structure;
        return this;
    }

    override public function validate(value:Dynamic):Void {

        if (value == null && !this._allowNull) {
            throw AnonMessages.NULL_VALUE_NOT_ALLOWED;
        } else if (value != null) {

            if (this._struct != null) this._struct.validate(value);

            this.validateFuncs(value);

        }

    }

}

private class AnonPropString extends AnonProp {

    private var _allowNull:Bool = false;
    private var _allowEmpty:Bool = false;

    private var _maxChar:Null<Int> = null;
    private var _minChar:Null<Int> = null;
    private var _startsWith:Null<String> = null;
    private var _endsWidth:Null<String> = null;

    private var _allowedChars:Null<String> = null;

    private var _allowedOptions:Null<Array<String>> = null;
    private var _allowedOptionsMatchCase:Bool = false;

    public function new() {
        super();
    }

    public function setAllowedOptions(values:Null<Array<String>>, matchCase:Bool = true):AnonPropString {
        this._allowedOptions = values;
        this._allowedOptionsMatchCase = matchCase;
        return this;
    }

    public function addErrorLabel(label:String):AnonPropString {
        this.propLabel = label;
        return this;
    }

    public function addValidation(func:String->Void):AnonPropString {
        this._validateFunc.push(func);
        return this;
    }

    public function startsWith(value:Null<String>):AnonPropString {
        this._startsWith = value;
        return this;
    }

    public function endsWith(value:Null<String>):AnonPropString {
        this._endsWidth = value;
        return this;
    }

    public function refuseNull():AnonPropString {
        this._allowNull = false;
        return this;
    }

    public function allowNull():AnonPropString {
        this._allowNull = true;
        return this;
    }

    public function refuseEmpty():AnonPropString {
        this._allowEmpty = false;
        return this;
    }

    public function allowEmpty():AnonPropString {
        this._allowEmpty = true;
        return this;
    }

    public function maxChar(chars:Null<Int>):AnonPropString {
        this._maxChar = chars;
        return this;
    }

    public function minChar(chars:Null<Int>):AnonPropString {
        this._minChar = chars;
        return this;
    }

    public function allowChars(chars:Null<String>):AnonPropString {
        this._allowedChars = chars;
        return this;
    }

    inline private function validate_allowedNull(value:Dynamic, allowNull:Bool):Bool return (value != null || (value == null && allowNull));
    inline private function validate_isString(value:Dynamic):Bool return (Std.is(value, String));
    inline private function validate_allowedEmpty(value:String, allowEmpty:Bool):Bool {
        var len:Int = StringTools.trim(value).length;
        return (len > 0 || (len == 0 && allowEmpty));
    }
    inline private function validate_minChar(value:String, minChar:Null<Int>):Bool return (minChar == null || minChar < 0 || value.length >= minChar);
    inline private function validate_maxChar(value:String, maxChar:Null<Int>):Bool return (maxChar == null || maxChar < 0 || value.length <= maxChar);
    inline private function validate_startsWith(value:String, startsWith:Null<String>):Bool return (startsWith == null || startsWith.length == 0 || StringTools.startsWith(value, startsWith));
    inline private function validate_endsWith(value:String, endsWith:Null<String>):Bool return (endsWith == null || endsWith.length == 0 || StringTools.endsWith(value, endsWith));
    inline private function validate_allowedChars(value:String, allowedChars:Null<String>):String {
        var result:String = '';
        if (allowedChars != null && allowedChars.length > 0) {
            for (i in 0 ... value.length) 
                if (allowedChars.indexOf(value.charAt(i)) == -1) {
                    result = value.charAt(i);
                    break;
                }
        }
        return result;
    }
    private function validate_allowedOptions(value:String, options:Null<Array<String>>, matchCase:Null<Bool>):Bool {
        if (options == null || options.length == 0) return true;
        else if (matchCase) return (options.indexOf(value) > -1);
        else {
            for (item in options) if (item.toLowerCase() == value.toLowerCase()) return true;
            return false;
        }
    }

    override public function validate(value:Dynamic):Void {
        if (!this.validate_allowedNull(value, this._allowNull)) {
            throw AnonMessages.NULL_VALUE_NOT_ALLOWED;
        } else if (value != null) {
            if (!this.validate_isString(value)) {
                throw AnonMessages.STRING_VALUE_INVALID;
            } else {

                var val:String = cast value;

                if (!this.validate_allowedEmpty(val, _allowEmpty)) throw AnonMessages.STRING_VALUE_CANNOT_BE_EMPTY;

                if (!this.validate_minChar(val, this._minChar))
                    throw (
                        this._minChar <= 1
                        ? AnonMessages.STRING_VALUE_MIN_CHAR_SINGLE
                        : AnonMessages.STRING_VALUE_MIN_CHAR_PLURAL
                    ).split('?VALUE0').join(Std.string(this._minChar));

                if (!this.validate_maxChar(val, this._maxChar))
                    throw (
                        this._maxChar <= 1
                        ? AnonMessages.STRING_VALUE_MAX_CHAR_SINGLE
                        : AnonMessages.STRING_VALUE_MAX_CHAR_PLURAL
                    ).split('?VALUE0').join(Std.string(this._maxChar));

                if (!this.validate_startsWith(val, this._startsWith)) throw AnonMessages.STRING_VALUE_SHOULD_STARTS_WITH.split("?VALUE0").join(this._startsWith);
                if (!this.validate_endsWith(val, this._endsWidth)) throw AnonMessages.STRING_VALUE_SHOULD_ENDS_WITH.split("?VALUE0").join(this._endsWidth);
                
                var char:String = this.validate_allowedChars(val, this._allowedChars);
                if (char.length > 0) throw AnonMessages.STRING_VALUE_CHAR_NOT_ALLOWED.split("?VALUE0").join(char);

                if (!this.validate_allowedOptions(val, this._allowedOptions, this._allowedOptionsMatchCase))
                    throw AnonMessages.STRING_VALUE_OPTION_NOT_ALLOWED
                        .split('?VALUE0').join(val)
                        .split('?VALUE1').join(this._allowedOptions.join(', '));

                this.validateFuncs(val);
            }
        }
    }
}

private class AnonPropInt extends AnonProp {

    private var _allowNull:Bool = false;

    private var _max:Null<Int> = null;
    private var _min:Null<Int> = null;

    private var _maxEqual:Bool = false;
    private var _minEqual:Bool = false;

    public function new() {
        super();
    }

    public function addErrorLabel(label:String):AnonPropInt {
        this.propLabel = label;
        return this;
    }

    public function addValidation(func:Int->Void):AnonPropInt {
        this._validateFunc.push(func);
        return this;
    }

    public function refuseNull():AnonPropInt {
        this._allowNull = false;
        return this;
    }

    public function allowNull():AnonPropInt {
        this._allowNull = true;
        return this;
    }

    public function lessThan(maxValue:Null<Int>):AnonPropInt {
        this._max = maxValue;
        this._maxEqual = false;
        return this;
    }

    public function lessOrEqualThan(maxValue:Null<Int>):AnonPropInt {
        this._max = maxValue;
        this._maxEqual = true;
        return this;
    }

    public function greaterThan(minValue:Null<Int>):AnonPropInt {
        this._min = minValue;
        this._minEqual = false;
        return this;
    }

    public function greaterOrEqualThan(minValue:Null<Int>):AnonPropInt {
        this._min = minValue;
        this._minEqual = true;
        return this;
    }

    inline private function validate_allowedNull(value:Dynamic, allowNull:Bool):Bool return (value != null || (value == null && allowNull));
    inline private function validate_isInt(value:Dynamic):Bool return (Std.is(value, Int));
    inline private function validate_min(value:Int, min:Null<Int>, equal:Null<Bool>):Bool return ((min == null) || ((equal == null || !equal) && value > min) || (equal && value >= min));
    inline private function validate_max(value:Int, max:Null<Int>, equal:Null<Bool>):Bool return ((max == null) || ((equal == null || !equal) && value < max) || (equal && value <= max));

    override public function validate(value:Dynamic):Void {
        if (!this.validate_allowedNull(value, this._allowNull)) throw AnonMessages.NULL_VALUE_NOT_ALLOWED;
        else if (value != null) {
            if (!this.validate_isInt(value)) throw AnonMessages.INT_VALUE_INVALID;
            else {

                var val:Int = cast value;

                if (!this.validate_min(val, this._min, this._minEqual))
                    throw (
                        this._minEqual
                        ? AnonMessages.INT_VALUE_GREATER_OR_EQUAL_THAN
                        : AnonMessages.INT_VALUE_GREATER_THAN
                    ).split('?VALUE0').join(Std.string(this._min));

                if (!this.validate_max(val, this._max, this._maxEqual))
                    throw (
                        this._maxEqual
                        ? AnonMessages.INT_VALUE_LESS_OR_EQUAL_THAN
                        : AnonMessages.INT_VALUE_LESS_THAN
                    ).split('?VALUE0').join(Std.string(this._max));

                this.validateFuncs(val);
            }
        }
    }
}

private class AnonPropFloat extends AnonProp {

    private var _allowNull:Bool = false;

    private var _max:Null<Float> = null;
    private var _min:Null<Float> = null;

    private var _maxEqual:Bool = false;
    private var _minEqual:Bool = false;

    public function new() {
        super();
    }

    public function addErrorLabel(label:String):AnonPropFloat {
        this.propLabel = label;
        return this;
    }

    public function addValidation(func:Float->Void):AnonPropFloat {
        this._validateFunc.push(func);
        return this;
    }

    public function refuseNull():AnonPropFloat {
        this._allowNull = false;
        return this;
    }

    public function allowNull():AnonPropFloat {
        this._allowNull = true;
        return this;
    }

    public function lessThan(maxValue:Null<Float>):AnonPropFloat {
        this._max = maxValue;
        this._maxEqual = false;
        return this;
    }

    public function lessOrEqualThan(maxValue:Null<Float>):AnonPropFloat {
        this._max = maxValue;
        this._maxEqual = true;
        return this;
    }

    public function greaterThan(minValue:Null<Float>):AnonPropFloat {
        this._min = minValue;
        this._minEqual = false;
        return this;
    }

    public function greaterOrEqualThan(minValue:Null<Float>):AnonPropFloat {
        this._min = minValue;
        this._minEqual = true;
        return this;
    }

    inline private function validate_allowedNull(value:Dynamic, allowNull:Bool):Bool return (value != null || (value == null && allowNull));
    inline private function validate_isFloat(value:Dynamic):Bool return (Std.is(value, Float));
    inline private function validate_min(value:Float, min:Null<Float>, equal:Null<Bool>):Bool return ((min == null) || ((equal == null || !equal) && value > min) || (equal && value >= min));
    inline private function validate_max(value:Float, max:Null<Float>, equal:Null<Bool>):Bool return ((max == null) || ((equal == null || !equal) && value < max) || (equal && value <= max));

    override public function validate(value:Dynamic):Void {
        if (!this.validate_allowedNull(value, this._allowNull)) throw AnonMessages.NULL_VALUE_NOT_ALLOWED;
        else if (value != null) {
            if (!this.validate_isFloat(value)) throw AnonMessages.FLOAT_VALUE_INVALID;
            else {

                var val:Float = cast value;

                if (!this.validate_min(val, this._min, this._minEqual))
                    throw (
                        this._minEqual
                        ? AnonMessages.INT_VALUE_GREATER_OR_EQUAL_THAN
                        : AnonMessages.INT_VALUE_GREATER_THAN
                    ).split('?VALUE0').join(Std.string(this._min));

                if (!this.validate_max(val, this._max, this._maxEqual))
                    throw (
                        this._maxEqual
                        ? AnonMessages.INT_VALUE_LESS_OR_EQUAL_THAN
                        : AnonMessages.INT_VALUE_LESS_THAN
                    ).split('?VALUE0').join(Std.string(this._max));

                this.validateFuncs(val);
            }
        }

    }
}

private class AnonPropBool extends AnonProp {

    private var _allowNull:Bool = false;
    private var _expectedValue:Null<Bool>;

    public function new() {
        super();
    }

    public function addErrorLabel(label:String):AnonPropBool {
        this.propLabel = label;
        return this;
    }

    public function addValidation(func:Bool->Void):AnonPropBool {
        this._validateFunc.push(func);
        return this;
    }

    public function expectedValue(value:Bool):AnonPropBool {
        this._expectedValue = value;
        return this;
    }

    public function refuseNull():AnonPropBool {
        this._allowNull = false;
        return this;
    }

    public function allowNull():AnonPropBool {
        this._allowNull = true;
        return this;
    }

    inline private function validate_allowedNull(value:Dynamic, allowNull:Bool):Bool return (value != null || (value == null && allowNull));
    inline private function validate_isBool(value:Dynamic):Bool return (Std.is(value, Bool));
    inline private function validate_expected(value:Bool, expected:Null<Bool>):Bool return ((expected == null) || (expected != null && value == expected));

    override public function validate(value:Dynamic):Void {
        if (!this.validate_allowedNull(value, this._allowNull)) throw AnonMessages.NULL_VALUE_NOT_ALLOWED;
        else if (value != null) {
            if (!this.validate_isBool(value)) throw AnonMessages.BOOL_VALUE_INVALID;
            else {
                var val:Bool = cast value;

                if (!this.validate_expected(val, this._expectedValue)) {
                    throw AnonMessages.BOOL_VALUE_EXPECTED
                        .split('?VALUE0')
                        .join(this._expectedValue ? 'true' : 'false');
                }

                this.validateFuncs(val);
            }
        }
    }
}
