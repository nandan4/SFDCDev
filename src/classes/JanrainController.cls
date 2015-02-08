global class JanrainController{

    @RemoteAction
    global static String fetchData(String token) { 
        String jsonString;
        System.debug('** token==> '+token);
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
        Http http = new Http();
        httpReq.setEndpoint('https://nandan.rpxnow.com/salesforce/callback');
        httpReq.setMethod('POST');
        String reqbody = 'token='+ token ;
        httpReq.setBody(reqbody);
        httpRes = http.send(httpReq);
        jsonString = httpRes.getBody();
        System.debug('** Response ==> '+ jsonString );
        //System.debug('** Response ==> '+httpRes.getXmlStreamReader());
        return jsonString;        
    }

}