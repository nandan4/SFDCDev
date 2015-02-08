public with sharing class AP_OpportunityTriggerMP{
   public static void createAutoObject(List<MPUID__c> objList){
  List<Opportunity> oppRecords=new List<Opportunity>();
  insert objList; 
  Set<ID> objIDS= new Set<ID>();
  for(MPUID__c objId:objList)
      objIds.add(objId.id);
      
  for(MPUID__c mpuid: [SELECT name, opportunity__c from MPUID__c where id IN :objIds])
  {
      Opportunity opp=new Opportunity(Id= mpuid.opportunity__c);
      opp.Loan_Number__c= mpuid.name;
      oppRecords.add(opp);
  }
  if(!oppRecords.isEmpty())
      update oppRecords;
  }

}