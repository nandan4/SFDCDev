/*
    Author          : Nandan Narasappa
    Date Created    : 11/18/2012
    Description     : Test Class for VFC_StringExternalize
*/
@isTest 
public class VFC_StringExternalize_Test
{
    public static testMethod void testExternalizeString()  
    {
        PageReference pageRef = Page.VFP_StringExternalize; 
        Test.setCurrentPage(pageRef);    //Set String Externalize Page as Current Page
        
        Test.StartTest();
        
        VFC_StringExternalize testCls = new VFC_StringExternalize();
        
        /* Scenario with Apex Class having hard coded string */
        VFC_StringExternalize.classId = '01p90000001dLus';
        VFC_StringExternalize.externalizeString();
        
        StaticStringCustomSettings__c custSetting = new StaticStringCustomSettings__c(Name='CL_1',StaticStringValue__c = 'SELECT Name,CloseDate,Opportunity_Status__c FROM Opportunity',Reference__c = 'Test Data');
        Database.insert(custSetting);
        
        StaticStringCustomSettings__c custSetting2 = new StaticStringCustomSettings__c(Name='CL_2',StaticStringValue__c = 'rows',Reference__c = 'Test Data');
        Database.insert(custSetting2);        
        
        /* Scenario with Apex Class having hard coded string value existing in Custom Setting */
        VFC_StringExternalize.classId = '01p90000001e2Zp';
        VFC_StringExternalize.externalizeString();      
        
        VFC_StringExternalize.classId = '01p90000001eCaK';
        VFC_StringExternalize.externalizeString(); 
        
        VFC_StringExternalize.classId = '01p90000001dLus';
        VFC_StringExternalize.externalizeString();
        
        try
        {
           VFC_StringExternalize.classId = '';
           VFC_StringExternalize.externalizeString();
        }
        catch(Exception exp)
        {
            System.assertEquals(exp.getMessage(),'There has been a System Error. Please Contact System Administrator');
        }
        
        try
        {
           ApexClass cls;
           VFC_StringExternalize.generateCSCode(cls);
        }
        catch(Exception exp)
        {
            System.assertEquals(exp.getMessage(),'There has been a System Error. Please Contact System Administrator');
        }
        
        Test.StopTest();
    }
}