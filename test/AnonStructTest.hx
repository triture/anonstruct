package ;

import cases.TestBasicFunction;
import utest.ui.Report;
import utest.Runner;
import cases.TestBasicString;
import cases.TestBasicInt;
import cases.TestBasicFloat;
import cases.TestBasicBool;
import cases.TestBasicDate;
import cases.TestBasicObject;
import cases.TestBasicArray;

class AnonStructTest {
    
    static public function main() {
        
        var runner = new Runner();

        runner.addCase(new TestBasicDate());
        runner.addCase(new TestBasicString());
        runner.addCase(new TestBasicInt());
        runner.addCase(new TestBasicFloat());
        runner.addCase(new TestBasicBool());
        runner.addCase(new TestBasicObject());
        runner.addCase(new TestBasicArray());
        runner.addCase(new TestBasicFunction());

        Report.create(runner);
        runner.run();
    }

}