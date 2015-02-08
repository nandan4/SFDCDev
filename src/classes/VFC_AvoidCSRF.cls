/**
  *  @Author      : ATL Team
  *  @Name        : VFC_AvoidCSRF
  *  @Date        : 09/23/2012 
  *  @Description : Avoid CSRF vulnerability        
*/
public class VFC_AvoidCSRF{

    public VFC_AvoidCSRF(ApexPages.StandardController controller) {

    }
    
    public VFC_AvoidCSRF() {
        
    }

    /**
      * Bad Practice: Method shows bad practice of performing DML on GET request.        
      */
    public void deleteAccounts(){
        List<Account> accListToDelete = [SELECT Id FROM Account limit 1];
        Database.delete(accListToDelete);
    }
}