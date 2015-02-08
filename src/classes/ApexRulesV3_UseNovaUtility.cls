/**
  *  @Author      : ATL Team
  *  @Name        : ApexRulesV3_UseNovaUtility
  *  @Date        : 14/09/2012 
  *  @Description : Examples of Bad & Good Practice of
                    Test Classes should use NovaUtility Class - Priority P3 - Design        I
*/
@isTest
private class ApexRulesV3_UseNovaUtility {
            
    /**
      * Bad Practice: Method shows bad practice of creating test data directly in Test class
                      instead of using Utility Class.        
      */
    static testMethod void createAccountBadPractice_First(){
        Account acc = new Account(Name = 'ATL');        
        Test.startTest();
            Database.insert(acc);
        Test.stopTest();
        
    }
    
    /**
      * Bad Practice: Method shows bad practice of creating test data directly in Test class
                      instead of using Utility Class.        
      */
    static testMethod void createAccountBadPractice_Second(){
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1]; 
        User usr = new User(Alias = 'ATL', Email = 'atlUser@atl.com', 
                            EmailEncodingKey = 'UTF-8', LastName = 'ATLUser', LanguageLocaleKey = 'en_US', 
                            LocaleSidKey = 'en_US', ProfileId = prof.Id, 
                            TimeZoneSidKey = 'America/Los_Angeles', UserName = 'atlUser@atl.com');
        Account acc = new Account(Name = 'ATL');        
        System.runAs(usr){
            Test.startTest();
                Database.insert(acc);
            Test.stopTest();
        }
    }
    
    /**
      * Good Practice: Method shows Good practice of using Utility Class for Test data creation.        
      */
    static testMethod void createAccountGoodPractice(){ 
        User usr = NovaUtility.createUser('ATLUser','System Administrator');
        Account acc = NovaUtility.createAccount('ATL');     
        System.runAs(usr){
            Test.startTest();
                Database.insert(acc);
            Test.stopTest();
        }        
    }
}