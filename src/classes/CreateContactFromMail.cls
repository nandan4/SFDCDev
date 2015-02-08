/*
    Author          : Nandan Narasappa
    Date Created    : 22/06/2013
    Description     : Inbound Email Handler for Creating Contact
*/

public class CreateContactFromMail implements Messaging.InboundEmailHandler {
    
    /*  
        @Method <This method handleInboundEmail is used to handle incoming mail and createContact>
        @param <email - Messaging.InboundEmail
                envelope - Messaging.InboundEnvelope>
        @return <Messaging.InboundEmailResult>
        @throws exception - <Method is throwing exception which is handled by try-catch block>
    */
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope){
        System.debug('** Email ==>'+email);
        System.debug('** Envelope ==>'+envelope);
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        SavePoint sPoint = Database.SetSavePoint();
        String subject = 'Create Contact';
        
        try{
            List<String> body = email.plainTextBody.split('\\s');
            System.debug('** Text Body ==>'+body);
            if(email.subject.equalsIgnoreCase(subject) && !body.isEmpty()){            
                Contact con = new Contact();
                if(body.size() > 1){
                    con.FirstName = body[0];
                    con.LastName = body[1];
                }
                else{
                    con.LastName = body[0];
                }
                System.debug('** Contact From Mail ==>'+con);
                Database.SaveResult saveResult = Database.insert(con);
                if(saveResult.isSuccess()){
                    List<Attachment> attchaments = new List<Attachment>();
                    if(email.textAttachments != null){
                        for(Messaging.InboundEmail.TextAttachment txtAttachment : email.textAttachments){
                            Attachment attch = new Attachment();
                            attch.Name = txtAttachment.fileName ;
                            attch.Body = Blob.ValueOf(txtAttachment.body);
                            attch.ParentId = con.Id;
                            attchaments.add(attch);
                        }
                    }
                    
                    if(email.binaryAttachments != null){
                        for(Messaging.InboundEmail.BinaryAttachment blobAttachment : email.binaryAttachments ){
                            Attachment attch = new Attachment();
                            attch.Name = blobAttachment.fileName ;
                            attch.Body = blobAttachment.body;
                            attch.ParentId = con.Id;
                            attchaments.add(attch);
                        }
                    }
                    if(!attchaments.isEmpty()){
                        Database.SaveResult[] attcResult = Database.insert(attchaments);
                        for(Database.SaveResult sResult : attcResult){
                            if(!sResult.isSuccess()){
                                Database.Rollback(sPoint);  
                                result.success = false;
                                result.message = 'Attachment Upload Failed';  
                            }
                        }
                    }
                }
                else{
                    result.success = false;
                    result.message = 'Contact Creation Failed'; 
                }
            }
        }
        catch(Exception exp){
            Database.Rollback(sPoint);
            result.success = false;
            result.message = ' Error Message : ' + exp.getMessage() + ' At Line Number : ' + exp.getLineNumber() + ' StackTrace : ' + exp.getStacktraceString();     
        }
        return result;        
    }
}