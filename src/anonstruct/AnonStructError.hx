package anonstruct;

class AnonStructError {

    public var label:String;
    public var property:String;
    public var errorMessage:String;

    public function new(label:String, property:String, errorMessage:String) {
        this.label = label;
        this.property = property;
        this.errorMessage = errorMessage;

        if (this.label == null) this.label = "";
    }

    public function toString():String {
        if (this.property != "") return this.property + ": " + this.errorMessage;
        else return this.errorMessage;
    }

    public function toStringFriendly():String {
        if (this.label != "") return this.label + ": " + this.errorMessage;
        else return this.errorMessage;
    }
}