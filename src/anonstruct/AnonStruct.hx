package anonstruct;

import datetime.DateTime;
import haxe.ds.StringMap;

@:access(anonstruct.AnonProp)
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

    public function valueBool():AnonPropBool {
        var value:AnonPropBool = new AnonPropBool();
        this.currentStruct = value;
        return value;
    }

    public function valueString():AnonPropString {
        var value:AnonPropString = new AnonPropString();
        this.currentStruct = value;
        return value;
    }

    public function valueInt():AnonPropInt {
        var value:AnonPropInt = new AnonPropInt();
        this.currentStruct = value;
        return value;
    }

    public function valueFloat():AnonPropFloat {
        var value:AnonPropFloat = new AnonPropFloat();
        this.currentStruct = value;
        return value;
    }

    public function valueArray():AnonPropArray {
        var value:AnonPropArray = new AnonPropArray();
        this.currentStruct = value;
        return value;
    }

    public function valueDate():AnonPropDate {
        var value:AnonPropDate = new AnonPropDate();
        this.currentStruct = value;
        return value;
    }

    public function valueObject():AnonPropObject {
        var value:AnonPropObject = new AnonPropObject();
        this.currentStruct = value;
        return value;
    }

    public function valueFunction():AnonPropFunction {
        var value:AnonPropFunction = new AnonPropFunction();
        this.currentStruct = value;
        return value;
    }


    public function refuseNull():Void this._allowNull = false;
    public function allowNull():Void this._allowNull = true;


    public function propertyInt(prop:String):AnonPropInt {
        var propInt:AnonPropInt = new AnonPropInt();
        this.propMap.set(prop, propInt);
        return propInt;
    }

    public function propertyFloat(prop:String):AnonPropFloat {
        var propFloat:AnonPropFloat = new AnonPropFloat();
        this.propMap.set(prop, propFloat);
        return propFloat;
    }

    public function propertyString(prop:String):AnonPropString {
        var propString:AnonPropString = new AnonPropString();
        this.propMap.set(prop, propString);
        return propString;
    }

    public function propertyObject(prop:String):AnonPropObject {
        var propObject:AnonPropObject = new AnonPropObject();
        this.propMap.set(prop, propObject);
        return propObject;
    }

    public function propertyArray(prop:String):AnonPropArray {
        var propArray:AnonPropArray = new AnonPropArray();
        this.propMap.set(prop, propArray);
        return propArray;
    }

    public function propertyDate(prop:String):AnonPropDate {
        var propDate:AnonPropDate = new AnonPropDate();
        this.propMap.set(prop, propDate);
        return propDate;
    }

    public function propertyBool(prop:String):AnonPropBool {
        var propBool:AnonPropBool = new AnonPropBool();
        this.propMap.set(prop, propBool);
        return propBool;
    }

    public function propertyFunction(prop:String):AnonPropFunction {
        var propFunction:AnonPropFunction = new AnonPropFunction();
        this.propMap.set(prop, propFunction);
        return propFunction;
    }

    public function validateAll(data:Dynamic, stopOnFirstError:Bool = false):Void {
        this.validateTree(data, stopOnFirstError, []);
    }

    private function validateTree(data:Dynamic, stopOnFirstError:Bool = false, tree:Array<String> = null) {
        if (tree == null) tree = [];
        var errors:Array<AnonStructError> = [];

        var addDynamicError = function(e:Dynamic, possibleLabel:String, possibleKey:String):Void {
            if (Std.isOfType(e, Array)) {
                var erroList:Array<Dynamic> = cast e;

                for (item in erroList) {
                    if (Std.isOfType(item, AnonStructError)) errors.push(item);
                    else errors.push(new AnonStructError(possibleLabel, possibleKey, Std.string(e)));
                }
            } 
            else if (Std.isOfType(e, AnonStructError)) errors.push(cast e);
            else errors.push(new AnonStructError(possibleLabel, possibleKey, Std.string(e)));

            if (stopOnFirstError) throw errors;
        }

        if (data == null && !this._allowNull) {
            addDynamicError(AnonMessages.NULL_VALUE_NOT_ALLOWED, '', tree.join('.'));
        } else {
            
            try {
                if (this.currentStruct != null) this.currentStruct.validate(data, tree);
            } catch(e:Dynamic) {
                addDynamicError(e, this.currentStruct.propLabel, tree.join('.'));
            }

            for (key in this.propMap.keys()) {
                
                var value:Dynamic = null;

                try {
                    value = Reflect.getProperty(data, key);
                } catch (e:Dynamic) {}

                var tempTree:Array<String> = tree.concat([key]);

                try {
                    this.propMap.get(key).validate(value, tempTree);
                } catch (e:Dynamic) {
                    addDynamicError(e, this.propMap.get(key).propLabel, tempTree.join('.'));
                }

            }

            for (func in this._validateFunc) {
                try {
                    func(data);
                } catch (e:Dynamic) {
                    addDynamicError(e, '', tree.join('.'));
                }
            }
        }

        if (errors.length > 0) throw(errors);
    }

    public function validate(data:Dynamic):Void {
        try {
            this.validateAll(data, true);
        } catch (e:Dynamic) {
            var arr:Array<AnonStructError> = cast e;
            throw e[0];
        }
    }

    public function getErrors(data:Dynamic):Array<AnonStructError> {
        try {
            this.validateAll(data);
            return [];
        } catch (e:Dynamic) {
            var arr:Array<AnonStructError> = cast e;
            return arr;
        }
    }

    public function pass(data:Dynamic):Bool {
        try {
            this.validate(data);
            return true;
        } catch(e:Dynamic) {
            return false;
        }
    }
}

