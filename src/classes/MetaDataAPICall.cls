/**
  * @Author : Nandan 
  * @Name   : MetaDataAPICall
  * @Date   : 21/09/2013
  * @Description : This class invoke retrieve method of MetaData API
  */
public with sharing class MetaDataAPICall{
    
    
    public MetaDataAPICall(ApexPages.StandardSetController controller) {
        status = true;
        count = 0;         
        retrieveMetadataItem();
    }

    
    public MetadataService.AsyncResult AsyncResult {get; set;}
    public MetadataService.AsyncResult[] results {get; set;}
    public String MetaDataRetrieveZip { get; set; }
    public List<MetadataFile> MetadataFiles { get; set; } 
    public String MetaDataType = 'ListView';
    public String resourceId ;
    public string asyncId ;
    public String body {get;set;}
    public boolean status {get;set;}
    
    public void listMetadata(){
        MetadataService.MetadataPort service = createService();     
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();        
        MetadataService.ListMetadataQuery queryWorkflow = new MetadataService.ListMetadataQuery();
        queryWorkflow.type_x = 'ListView';
        queries.add(queryWorkflow);            
        MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 25);
        for(MetadataService.FileProperties fileProperty : fileProperties)
            System.debug('*** File Property ==>'+fileProperty);
    }
    
    public void init(){
        // List available Metadata Types via the 'describeMetadata' API call
        MetadataService.MetadataPort service = createService();
        MetadataService.DescribeMetadataResult describeResult = service.describeMetadata(26);
        List<String> metadataTypeNames = new List<String>();
        for(MetadataService.DescribeMetadataObject metadataObject : describeResult.metadataObjects){
            metadataTypeNames.add(metadataObject.xmlName);
            // Include child Metadata Types (such as CustomField, ValidationRule etc..)
            if(metadataObject.childXmlNames!=null){
                for(String childXmlName : metadataObject.childXmlNames){
                    if(childXmlName!=null){
                        metadataTypeNames.add(childXmlName);
                        System.debug('*** childXmlName==>'+childXmlName);
                    }
                }
            }
        }

        System.debug('*** metadataTypeNames ==>'+metadataTypeNames);
    }
    
    public PageReference retrieveMetadataItem(){                
        // Reset state from any previous requests
        MetaDataRetrieveZip = null;
        MetadataFiles = null;
        
        // Construct unmanaged package with list of desired components to retrieve in zip
        MetadataService.MetadataPort service = createService();
        MetadataService.RetrieveRequest retrieveRequest = new MetadataService.RetrieveRequest();
        retrieveRequest.apiVersion = 28;
        retrieveRequest.packageNames = null;
        retrieveRequest.singlePackage = true;
        retrieveRequest.specificFiles = null;
        retrieveRequest.unpackaged = new MetadataService.Package_x();
        retrieveRequest.unpackaged.types = new List<MetadataService.PackageTypeMembers>();
        MetadataService.PackageTypeMembers packageType = new MetadataService.PackageTypeMembers();
        packageType.name = 'ListView';
        packageType.members = new String[] {'*'};
        retrieveRequest.unpackaged.types.add(packageType);
        System.debug('*** packageType ==>'+packageType );
        System.debug('*** retrieveRequest==>'+retrieveRequest);
        AsyncResult = service.retrieve(retrieveRequest);
        asyncId = AsyncResult.id;
        System.debug('*** AsyncResult ==>'+AsyncResult );

        /*
        while(AsyncResult != null){
            checkAsyncRequest();
        }
        
        System.debug('*** MetadataRetrieveZip ==>'+MetadataRetrieveZip );
        if(MetadataRetrieveZip != null){
            createStaticResource();
        }  
        /*
        while(results != null){
            checkCreateRequest();
        }
        List<StaticResource> res = [SELECT Id,Name,body FROM StaticResource where name = 'test'];
        System.debug('*** res ==>'+res );    
        */
        return null;
    }
    
    public void checkCreateRequest(){
        // Check the status of the retrieve request
        MetadataService.MetadataPort service = createService();
        MetadataService.AsyncResult[] aysncResults = service.checkStatus(new String[] { results[0].Id});
        if(aysncResults[0].done){
            results = null;
        }
            
    }
    
    public PageReference checkAsyncRequest(){
        
        System.debug('*** checkAsyncRequest Method ***');
        System.debug('*** asyncId ***'+asyncId );
        // Check the status of the retrieve request        
        MetadataService.MetadataPort service = createService();
        MetadataService.AsyncResult[] aysncResults = service.checkStatus(new String[] { asyncId });
        if(aysncResults[0].done){
            // Errors?
            if(aysncResults[0].state == 'Error'){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, aysncResults[0].message));
                AsyncResult = null;
                status = false;
            }
            else{
                // Place Base64 encoded zip data onto the page for the JSZip library to handle
                MetadataService.RetrieveResult retrieveResult = service.checkRetrieveStatus(asyncId );
                MetaDataRetrieveZip = retrieveResult.zipFile;
                MetadataFiles = new List<MetadataFile>();
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Expanding...'));
                AsyncResult = null;                
                status = false;
                System.debug('*** MetaDataRetrieveZip ==>'+MetaDataRetrieveZip );
            }
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Retrieving metadata...'));
        }
        return null;
    }
    
    public Integer count {get;set;}
    
    
    public PageReference incrementCounter(){
        
        count++;
        return null;
    }
    
    public PageReference createStaticResource(){
        MetadataService.MetadataPort service = createService();
        MetadataService.StaticResource staticResource = new MetadataService.StaticResource();
        staticResource.fullName = 'LV';
        staticResource.contentType = 'application/zip';
        staticResource.cacheControl = 'public';
        staticResource.content = MetaDataRetrieveZip;
        results = service.create(new List<MetadataService.Metadata> { staticResource });
        resourceId = results[0].id;
        System.debug('*** resourceId ==> '+resourceId );
        System.debug('*** results ==> '+results);
        return null;
    }
    
    public PageReference displayResource(){
        PageReference somefileRef = new PageReference('/resource/' + 'test' + '/objects/Account.object');
        System.debug('*** somefileRef ==>'+somefileRef );    
        Blob contentAsBlob = somefileRef.getContent();
        System.debug('*** contentAsBlob ==>'+contentAsBlob );    
        body = contentAsBlob.toString();
        System.debug('*** body ==>'+body );
        Dom.Document doc = new Dom.Document();
        doc.load(body);
        System.debug('*** doc==>'+doc);
        Dom.XMLNode root = doc.getRootElement();  
        System.debug('*** root ==>'+root );  
        String wRoot = walkThrough(root );
        System.debug('*** wRoot ==>'+wRoot ); 
                
        String query = 'SELECT Id,Name FROM Account WHERE ' + generateQuery (root );
        System.debug('*** query ==>'+query ); 
        
        return null;
    }
    
    private String generateQuery (DOM.XMLNode node){
        String query = '';
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
            if(node.getName() == 'field'){
                query += node.getText().substring(node.getText().indexOf('.')+1);
            }
            else if(node.getName() == 'operation'){
                if(node.getText().trim() == 'equals'){
                    query += ' = ';
                }
            }
            else if(node.getName() == 'value'){
                query += node.getText().trim();
            }
        }
        for (Dom.XMLNode child: node.getChildElements()) {
            query += generateQuery (child);
        }
        return query;
    }
    
    
    private String walkThrough(DOM.XMLNode node) {
      String result = '\n';
      if (node.getNodeType() == DOM.XMLNodeType.COMMENT) {
        return 'Comment (' +  node.getText() + ')';
      }
      if (node.getNodeType() == DOM.XMLNodeType.TEXT) {
        return 'Text (' + node.getText() + ')';
      }
      if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
        result += 'Element: ' + node.getName();
        if (node.getText().trim() != '') {
          result += ', text=' + node.getText().trim();
        }
        if (node.getAttributeCount() > 0) { 
          for (Integer i = 0; i< node.getAttributeCount(); i++ ) {
            result += ', attribute #' + i + ':' + node.getAttributeKeyAt(i) + '=' + node.getAttributeValue(node.getAttributeKeyAt(i), node.getAttributeKeyNsAt(i));
          }  
        }
        for (Dom.XMLNode child: node.getChildElements()) {
          result += walkThrough(child);
        }
        return result;
      }
      return '';  //should never reach here 
    }
    
    public static MetadataService.MetadataPort createService(){ 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;     
    }      
    
    public class MetadataFile {
        public string fullName;
        public string content;
    }
}