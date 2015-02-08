global class InvokeWebService {

    global void invokeWS()
    {
        soapSforceComSchemasClassTestcontro.TestController  test = new soapSforceComSchemasClassTestcontro.TestController();
        soapSforceComSchemasClassTestcontro.SessionHeader_element sh= new soapSforceComSchemasClassTestcontro.SessionHeader_element();
        sh.sessionid = userinfo.getsessionid();
        test.sessionheader = sh;
        test.testCall();
        System.debug('****'+test);
    }
    
}