private class AnonProp {

    private var _validateFunc:Array<Dynamic> = [];
    public var propLabel:String = "";

    public function new() {}

    private function validate(value:Dynamic, ?tree:Array<String>):Void {
        
    }

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

    override private function validateFuncs(val:Dynamic):Void {
        var currVal:DateTime = val;
        for (func in this._validateFunc) {
            var currFunc:DateTime->Void = func;
            currFunc(currVal);
        }
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

    inline private function validate_allowedNull(value:Dynamic, allowNull:Bool):Bool return (value != null || (value == null && allowNull));
    private function validate_isDateTime(value:Dynamic):Bool {
        if (Std.isOfType(value, Date)) return true;
        else if (Std.isOfType(value, String)) {
            try {
                DateTime.fromString(value);
                return true;
            } catch (e:Dynamic) {}
        } else if (Std.isOfType(value, Float)) {
            try {
                DateTime.fromTime(value);
                return true;
            } catch (e:Dynamic) {}
        }

        return false;
    }

    inline private function validate_min(value:DateTime, min:Null<DateTime>, equal:Null<Bool>):Bool return ((min == null) || ((equal == null || !equal) && value > min) || (equal && value >= min));
    inline private function validate_max(value:DateTime, max:Null<DateTime>, equal:Null<Bool>):Bool return ((max == null) || ((equal == null || !equal) && value < max) || (equal && value <= max));

    override private function validate(value:Dynamic, ?tree:Array<String>):Void {
        super.validate(value, tree);
        
        if (!this.validate_allowedNull(value, this._allowNull)) throw AnonMessages.NULL_VALUE_NOT_ALLOWED;
        else if (value != null) {

            if (!this.validate_isDateTime(value)) throw AnonMessages.DATE_VALUE_INVALID;
            else {
                
                var date:DateTime = Std.isOfType(value, String) 
                    ? DateTime.fromString(value)
                    : DateTime.fromDate(value);

                if (!this.validate_min(date, this._minDate, this._minEqual))
                    throw (
                        this._minEqual
                        ? AnonMessages.DATE_VALUE_MUST_BE_BEFORE_OR_EQUAL
                        : AnonMessages.DATE_VALUE_MUST_BE_BEFORE
                    ).split('?VALUE0').join(this._minDate.toString());

                if (!this.validate_max(date, this._maxDate, this._maxEqual))
                    throw (
                        this._maxEqual
                        ? AnonMessages.DATE_VALUE_MUST_BE_AFTER_OR_EQUAL
                        : AnonMessages.DATE_VALUE_MUST_BE_AFTER
                    ).split('?VALUE0').join(this._maxDate.toString());

                this.validateFuncs(date);

            }
        }
    }

}

@:access(anonstruct.AnonStruct)
private class AnonPropArray extends AnonProp {

