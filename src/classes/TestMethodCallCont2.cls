public class TestMethodCallCont2{

    public TestMethodCallCont2(ApexPages.StandardController controller) {

    }

    public PageReference cancel(){
        System.debug('*** Cancel Method From TestMethodCallCont2 ***');
        return new PageReference('/005900000013ieL');
    }
}