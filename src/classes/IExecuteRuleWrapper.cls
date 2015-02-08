public interface IExecuteRuleWrapper {
    
    /** 
      * @Method <Method to be implemented by the wrapper which will help validate data>
      * @param <map<String,String>> 
      * @return < Map<String, Wrapper_GenericException> the fieldAPIName and errorResult>
      */
    map<String, Wrapper_GenericException> validateData(map<String,String> fieldAPINameValueMap);
    
}