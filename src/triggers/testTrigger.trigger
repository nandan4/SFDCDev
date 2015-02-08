trigger testTrigger on Account (before insert,before update,after insert,after update){
    /*
    TestController tc = new TestController(Trigger.oldMap,Trigger.NewMap,Trigger.old,Trigger.New);
    for(Account acc : Trigger.New){
        Account ac = [SELECT Id,Name FROM Account WHERE Id =: acc.id];
        System.debug('** account ==>'+ac);
    }*/
    Set<Id> accSet = new Set<Id>();
    Map<Id,Account> accMap = new Map<Id,Account>();
    for(Account acc : Trigger.New){
        accMap.put(acc.id,acc);
    }
    //TestController.testAddError(accMap);
    /*
    Account ab ; 
    for(Account acc: Trigger.New){
        System.debug('** Loop **'); 
        ab = new Account(Id = '0019000000FT6Ey');
        ab.Rating = 'Hot';       
        System.debug('** ab ==>'+ ab); 
    }
    update ab;
    */
    
    /*
    if(Trigger.isAfter && Trigger.isInsert){
        for(Account acc : trigger.new){
            PageReference pdf = Page.PdfGeneratorTemplate;
            pdf.getParameters().put('id',acc.id);
            Blob body;

            try {
                body = pdf.getContent();
            } 
            catch (VisualforceException e) {
                body = Blob.valueOf('Some Text');
            }
            String email = 'nandan.narasappa@accenture.com';
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName('testPdf.pdf');
            attach.setInline(false);
            attach.Body = body;

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setToAddresses(new String[] { email });
            mail.setSubject('PDF Email Demo');
            mail.setHtmlBody('Here is the email you requested! Check the attachment!');
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 

            // Send the email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email with PDF sent to '+ email));
        }
     */
    CollaborationGroup grp = [SELECT Id,Name,OwnerId FROM CollaborationGroup WHERE Id = '0F990000000CEtk'];
    System.debug('** grp ==> '+ grp );
    if(Trigger.isAfter && Trigger.isInsert){ 
        for(Account acc : Trigger.New){
            /*
            try{
                acc.addError('** Error Logged **');
            }
            catch(Exception exp){
                System.debug('** exp ==>'+ exp);
            }
            */
            FeedItem post = new FeedItem();
            post.ParentId = '0F990000000CEtk'; 
            post.Body = ' First Post : ' + acc.Name;
            post.CreatedById = grp.OwnerId;
            post.CreatedDate = System.now();
            System.debug('** post ==> '+ post); 
            insert post;
        }
    }
}