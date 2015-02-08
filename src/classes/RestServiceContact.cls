/*
    Author          : Nandan Narasappa
    Date Created    : 22/06/2013
    Description     : Rest Service for Creating/Querying Contact
*/

@RestResource (urlmapping ='/RestServiceContact/*')
global class RestServiceContact {
    
    
    /*  
        @Method <This method handleInboundEmail is used to handle incoming mail and createContact>
        @param <email - Messaging.InboundEmail
                envelope - Messaging.InboundEnvelope>
        @return <Messaging.InboundEmailResult>
        @throws exception - <Method is throwing exception which is handled by try-catch block>
    */
    @HttpGet
    global static List<Contact> queryContacts(){
        RestRequest req = RestContext.request;
        System.debug('** RestRequest ==>'+req);
        RestResponse res = RestContext.response;
        System.debug('** RestResponse ==>'+res );
        
        res.addHeader('Access-Control-Allow-Origin','*');
        res.addHeader('Access-Control-Allow-Credentials','true');
        res.addHeader('Access-Control-Allow-Methods','GET, POST, DELETE, PUT, OPTIONS, HEAD');
        res.addHeader('Access-Control-Allow-Headers','Content-Type, Accept, X-Requested-With');
        res.addHeader('Cache-Control','no-transform,public,max-age=300,s-maxage=900');
        
        List<Contact> cons = [SELECT id,Name,Email FROM Contact];
        System.debug('** cons ==>'+cons );
        
        System.debug('** RestResponse ==>'+res );
        return cons;
    }
}