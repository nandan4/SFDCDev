/*
    Author          : Accenture IDC Team
    Date Created    : 08/28/2012
    Description     : Class for OpportunityBeforeInsert,OpportunityBeforeUpdate and OpportunityAfterUpdate trigger 
*/

Public Class AP_OpportunityTrigger
{   
    
    /*  @Method <This method mergeOpportunity is used to merge data of new Opportunity record to Existing record>
        @param <oppsMap - Map of Opportunity>
        @return <Method doesnot return value>
        @throws exception - <Method is throwing DML exception which is handled by Database.SaveResult>
    */
    public static void mergeOpportunity(Map<Id,Opportunity> oppsMap,Set<String> lobList,Set<String> oppOriginator, Set<Id> accIds)
    {       
 
        List<Opportunity> oppsUpdate = new List<Opportunity>(); 
        Map<String,String> clientIdsMap = new Map<String,String>() ;
        Map<String,Set<Id>> oppIdsMap = new Map<String,Set<Id>>() ;
        Map<String,Set<Opportunity>> oppMatchMap= new Map<String,Set<Opportunity>>() ;        
        Set<Id> oppIds = new Set<Id>();
        Set<Id> oppSet = new Set<Id>();           
        Set<Opportunity> oppAcc = new Set<Opportunity>();        
        Integer count;
        
        try
        {
            for(Opportunity opp : [SELECT Account.ClientIdentifier__c,AccountId FROM Opportunity WHERE Id IN: oppsMap.keyset() AND AccountId IN: accIds])
            {           
                if(!oppIdsMap.isEmpty() && oppIdsMap.containsKey(opp.AccountId))   
                {
                    oppSet = oppIdsMap.get(opp.AccountId);  
                    oppset.add(opp.Id);                  
                    oppIdsMap.put(opp.AccountId,oppSet);
                }
                else
                {
                    oppIdsMap.put(opp.AccountId,new Set<Id>{opp.Id});
                }
                clientIdsMap.put(opp.AccountId,opp.Account.ClientIdentifier__c);
                               
               // oppIds.add(opp.Id);         
            }
            System.debug('** Account - Opportunity Map ==>'+ oppIdsMap);                       
            System.debug('*** Matched Opportuities  ==>'+[SELECT Account.ClientIdentifier__c,LOB__c,RiskInformation__c,SaveAndRetrieve__c,QuoteReceivedDate__c,Amount,OpportunityOriginator__c,LastModifiedDate FROM Opportunity WHERE IsClosed = False AND RequestId__c = NULL AND Id NOT IN: oppsMap.keyset() AND AccountId IN: accIds AND Account.ClientIdentifier__c IN: clientIdsMap.values() AND LOB__c IN: lobList AND OpportunityOriginator__c IN: oppOriginator AND SaveandRetrieve__c = Null ORDER BY LastModifiedDate DESC,AccountId]);            
            
            for(Opportunity opp : [SELECT Account.ClientIdentifier__c,LOB__c,RiskInformation__c,SaveAndRetrieve__c,QuoteReceivedDate__c,Amount,OpportunityOriginator__c,LastModifiedDate FROM Opportunity WHERE IsClosed = False AND RequestId__c = NULL AND Id NOT IN: oppsMap.keyset() AND AccountId IN: accIds AND Account.ClientIdentifier__c IN: clientIdsMap.values() AND LOB__c IN: lobList AND OpportunityOriginator__c IN: oppOriginator AND SaveandRetrieve__c = Null ORDER BY LastModifiedDate DESC,AccountId])
            {
                if(!oppMatchMap.isEmpty() && oppMatchMap.containsKey(opp.AccountId))
                {
                    count = 0;
                    for(Opportunity oppLatest : oppMatchMap.get(opp.AccountId))
                    {
                        if(opp.LOB__c == oppLatest.LOB__c && opp.OpportunityOriginator__c == oppLatest.OpportunityOriginator__c)
                        {
                            count ++;
                        }                           
                    }      
                                                          
                    if(count > 0)
                    {
                        continue;
                    }  
                    else 
                    {                        
                        oppAcc = oppMatchMap.get(opp.AccountId);
                        oppAcc.add(opp);
                        oppsUpdate.add(opp);
                        oppMatchMap.put(opp.AccountId,oppAcc);                      
                    }                                                             
                }
                else
                {                    
                    oppAcc.add(opp);
                    oppsUpdate.add(opp);
                    oppMatchMap.put(opp.AccountId,oppAcc); 
                }             
            }
            
            System.debug('** Map of Matched ==>'+ oppMatchMap);
            System.debug('** Opportunity List ==>'+ oppsUpdate);
                             
            if(!oppsUpdate.isEmpty())
            {
                for(Opportunity opp : oppsUpdate)
                {
                    System.debug('** Dupe Opp to Update ==>'+ oppIdsMap.get(opp.AccountId));
                    for(Id oppId : oppIdsMap.get(opp.AccountId))
                    {
                        if(oppsMap.get(oppId).LOB__c == opp.LOB__c && oppsMap.get(oppId).OpportunityOriginator__c == opp.OpportunityOriginator__c)
                        {
                            //opp.Product__c = oppsMap.get(oppId).Product__c;
                            opp.RiskInformation__c = oppsMap.get(oppId).RiskInformation__c;
                            opp.SaveAndRetrieve__c = oppsMap.get(oppId).SaveAndRetrieve__c;
                            opp.QuoteReceivedDate__c = oppsMap.get(oppId).QuoteReceivedDate__c;
                            opp.Amount = oppsMap.get(oppId).Amount;  
                            
                            oppIds.add(oppId);
                        }
                    }
                }                                    
                
                System.debug('** Opportuinty Before Update - Matched ==> '+ oppsUpdate);
                System.debug('** Quote Duplicate Opportunities ==>'+ oppIds);
                
                for(Id oppId : oppIds)
                {
                    Opportunity oppTemp = new Opportunity(Id = oppId);
                    oppTemp.QuoteDuplicate__c = True; 
                    oppsUpdate.add(oppTemp);                
                }
                
                System.debug('** Opportuinty Before Update - Dupe & Matched ==> '+ oppsUpdate);
                
                Database.SaveResult[] saveResult = Database.Update(oppsUpdate);
            }
        }
        catch(Exception exp)
        {
            for(Id oppId: oppsMap.keyset())
                oppsMap.get(oppId).addError(exp.getMessage());
        }
        finally
        {
            oppsMap.clear();
            lobList.clear();
            oppOriginator.clear();
            clientIdsMap.clear();
            oppsUpdate.clear();
            oppIdsMap.clear();
        }
    }                      
}