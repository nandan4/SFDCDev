Public Class AP_ContactTrigger {

    public static void deleteCampaign(MAP<Id,Contact> contsMap)
    {
        Set<Id> cmIDs = new Set<Id>();
        List<CampaignMember> cms = [SELECT Id,CampaignId FROM CampaignMember WHERE ContactId IN : contsMap.keyset() ];
        for(CampaignMember cm: cms)
        {       
             cmIDs.add(cm.CampaignId);    
        }
        List<CampaignMember> cm = [SELECT id,CampaignId FROM CampaignMember WHERE CampaignId IN : cmIDs AND ContactId Not IN: contsMap.keyset() AND LeadId = Null];
        for(CampaignMember c: cm)
        {       
             cmIDs.remove(c.CampaignId);    
        }
        List<Campaign> camp = [SELECT id FROM Campaign WHERE Id IN : cmIDs];
        Database.DeleteResult[] dr = Database.Delete(camp,false);
   
        
    }



}