    private var _maxLen:Null<Int> = null;
    private var _minLen:Null<Int> = null;

    private var _allowNull:Bool = false;
    private var _childStruct:Null<AnonStruct> = null;

    public function new() {
        super();
    }

    public function minLen(len:Int):AnonPropArray {
        this._minLen = len;
        return this;
    }

    public function maxLen(len:Int):AnonPropArray {
        this._maxLen = len;
        return this;
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

    public function addValidation(func:Array<Dynamic>->Void):AnonPropArray {
        this._validateFunc.push(func);
        return this;
    }

    inline private function validate_allowedNull(value:Dynamic, allowNull:Bool):Bool return (value != null || (value == null && allowNull));
    inline private function validate_isArray(value:Dynamic):Bool return (Std.isOfType(value, Array));
    inline private function validate_minLen(value:Array<Dynamic>, minLen:Null<Int>):Bool return (minLen == null || minLen < 0 || value.length >= minLen);
    inline private function validate_maxLen(value:Array<Dynamic>, maxLen:Null<Int>):Bool return (maxLen == null || maxLen < 0 || value.length <= maxLen);
    
    override private function validate(value:Dynamic, ?tree:Array<String>):Void {
        if (tree == null) tree = [];
        super.validate(value, tree);

        if (!this.validate_allowedNull(value, this._allowNull)) throw AnonMessages.NULL_VALUE_NOT_ALLOWED;
        else if (value != null) {
            if (!this.validate_isArray(value)) throw AnonMessages.ARRAY_VALUE_INVALID;
            else {

                var val:Array<Dynamic> = cast value;

                if (!this.validate_minLen(val, this._minLen))
                    throw (
                        this._minLen <= 1
                        ? AnonMessages.ARRAY_VALUE_MIN_ITEM_SINGLE
                        : AnonMessages.ARRAY_VALUE_MIN_ITEM_PLURAL
                    ).split('?VALUE0').join(Std.string(this._minLen));

                if (!this.validate_maxLen(val, this._maxLen))
                    throw (
                        this._maxLen <= 1
                        ? AnonMessages.ARRAY_VALUE_MAX_ITEM_SINGLE
                        : AnonMessages.ARRAY_VALUE_MAX_ITEM_PLURAL
                    ).split('?VALUE0').join(Std.string(this._maxLen));

                if (this._childStruct != null) {

                    for (i in 0 ... val.length) {
                        var item = val[i];
                        
                        this._childStruct.validateTree(item, tree.concat(['[$i]']));
                    }

                }

                this.validateFuncs(val);
            }
        }

    }

}

@:access(anonstruct.AnonStruct)
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

    inline private function validate_allowedNull(value:Dynamic, allowNull:Bool):Bool return (value != null || (value == null && allowNull));
    inline private function validate_isObject(value:Dynamic):Bool {
        // this is the best approach??
        if (
            value == null ||
            Std.isOfType(value, String) ||
            Std.isOfType(value, Float) ||
            Std.isOfType(value, Bool) ||
            Std.isOfType(value, Array) ||
            Std.isOfType(value, Class) ||
            Reflect.isFunction(value) 
        ) return false;
        
        return true;
    }

