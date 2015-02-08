@isTest
public class AP_OpportunityTrigger_Test
{
static testmethod void matchOpportunityTest()
{
//Opportunity opp = new Opportunity(StageName=StaticStringCustomSettings__c.getInstance('CL_4').StaticStringValue__c,CloseDate = Date.Today(),Name =StaticStringCustomSettings__c.getInstance('CL_7').StaticStringValue__c,Opportunity_External_Id__c =StaticStringCustomSettings__c.getInstance('CL_23').StaticStringValue__c,OrderNumber__c =StaticStringCustomSettings__c.getInstance('CL_24').StaticStringValue__c,TrackingNumber__c =StaticStringCustomSettings__c.getInstance('CL_24').StaticStringValue__c);
Opportunity opp = new Opportunity(StageName = 'Confirm Interest',closedate = Date.today(),Name = 'Confirm Interest - Opp');
insert opp;

//Opportunity oppMatch = new Opportunity(StageName=StaticStringCustomSettings__c.getInstance('CL_4').StaticStringValue__c,CloseDate = Date.Today(),Name =StaticStringCustomSettings__c.getInstance('CL_7').StaticStringValue__c,Opportunity_External_Id__c =StaticStringCustomSettings__c.getInstance('CL_23').StaticStringValue__c,OrderNumber__c = StaticStringCustomSettings__c.getInstance('CL_25').StaticStringValue__c,TrackingNumber__c =StaticStringCustomSettings__c.getInstance('CL_25').StaticStringValue__c);
Opportunity oppMatch = new Opportunity(StageName = 'Confirm Interest',closedate = Date.today(),Name = 'Confirm Interest - OppMatch');
insert oppMatch;

try
{
oppMatch.AccountId = Userinfo.getuserid();
update oppMatch;
}catch(Exception exp){}
}

}