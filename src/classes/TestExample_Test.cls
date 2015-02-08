@isTest
public class TestExample_Test{
    
    static testmethod void createAccount(){
    
         // Test Data
         Account acc = new Account(Name= 'Test');   
         Account acc1 = new Account(Name= 'Test',Phone ='34125235');   
    
         
         Test.startTest();         
             TestExample.createAccount(acc);
             TestExample.createAccount(acc1);             
         Test.stopTest();         
    }  
}