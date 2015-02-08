Public Class AP_CampaignTrigger {

/* Variables */
public Static List<CampaignMember> cmpMember = new List<CampaignMember>();
Static List<CampaignMember> cmpsMember = new List<CampaignMember>();
Static List<Lead> leds = new List<Lead>();
String hcStrg = StaticStringCustomSettings__c.getInstance('CL_2').StaticStringValue__c;

public static void deleteCampaignMember(MAP<Id,Campaign> cmpsMap)
{
try
{
System.debug('** Campaign Members **'+cmpsMap.keyset());
System.debug(' Trigger Old map'+Trigger.oldMap.keyset());
System.debug('Trigger Old Records '+Trigger.Old);
for(Id cm : cmpsMap.keyset())
{
String s = cmpsMap.get(cm).Name;
}
set<Id> idsMap = new set<Id>();
/* Query Campaign Members with Lead */
cmpMember = [SELECT Id,LeadId,CampaignId,MBR_External__c From CampaignMember WHERE campaignID In : cmpsMap.keyset()];
System.debug('** Campaign Members **'+cmpMember);
for(CampaignMember cm: cmpMember)
{
idsMap.add(cm.LeadId);
}
cmpsMember = [SELECT Id,LeadId,MBR_External__c FROM CampaignMember WHERE LeadId IN: idsMap];
System.debug('** Same Lead Campaign Members **'+cmpsMember);
for(CampaignMember cm : cmpsMember)
{
idsMap.remove(cm.LeadId);
}

leds = [SELECT Id FROM Lead WHERE Id IN: idsMap ];
System.debug('** Leads **'+leds);
Database.DeleteResult[] dr = Database.Delete(leds,false);
if(Limits.getDMLRows()> Limits.getLimitDMLRows())
{
//throw new LimitException(''+Limits.getDMLRows());
}
for(Database.DeleteResult d :dr)
{
if(!d.isSuccess())
{
System.debug('** Error During Delete **' + d.getErrors());
}
}
}catch(QueryException qEx){
for(Id i : cmpsMap.keyset())
{
cmpsMap.get(i).addError(qEx.getMessage());
}
}catch(DMLException dEx){
for(Id i : cmpsMap.keyset())
{
cmpsMap.get(i).addError(dEx.getMessage());
}
}catch(Exception ex){
for(Id i : cmpsMap.keyset())
{
cmpsMap.get(i).addError(ex.getMessage());
}
}
}
}