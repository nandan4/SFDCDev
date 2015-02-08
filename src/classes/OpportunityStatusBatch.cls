global class OpportunityStatusBatch implements Database.Batchable<sObject> {
/* Variable */
global String query;
/* Constructor */
global OpportunityStatusBatch(String q){
query = q;
}
/* Start Method */
global Database.QueryLocator start(Database.BatchableContext BC){
return Database.getQueryLocator(query);
}
/* Execute Method */
global void execute(Database.BatchableContext BC,List<Opportunity> opp){
List<Opportunity> oppUpdate = new List<Opportunity>();
for(Opportunity oppClose:opp){
if(oppClose.CloseDate < Date.Today()){
oppClose.Opportunity_Status__c = StaticStringCustomSettings__c.getInstance('CL_4').StaticStringValue__c;
oppUpdate.add(oppClose);
}
}
Database.SaveResult[] dmlExResult = Database.update(oppUpdate,false);
for(Database.SaveResult sr : dmlExResult ){
if (!sr.isSuccess()) {
Database.Error err = sr.getErrors()[0];
}
}
}
/* Finish Method */
global void finish(Database.BatchableContext BC){
// Query the AsyncApexJob object to retrieve the current job's information.
AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
TotalJobItems, CreatedBy.Email
FROM AsyncApexJob WHERE Id = :BC.getJobId()];
System.debug('** Batch Job Status ==> '+a);
}
}