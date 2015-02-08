trigger LeadTrigger on Lead (before update,after update) {

    if(Trigger.isBefore)
    {
        System.debug('Before Trigger');
    }
    if(Trigger.isAfter)
    {
        for(Lead led : Trigger.New)
        {
            led.ownerId = Userinfo.getUserId();
            if(led.IsConverted)
            {
                System.debug('** After Trigger' +  led.IsConverted );
            }
         }   
    }
}