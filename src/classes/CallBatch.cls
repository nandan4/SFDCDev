global class CallBatch implements Schedulable
{
    global void execute(SchedulableContext sc) 
    {
        String q = 'SELECT Name,CloseDate,Opportunity_Status__c FROM Opportunity';
        OpportunityStatusBatch bat = new OpportunityStatusBatch(q);
        Database.executeBatch(bat);
    }
}