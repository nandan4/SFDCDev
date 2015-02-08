public with sharing class ProfileUpdateController {

  public string selectedSObject{get; set;}
  public static list<String> check = new List<String>();
  public static boolean flag{get; set;}
   public Static List<SelectOption> MetaDataTypes {get; set;}
    public  static String MetaDataType {get; set;}      
    public static List<SelectOption> MetaDataItems {get; set;}
    public static String MetaDataFolder {get; set;} 
    public static String MetaDataItem {get; set;}  
    public static String MetadataFileName {get; set;}
    public static String MetadataFileData {get; set;}
    public static MetadataService.AsyncResult AsyncResult {get; private set;}
    public MetadataService.AsyncResult[] results {get; set;}
    public static String MetaDataRetrieveZip { get; private set; } 
    Public  Integer seconds{get;set;}
    public static string asyncresultid{get; set;}
    public List<String> st= new List<String>();
  // public List<MetadataFile> MetadataFiles { get; set; }       

  
   public ProfileUpdateController()
   {
    seconds = 0;
    system.debug('-1---------');
  //  asyncresultid ='';
   }
  Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
  public List<SelectOption> getobjectList()
        {
            List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('--None','--None--'));
            for(Schema.SObjectType f : ProcessInstance.TargetObjectId.getDescribe().getReferenceTo())
            {
                 options.add(new SelectOption(f.getDescribe().getName(),f.getDescribe().getName()));
            }
            system.debug('-2---------');
            return options;
            }
            
     public static MetadataService.MetadataPort createService()
    { 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
      system.debug('-3---------');    
        return service; 
        
    }   
    
   public static void listMetadata()
    {
      
      MetadataService.MetadataPort service = createService();     
    List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();        
    MetadataService.ListMetadataQuery queryProfile= new MetadataService.ListMetadataQuery();
    queryProfile.type_x = 'Profile';
    queries.add(queryProfile);     
    MetadataService.ListMetadataQuery queryValidationRule = new MetadataService.ListMetadataQuery();
    queryValidationRule.type_x = 'ValidationRule';
    queries.add(queryValidationRule);       
    MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 25);
    for(MetadataService.FileProperties fileProperty : fileProperties)
    {
        System.debug('@@@@@@@'+fileProperty.fullname);
        check.add(fileProperty.fullname);
        
     
     }   
   system.debug('######'+check);
   system.debug('-4---------');    
    }
    
    
    public List<string> getprofilelist()
    {
     flag= true;
     return check;
    }
    
    /*public static void retrievemetadata()
    {
     MetaDataRetrieveZip = null;
     // MetadataFiles = null;
     MetadataService.MetadataPort service = createService();     
     MetadataService.RetrieveRequest retrieveRequest = new MetadataService.RetrieveRequest();
     retrieveRequest.apiVersion = 25;
        retrieveRequest.packageNames = null;
        retrieveRequest.singlePackage = true;
        retrieveRequest.specificFiles = null;
        retrieveRequest.unpackaged = new MetadataService.Package_x();
        retrieveRequest.unpackaged.types = new List<MetadataService.PackageTypeMembers>();
        retrieveRequest.unpackaged.objectPermissions = new List<MetadataService.ProfileObjectPermissions>();
        MetadataService.PackageTypeMembers packageType = new MetadataService.PackageTypeMembers();
       packageType.name = MetaDataType; 
        packageType.members = new String[] { 'Admin' };
        retrieveRequest.unpackaged.types.add(packageType);
         MetadataService.ProfileObjectPermissions profileobjectpermission = new MetadataService.ProfileObjectPermissions();
         profileobjectpermission.object_x='Account';
         retrieveRequest.unpackaged.objectPermissions.add(profileobjectpermission); 
        AsyncResult = service.retrieve_x(retrieveRequest);
        system.debug('%%%%%%%%%%%%%'+AsyncResult.state);
      
     }
     */
     
   
   public void Updatemetadata()
   {
   MetaDataRetrieveZip = null;
      MetadataService.MetadataPort service = createService(); 
      MetadataService.UpdateMetadata ut= new MetadataService.UpdateMetadata();
      MetadataService.profile profile = new MetadataService.profile();
      ut.metadata = new MetadataService.Metadata();
      asyncresultid = '';
      //profile profile= new profile();
      profile.ObjectPermissions = new List<MetadataService.ProfileObjectPermissions>();
      MetadataService.ProfileObjectPermissions objectpermisiionforprofile = new MetadataService.ProfileObjectPermissions();
      objectpermisiionforprofile.object_x='Rule__c';
      objectpermisiionforprofile.allowCreate = true;
      objectpermisiionforprofile.allowDelete = true;
      objectpermisiionforprofile.allowEdit = false;
      objectpermisiionforprofile.allowRead = false;
      objectpermisiionforprofile.modifyAllRecords = false;
      objectpermisiionforprofile.viewAllRecords = false;
      profile.objectPermissions.add(objectpermisiionforprofile);
     //profile.fullName='Custom: Marketing Profile1';
     //profile.userLicense='Salesforce';
     
      system.debug('@@@@@'+profile.objectPermissions);
    
     ut.currentName='test profile 2';
     ut.metadata= profile;
      results = service.updateMetadata(new List<MetadataService.updateMetadata> {ut});
        asyncresultid = results[0].id;
       system.debug('###########'+results[0].state);
       system.debug('###########'+results[0].id);
       system.debug('-5---------');    
       system.debug('##############'+asyncresultid );
       //checkAsyncRequest();
   
   }
   
     public PageReference checkAsyncRequest()
    {
        // Check the status of the retrieve request
        seconds = seconds + 5;
        system.debug('%%%%%%%%%%%'+seconds );
        system.debug('%%%%%%%%%'+asyncresultid);
        system.debug('-6---------');    
        
        system.debug('%%%%%%%%%'+ '^^^^^ '+asyncresultid);
        st.add(asyncresultid);
        system.debug('%%%%%%%%%'+st[0] + '^^^^^ '+asyncresultid);
        MetadataService.MetadataPort service = createService();
     
        MetadataService.AsyncResult[] aysncResults = service.checkStatus(st);
        //system.debug('*************'+results[0].Id);
        //system.debug('^^^^^^^^^'+results[0].state);
        if(aysncResults[0].state == 'done')
        {
            // Errors?
            if(aysncResults[0].state == 'Error')
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, aysncResults[0].message));
                AsyncResult = null;             
            }
            else
            {
                // Place Base64 encoded zip data onto the page for the JSZip library to handle
               // MetadataService.RetrieveResult retrieveResult = service.checkRetrieveStatus( st[0].id);
               // MetaDataRetrieveZip = retrieveResult.zipFile;
               // MetadataFiles = new List<MetadataFile>();
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Expanding...'));
                AsyncResult = null;
                system.debug('----asyncresult-----');
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'updating metadata...'));
            system.debug('*******************'+st);
        }   

        return null;
    }
    


}