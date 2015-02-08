trigger CampaignDelete on Campaign (after delete) {
   
    /* Delete Campaign Members by invoking deleteCampaignMember from AP_CampaignTrigger Class */
    AP_CampaignTrigger.deleteCampaignMember(Trigger.oldMap);
    
}