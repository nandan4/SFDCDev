trigger MPUIDTrigger on MPUID__c (after insert) {
    for(MPUID__c obj : Trigger.New){    
        system.debug('***'+obj.Name);
        if(100000 < Integer.valueOf(obj.Name) && Integer.valueOf(obj.Name) < 200000){
            obj.addError('Error');
        }
    }
}