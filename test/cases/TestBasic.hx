package cases;

import anonstruct.AnonStruct;
import utest.Assert;
import utest.Test;

class TestBasic extends Test {

    function testBasic() {

        var anon:AnonStruct = new AnonStruct();
        anon.allowNull();
        Assert.equals(0, anon.getErrors(null).length);

        var anon:AnonStruct = new AnonStruct();
        anon.refuseNull();

        anon.propertyString('test')
            .refuseNull();

        Assert.raises(anon.validate.bind(null));
    }

}
