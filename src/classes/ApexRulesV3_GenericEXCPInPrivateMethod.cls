/**
  *  @Author      : ATL Team
  *  @Name        : ApexRulesV3_GenericEXCPInPrivateMethod
  *  @Date        : 15/09/2012 
  *  @Description : Examples of Bad & Good Practice of
                    Private methods should not catch generic exceptions - Priority P3 - Design
*/
public class ApexRulesV3_GenericEXCPInPrivateMethod{
            
    /**
      * Bad Practice: Method shows bad practice of catching generic exception in private method                      
      */      
    private void insertAccountBadPractice(Account acc){
        try{
            Database.insert(acc);
        }
        catch(Exception exp){
            System.debug(exp.getMessage());
        }
    }
    
    /**
      * Bad Practice : Method calling private method catching generic exception
      */
    public void createAccountBadPractice(){
        Account acc = new Account(Name = 'ATL');
        insertAccountBadPractice(acc);
    }
    
    /**
      * Good Practice: Method shows good practice of not catching generic exception in private method                      
      */      
    private void insertAccountGoodPractice_First(Account acc){
        try{
            Database.insert(acc);
        }
        catch(DMLException exp){
            System.debug(exp.getMessage());
        }
    }
    
    /**
      * Good Practice : Method calling private method not catching generic exception
      */
    public void createAccountGoodPractice_First(){
        Account acc = new Account(Name = 'ATL');
        insertAccountGoodPractice_First(acc);
    }
    
    /**
      * Good Practice: Method shows good practice of not catching generic exception in private method                      
      */      
    private void insertAccountGoodPractice_Second(Account acc){        
        Database.insert(acc);       
    }
    
    /**
      * Good Practice : Method calling private method not catching generic exception
      */
    public void createAccountGoodPractice_Second(){
        Account acc = new Account(Name = 'ATL');
        try{
            insertAccountGoodPractice_Second(acc);
        }
        catch(Exception exp){
            System.debug(exp.getMessage());
        }
    }
}