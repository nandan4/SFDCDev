trigger OpportunityTrigger on Opportunity (after insert,after update){
  list<MPUID__c> objLIst = new list<MPUID__c>();
   list<MPUID__c> objUpdateLIst = new list<MPUID__c>();
   Set<ID> oppIds=new Set<ID>();
  if(Trigger.isInsert){ 
    for(Opportunity opp : Trigger.New){
      MPUID__c obj = new MPUID__c();
      System.debug(obj.Name);
      obj.Opportunity__c = opp.id;
      obj.Acive__c = true;
      objList.add(obj);
    }
   }
  if(trigger.isUpdate)
  {
    for(Opportunity opp: Trigger.New)
    {
        if(opp.StageName != trigger.oldMap.get(opp.id).stageName && opp.stageName=='Closed Won')
      {
        oppIds.add(opp.id);
      }
    }
    if(!oppIds.isEmpty())
    {
      for(MPUID__C mpuid:[SELECT Acive__c,Opportunity__c from MPUID__C where Opportunity__c IN :oppIds])
      {
        mpuid.Acive__c=false;
        objUpdateLIst.add(mpuid);
      }
      if(!objUpdateLIst.isEmpty())
        Database.update(objUpdateLIst);
    }
  }
  
  if(!objList.isEmpty()){
    AP_OpportunityTriggerMP.createAutoObject(objList);
  }
}