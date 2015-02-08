trigger CampaignMemberDelete on CampaignMember (after Delete) {
  
    System.debug('Member Deleted');
   
}