package ;

import utest.ui.Report;
import utest.Runner;
import cases.TestBasicString;
import cases.TestBasicInt;
import cases.TestBasicFloat;
import cases.TestBasicBool;

class AnonStructTest {
    
    static public function main() {
        
        var runner = new Runner();

        runner.addCase(new TestBasicString());
        runner.addCase(new TestBasicInt());
        runner.addCase(new TestBasicFloat());
        runner.addCase(new TestBasicBool());

        Report.create(runner);
        runner.run();
    }

}