    override private function validate(value:Dynamic, ?tree:Array<String>):Void {
        if (tree == null) tree = [];
        super.validate(value, tree);

        if (!this.validate_allowedNull(value, this._allowNull)) throw AnonMessages.NULL_VALUE_NOT_ALLOWED;
        else if (value != null) {

            if (!this.validate_isObject(value)) throw AnonMessages.OBJECT_VALUE_INVALID;
            else {
        
                if (this._struct != null) this._struct.validateTree(value, tree.copy());
                this.validateFuncs(value);

            }
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
    inline private function validate_isString(value:Dynamic):Bool return (Std.isOfType(value, String));
    inline private function validate_isEmpty(value:String):Bool return (StringTools.trim(value).length == 0);
    inline private function validate_allowedEmpty(value:String, allowEmpty:Null<Bool>):Bool {
        var len:Int = StringTools.trim(value).length;
        return (len > 0 || (len == 0 && allowEmpty == true));
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

    override private function validate(value:Dynamic, ?tree:Array<String>):Void {
        super.validate(value, tree);

        if (!this.validate_allowedNull(value, this._allowNull)) {
            throw AnonMessages.NULL_VALUE_NOT_ALLOWED;
        } else if (value != null) {
            if (!this.validate_isString(value)) {
                throw AnonMessages.STRING_VALUE_INVALID;
            } else {

                var val:String = cast value;

                if (!this.validate_allowedEmpty(val, _allowEmpty)) throw AnonMessages.STRING_VALUE_CANNOT_BE_EMPTY;

                if (!this.validate_isEmpty(val)) {
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
                }
                
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
    inline private function validate_isInt(value:Dynamic):Bool return (Std.isOfType(value, Int));
    inline private function validate_min(value:Int, min:Null<Int>, equal:Null<Bool>):Bool return ((min == null) || ((equal == null || !equal) && value > min) || (equal && value >= min));
    inline private function validate_max(value:Int, max:Null<Int>, equal:Null<Bool>):Bool return ((max == null) || ((equal == null || !equal) && value < max) || (equal && value <= max));

    override private function validate(value:Dynamic, ?tree:Array<String>):Void {
        super.validate(value, tree);

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
    inline private function validate_isFloat(value:Dynamic):Bool return (Std.isOfType(value, Float));
    inline private function validate_min(value:Float, min:Null<Float>, equal:Null<Bool>):Bool return ((min == null) || ((equal == null || !equal) && value > min) || (equal && value >= min));
    inline private function validate_max(value:Float, max:Null<Float>, equal:Null<Bool>):Bool return ((max == null) || ((equal == null || !equal) && value < max) || (equal && value <= max));

    override private function validate(value:Dynamic, ?tree:Array<String>):Void {
        super.validate(value, tree);

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
    inline private function validate_isBool(value:Dynamic):Bool return (Std.isOfType(value, Bool));
    inline private function validate_expected(value:Bool, expected:Null<Bool>):Bool return ((expected == null) || (expected != null && value == expected));

    override private function validate(value:Dynamic, ?tree:Array<String>):Void {
        super.validate(value, tree);

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


private class AnonPropFunction extends AnonProp {

    private var _allowNull:Bool = false;

    public function addErrorLabel(label:String):AnonPropFunction {
        this.propLabel = label;
        return this;
    }

    public function addValidation(func:Dynamic->Void):AnonPropFunction {
        this._validateFunc.push(func);
        return this;
    }

    public function refuseNull():AnonPropFunction {
        this._allowNull = false;
        return this;
    }

    public function allowNull():AnonPropFunction {
        this._allowNull = true;
        return this;
    }

    inline private function validate_allowedNull(value:Dynamic, allowNull:Bool):Bool return (value != null || (value == null && allowNull));
    inline private function validate_isFunction(value:Dynamic):Bool return Reflect.isFunction(value);

    override private function validate(value:Dynamic, ?tree:Array<String>):Void {
        super.validate(value, tree);

        if (!this.validate_allowedNull(value, this._allowNull)) throw AnonMessages.NULL_VALUE_NOT_ALLOWED;
        else if (value != null) {
            if (!this.validate_isFunction(value)) throw AnonMessages.FUNCTION_VALUE_INVALID;
            else {
                var val:Dynamic = cast value;
                this.validateFuncs(val);
            }
        }
    }


}
