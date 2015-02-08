public class HandymanController{

    public String response {get;set;}
    
    public void getContent(){
        String url =  'http://handyman.force.com/HandymanContractor?id=003U0000017bs3rIAA';
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(url);
        req.setHeader('Content-type', 'application/json');
        req.setHeader('Accept', 'application/json');
        System.debug('** req ==>'+ req);
        Http http = new Http(); 
        HTTPResponse res = http.send(req);
        System.debug('** res ==>'+ res.getBody() );
        response = res.getBody();
        parseResponse(res.getXmlStreamReader());        
    }
    
    private void parseResponse(XmlStreamReader reader){
        Map<String,Integer> monthMap = new Map<String,Integer>();
        monthMap.put('January',1);
        monthMap.put('February',2);
        monthMap.put('March',3);
        monthMap.put('April',4);
        monthMap.put('May',5);
        monthMap.put('June',6);
        monthMap.put('July',7);
        monthMap.put('August',8);
        monthMap.put('September',9);
        monthMap.put('October',10);
        monthMap.put('November',11);
        monthMap.put('December',12);
        System.debug('** response ==>'+ reader);
        // while(reader.hasNext()) {
            // System.debug('Event Type:' + reader.getEventType());
            // if (reader.getEventType() == XmlTag.START_ELEMENT) {
                // System.debug(reader.getLocalName());
            // }
            // reader.next();
        // }
        String[] values = new String[0];
        Integer retry = 0;
        Boolean inRow = false, inCol = false;
        List<Handyman_License__c> licenseList = new List<Handyman_License__c>();
        Handyman_License__c lic;
        Boolean isLic = false;
        Boolean isLicDate = false;
        while(reader.hasNext() && retry < 3) {
            try {
                reader.next();
                retry = 0;
                if(reader.geteventtype()== xmltag.start_element && reader.getlocalname()=='tr' && reader.getAttributeValueAt(0) == 'licenseInfoClass') { 
                    values.add('');
                    inRow = true;
                    System.debug('** attr ==>'+reader.getAttributeValueAt(0));
                    lic = new Handyman_License__c();
                }
                if(reader.geteventtype()==xmltag.end_element && reader.getlocalname()=='tr') {
                    inrow = incol = false;
                }
                if(reader.geteventtype()==xmltag.start_element && reader.getlocalname()=='td') {
                    incol = true;
                    System.debug('** attr ==>'+ reader.getAttributeCount() + '***' +reader.getAttributeValueAt(5));
                }
                if(reader.geteventtype()==xmltag.end_element && reader.getlocalname()=='td') {
                    incol = false;
                    if(!values.isempty())
                        values[values.size()-1]+=';';
                }
                if(inRow && inCol && reader.geteventtype()==xmltag.start_element && reader.getlocalname()=='span') {
                    System.debug('** span attr  ==>'+ reader.getAttributeCount() + '***' +reader.getAttributeValueAt(0));
                    String attr = reader.getAttributeValueAt(0);
                    if(attr == 'licenseNameClass'){
                        //lic.License__c = reader.getText();
                        isLic = true;
                    }
                    else if(attr == 'licenseDateClass'){
                        isLicDate = true;
                        isLic = false;
                    }
                    else{
                        isLic = false;
                        isLicDate = false;
                    }
                }
                if(inRow && inCol && reader.geteventtype()== xmltag.characters) {
                    if(isLic && !String.isBlank(reader.getText())){
                        lic.License__c = reader.getText();
                        System.debug('** License ==>'+reader.getText());
                    }
                    
                    if(isLicDate && lic.License__c != null){
                        List<String> dateVal = reader.getText().split(' ');
                        Integer dayVal = Integer.valueOf(dateVal[1].split(',')[0]);
                        lic.License_Date__c = Date.newInstance(Integer.valueOf(dateVal[2]),monthMap.get(dateVal[0]),dayVal);
                        System.debug('** Date ==>'+lic.License_Date__c);
                        licenseList.add(lic);
                    }
                }
            } 
            catch(exception e) {
                retry++;
            }
        }
        
        System.debug('** licenseList ==>'+ licenseList);
        System.debug('** size ==>'+ licenseList.size());
    }
}