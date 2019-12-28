package ;

import utest.ui.Report;
import utest.Runner;
import cases.TestBasicString;
import cases.TestBasicInt;
import cases.TestBasicFloat;

class AnonStructTest {
    
    static public function main() {
        
        var runner = new Runner();

        runner.addCase(new TestBasicString());
        runner.addCase(new TestBasicInt());
        runner.addCase(new TestBasicFloat());

        Report.create(runner);
        runner.run();
    }

}