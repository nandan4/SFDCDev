/**
  * @author       : candidate@408970advdev.org
  * @date         : 20/12/2014
  * @description  : Trigger on Case Object to call the Handler class to perform necessary action
  */
trigger HandymanLicenseTrigger on Handyman_License__c(before insert,before update,before delete,
                                                        after insert,after update,after delete,after undelete){
    
    HandymanLicenseHandler.execute();
}