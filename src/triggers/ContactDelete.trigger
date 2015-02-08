trigger ContactDelete on Contact (before delete,after delete,before update,after update) {

    System.debug('***HI***');
    //AP_ContactTrigger.deleteCampaign(Trigger.oldMap);

}