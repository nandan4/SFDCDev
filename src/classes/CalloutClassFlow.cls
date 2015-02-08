global with sharing class CalloutClassFlow implements Process.Plugin {
    
    global Process.PluginResult invoke(Process.PluginRequest request){
        String empNo = (String) request.inputParameters.get('enterpriseNo');
        
        // SOAP Call
        CalloutclassStub.CalloutClassFlow servCall = new CalloutclassStub.CalloutClassFlow();
        CalloutclassStub.SessionHeader_element sh= new CalloutclassStub.SessionHeader_element();
        sh.sessionid = userinfo.getsessionid();
        servCall.sessionheader = sh;
        String retVal = servCall.testCall(empNo);
        
        // return to Flow   
        Map<String,Object> result = new Map<String,Object>();  
        result.put('IsSuccess',true);
        result.put('RetVal',retVal);
        return new Process.PluginResult(result);  
    }
    
    global Process.PluginDescribeResult describe() {
        Process.PluginDescribeResult result = new Process.PluginDescribeResult(); 
        result.Name = 'Callout Service';  
        result.Tag = 'APEX Helpers';
        
        result.inputParameters =new List<Process.PluginDescribeResult.InputParameter>(); 
        result.inputParameters.add(new Process.PluginDescribeResult.InputParameter(
                                    'enterpriseNo', Process.PluginDescribeResult.ParameterType.STRING, true));
        
        result.outputParameters = new List<Process.PluginDescribeResult.OutputParameter> { 
                                     new Process.PluginDescribeResult.OutputParameter('IsSuccess', Process.PluginDescribeResult.ParameterType.BOOLEAN),
                                     new Process.PluginDescribeResult.OutputParameter('RetVal', Process.PluginDescribeResult.ParameterType.STRING)};
        return result; 
    }
    
    Webservice static string testCall(String txt){
        System.debug('** Service Called **');
        return 'Hello ' + txt;
    }
}