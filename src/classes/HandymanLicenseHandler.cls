/**
  * @author       : candidate@408970advdev.org
  * @date         : 21/12/2014
  * @description  : Handler Class for Handyman License object trigger which includes context-specific methods 
                    that are automatically called when a trigger is executed.
  */
public with sharing class HandymanLicenseHandler{
    
    // Variables
    private static HandymanLicenseHelper helper;    // Helper class variable to call methods based on scenario
    
    /**
      * @description       This method is invoked from trigger which in-turn calls the handlers
                           for before and after event.
      * @param             NA 
      * @return            Void
      * @throws            NA
      */        
    public static void execute(){
        helper = new HandymanLicenseHelper();   // instance of helper class for Handyman License trigger
        
        // Check for event type of trigger
        if(Trigger.isBefore){
            beforeHandler();        // invoke of before handler
        }
        else if(Trigger.isAfter){
            afterHandler();         // invoke of after handler
        }
    }
    
    /**
      * @description       This method is handler for before events invoked by execute method.
                           Method invokes the helper class methods based on the scenario.                       
      * @param             NA 
      * @return            Void
      * @throws            NA
      */  
    private static void beforeHandler(){
        // Check for type of operation
        if(Trigger.isInsert){
            // Methods to be invoked for before insert event 
        }
        else if(Trigger.isUpdate){
            // Methods to be invoked for before update event
        }
        else if(Trigger.isDelete){
            // Methods to be invoked for before update event
        }
    }
    
    /**
      * @description       This method is handler for after events invoked by execute method.
                           Method invokes the helper class methods based on the scenario.                          
      * @param             NA 
      * @return            Void
      * @throws            NA
      */  
    private static void afterHandler(){
        // Check for type of operation
        if(Trigger.isInsert){
            // Methods to be invoked for after insert event
            
            /*
                As per the requirement, Chatter post is made whenever user achieves HandymanLicense only and
                update or deletion of license are not handled.
            */
            helper.createChatterPost(Trigger.new);      // method to create chatter post is invoked on achievement of license   
        }
        else if(Trigger.isUpdate){
            // Methods to be invoked for after update event
        }
        else if(Trigger.isDelete){
            // Methods to be invoked for after delete event
        }
        else if(Trigger.isUndelete){
            // Methods to be invoked for after undelete event
        }
    }
}