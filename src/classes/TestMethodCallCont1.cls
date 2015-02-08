public class TestMethodCallCont1{

    public TestMethodCallCont1(ApexPages.StandardController controller) {

    }

    public PageReference cancel(){
        System.debug('*** Cancel Method From TestMethodCallCont1 ***');
        return new PageReference('/home/home.jsp');
    }
}