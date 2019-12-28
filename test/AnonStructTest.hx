package ;

import utest.ui.Report;
import utest.Runner;
import cases.TestBasicString;
import cases.TestBasicInt;
import cases.TestBasicFloat;
import cases.TestBasicBool;
import cases.TestBasicDate;
import cases.TestBasicObject;

class AnonStructTest {
    
    static public function main() {
        
        var runner = new Runner();

        runner.addCase(new TestBasicDate());
        runner.addCase(new TestBasicString());
        runner.addCase(new TestBasicInt());
        runner.addCase(new TestBasicFloat());
        runner.addCase(new TestBasicBool());
        runner.addCase(new TestBasicObject());

        Report.create(runner);
        runner.run();
    }

}