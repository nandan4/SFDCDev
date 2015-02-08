/*
    Author          : Accenture IDC Team
    Date Created    : 11/7/2012
    Description     : trigger to Update the Quote Information for Opportunity From Quoting System.
*/

trigger OpportunityAfterInsert on Opportunity (After Insert)
{ 

    Map<Id,Opportunity> oppsMap = new Map<Id,Opportunity>();    
    Set<String> lobList = new Set<String>();
    Set<String> oppOriginator = new Set<String>();
    Set<Id> accIds = new Set<Id>();
    
    For(Opportunity opp: Trigger.new)
    {        
        //If(UserInfo.getProfileId() == Utils_DataCreation.getProfileId('System Generated'))
        //{            
            If(opp.SaveandRetrieve__c != Null && opp.AccountId != Null && opp.LOB__c != Null && !opp.OpportunityOriginator__c.equalsIgnoreCase('Statefarm.com'))
            {
                oppsMap.put(opp.Id,opp);                
                lobList.add(opp.LOB__c);
                oppOriginator.add(opp.OpportunityOriginator__c);
                accIds.add(opp.AccountId);
            }
       // }
    } 
 
    /* Checks Map Size before Calling mergeOpportunity */
    If(!oppsMap.isEmpty() && !lobList.isEmpty() && !accIds.isEmpty())
    {
        AP_OpportunityTrigger.mergeOpportunity(oppsMap,lobList,oppOriginator,accIds);
    }
}