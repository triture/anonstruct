package ;

import utest.ui.Report;
import utest.Runner;
import cases.TestBasicString;
import cases.TestBasicInt;

class AnonStructTest {
    
    static public function main() {
        
        var runner = new Runner();


        runner.addCase(new TestBasicString());
        runner.addCase(new TestBasicInt());

        Report.create(runner);
        runner.run();
    }

}