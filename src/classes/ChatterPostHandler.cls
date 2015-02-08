public with sharing class ChatterPostHandler{
    
    @future(callout=true)
    public static void createChatterPost(List<Id> accIdList){
        for(Id accId : accIdList){
            String salesforceHost = System.Url.getSalesforceBaseURL().toExternalForm();
            System.debug('** salesforceHost ==> '+ salesforceHost);
            String url =  salesforceHost + '/services/data/v26.0/chatter/feeds/record/' + accId + '/feed-items';
            System.debug('** url ==> '+ url);   
            HttpRequest req = new HttpRequest();
                        
            req.setMethod('POST');
            req.setEndpoint(url);
            req.setHeader('Content-type', 'application/json');
            req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
                        
            req.setBody('{ "body" : { "messageSegments" : [ { "type": "mention", "id" : "' + UserInfo.getUserId() + '" }, { "type": "text",  "text" : "' + ' ' + 'First Chatter Post :' + accId +  '" } ] } }');
            Http http = new Http();
            System.debug('** req ==> '+ req);  
            HTTPResponse res = http.send(req);
            System.debug('** res ==> '+ res); 
        }
    }

}