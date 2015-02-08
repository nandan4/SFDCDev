/**
  *  @Author      : ATL Team
  *  @Name        : NovaUtitlity
  *  @Date        : 14/09/2012 
  *  @Description : Utility Class for creating Test Data
*/
public class NovaUtility {
            
    /**
      * @Name        : createUser
      * @Description : This method is used to create User
      * @param       : profile - Name of Profile
      * @return      : User
      * @Exception   : Method is not throwing any exception
      */
    public static User createUser(String lastName, String profileName){
        Profile prof = [SELECT Id FROM Profile WHERE Name =: profileName LIMIT 1]; 
        User usr = new User(Alias = lastName, Email = lastName+'@atl.com', 
                            EmailEncodingKey = 'UTF-8', LastName = lastName, LanguageLocaleKey = 'en_US', 
                            LocaleSidKey = 'en_US', ProfileId = prof.Id, 
                            TimeZoneSidKey = 'America/Los_Angeles', UserName = lastName+'@atl.com');
        return usr;
    }
    
    /**
      * @Name        : createAccout
      * @Description : This method is used to create Account
      * @param       : name - Name of Account
      * @return      : Account
      * @Exception   : Method is not throwing any exception
      */
    public static Account createAccount(String name){
        Account acc = new Account(Name = name);
        return acc;
    }
}