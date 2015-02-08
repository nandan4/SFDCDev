@isTest
private class Sharing_Test
{
static testmethod void sharingTest(){
    
      Profile p = [SELECT Id FROM Profile WHERE Name='Test']; 
      User usr = new User(Alias = 'standt', Email='standarduser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing user', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='testuser@stest.com');
      
       Test.startTest();
           System.debug(usr.profileId);
           system.runAs(usr){
               //WOSharing.createAccount();
               //WOSharing.insertAccount();
                WSharing.createAccount();
               WSharing.insertAccount();
            }
      Test.stopTest();
  

}
}