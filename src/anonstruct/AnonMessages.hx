package anonstruct;

class AnonMessages {

    public static var NULL_VALUE_NOT_ALLOWED = "Value cannot be null";

    public static var DATE_VALUE_INVALID = "Value must be a valid date";
    public static var DATE_VALUE_MUST_BE_BEFORE = "Value must be before ?VALUE0";
    public static var DATE_VALUE_MUST_BE_BEFORE_OR_EQUAL = "Value must be before or equal ?VALUE0";
    public static var DATE_VALUE_MUST_BE_AFTER = "Value must be after ?VALUE0";
    public static var DATE_VALUE_MUST_BE_AFTER_OR_EQUAL = "Value must be after or equal ?VALUE0";

    public static var ARRAY_VALUE_INVALID = "Value must be an array";
    public static var ARRAY_VALUE_MIN_ITEM_SINGLE = "Value must have at least 1 item";
    public static var ARRAY_VALUE_MIN_ITEM_PLURAL = "Value must have at least ?VALUE0 items";
    public static var ARRAY_VALUE_MAX_ITEM_SINGLE = "Value must have at most 1 item";
    public static var ARRAY_VALUE_MAX_ITEM_PLURAL = "Value must have at most ?VALUE0 items";

    public static var STRING_VALUE_INVALID = "Value must be a string";
    public static var STRING_VALUE_CANNOT_BE_EMPTY = "Value cannot be empty";
    public static var STRING_VALUE_MIN_CHAR_SINGLE = "Value must have at least 1 character";
    public static var STRING_VALUE_MIN_CHAR_PLURAL = "Value must have at least ?VALUE0 characters";
    public static var STRING_VALUE_MAX_CHAR_SINGLE = "Value must have at most 1 character";
    public static var STRING_VALUE_MAX_CHAR_PLURAL = "Value must have at most ?VALUE0 characters";
    public static var STRING_VALUE_SHOULD_STARTS_WITH = "Value should starts with ?VALUE0";
    public static var STRING_VALUE_SHOULD_ENDS_WITH = "Value should ends with ?VALUE0";
    public static var STRING_VALUE_CHAR_NOT_ALLOWED = "Character '?VALUE0' not allowed";
    public static var STRING_VALUE_OPTION_NOT_ALLOWED = "Value '?VALUE0' is not allowed. Accepted values: ?VALUE1";

    public static var INT_VALUE_INVALID = "Value must be an int number";
    public static var INT_VALUE_GREATER_THAN = "Value must be greater than ?VALUE0";
    public static var INT_VALUE_GREATER_OR_EQUAL_THAN = "Value must be greater or equal than ?VALUE0";
    public static var INT_VALUE_LESS_THAN = "Value must be less than ?VALUE0";
    public static var INT_VALUE_LESS_OR_EQUAL_THAN = "Value must me less or equal than ?VALUE0";

    public static var FLOAT_VALUE_INVALID = "Value must be a number";
    public static var FLOAT_VALUE_GREATER_THAN = "Value must be greater than ?VALUE0";
    public static var FLOAT_VALUE_GREATER_OR_EQUAL_THAN = "Value must be greater or equal than ?VALUE0";
    public static var FLOAT_VALUE_LESS_THAN = "Value must be less than ?VALUE0";
    public static var FLOAT_VALUE_LESS_OR_EQUAL_THAN = "Value must be less or equal than ?VALUE0";

    public static var BOOL_VALUE_INVALID = "Value must be a bool";
    public static var BOOL_VALUE_EXPECTED = "Value should be ?VALUE0";

    public static var OBJECT_VALUE_INVALID = "Value must be an object";
    
    public static var FUNCTION_VALUE_INVALID = "Value must be a function";

    static public function setLanguage_PT_BR() {
        NULL_VALUE_NOT_ALLOWED = "O valor não pode ser nulo";
        DATE_VALUE_INVALID = "O valor deve ser uma data válida";
        DATE_VALUE_MUST_BE_BEFORE = "A data deve ser anterior a ?VALUE0";
        DATE_VALUE_MUST_BE_BEFORE_OR_EQUAL = "A data deve ser anterior ou igual a ?VALUE0";
        DATE_VALUE_MUST_BE_AFTER = "A data deve ser posterior a ?VALUE0";
        DATE_VALUE_MUST_BE_AFTER_OR_EQUAL = "A data deve ser posterior ou igual a ?VALUE0";
        ARRAY_VALUE_INVALID = "O valor esperado deve ser um array";
        ARRAY_VALUE_MIN_ITEM_SINGLE = "O array deve ter pelo menos 1 item";
        ARRAY_VALUE_MIN_ITEM_PLURAL = "O array deve ter pelo menos ?VALUE0 itens";
        ARRAY_VALUE_MAX_ITEM_SINGLE = "O array deve ter no máximo 1 item";
        ARRAY_VALUE_MAX_ITEM_PLURAL = "O array deve ter no máximo ?VALUE0 itens";
        STRING_VALUE_INVALID = "O valor deve ser um texto";
        STRING_VALUE_CANNOT_BE_EMPTY = "O texto não pode ser vazio";
        STRING_VALUE_MIN_CHAR_SINGLE = "O texto deve ter pelo menos 1 caractere";
        STRING_VALUE_MIN_CHAR_PLURAL = "O texto deve ter pelo menos ?VALUE0 caracteres";
        STRING_VALUE_MAX_CHAR_SINGLE = "O texto deve ter no máximo 1 caractere";
        STRING_VALUE_MAX_CHAR_PLURAL = "O texto deve ter no máximo ?VALUE0 caracteres";
        STRING_VALUE_SHOULD_STARTS_WITH = "O texto deve começar com ?VALUE0";
        STRING_VALUE_SHOULD_ENDS_WITH = "O texto deve terminar em ?VALUE0";
        STRING_VALUE_CHAR_NOT_ALLOWED = "O caractere ?VALUE0 não é permitido";
        STRING_VALUE_OPTION_NOT_ALLOWED = "'?VALUE0' não é um valor permitido. Os valores aceitos são: ?VALUE1";
        INT_VALUE_INVALID = "O valor deve ser um número inteiro";
        INT_VALUE_GREATER_THAN = "O valor deve ser maior que ?VALUE0";
        INT_VALUE_GREATER_OR_EQUAL_THAN = "O valor deve ser maior ou igual a ?VALUE0";
        INT_VALUE_LESS_THAN = "O valor deve ser menor que ?VALUE0";
        INT_VALUE_LESS_OR_EQUAL_THAN = "O valor deve ser menor ou igual a ?VALUE0";
        FLOAT_VALUE_INVALID = "O valor deve ser um número";
        FLOAT_VALUE_GREATER_THAN = "O valor deve ser maior que ?VALUE0";
        FLOAT_VALUE_GREATER_OR_EQUAL_THAN = "O valor deve ser maior ou igual a ?VALUE0";
        FLOAT_VALUE_LESS_THAN = "O valor deve ser menor que ?VALUE0";
        FLOAT_VALUE_LESS_OR_EQUAL_THAN = "O valor deve ser menor ou igual a ?VALUE0";
        BOOL_VALUE_INVALID = "O valor deve ser booleano";
        BOOL_VALUE_EXPECTED = "O valor esperado era ?VALUE0";
        OBJECT_VALUE_INVALID = "O valor deve ser um objeto";
        FUNCTION_VALUE_INVALID = "O valor deve ser uma função";
    }

}