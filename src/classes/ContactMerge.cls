public class ContactMerge {

        //This class handles the heavy lifting of merging contacts. It can be called
        //from the VisualForce page for contact merge, or elsewhere.
        
        //min number of contacts that can be merged
        public final Integer MERGE_MINIMUM = 2;
        
        //max number of contacts that can be merged
        public final Integer MERGE_LIMIT = 3;
    
    //contact for the winning record
    public Contact winner {get; set;}
    
    //List for the losing records
    public List<Contact> losers {get; set;}
        
                
        //method to merge the winner and losers
        public boolean mergeContacts() {
                boolean successfulMerge = false;
                
                List<Account> winnerAccount = new List<Account>();
                Set<Id> loserAccountIds = new Set<Id>();
                List<Account> loserAccounts = new List<Account>();
                List<Account> loserAccountsToBeMerged = new List<Account>();
                List<Account> loserAccountsToBeDeleted = new List<Account>();
        
                Id winningAccountId = null;
                Boolean winnerAccountIsOneToOne = false;
                winner = [Select Account.Id,Account.Type from Contact where Id=:winner.Id];
                //get winner contact Account
                if (winner.AccountId!=null){
                        winnerAccount = [Select Id,Type,Name from Account where Id=:winner.accountid];
                }
                        
                if (winnerAccount.size()>0) {
                        
                        winningAccountId = winnerAccount[0].Id;
                        
                        if(winnerAccount[0].Type=='One-to-One Individual'){
                                winnerAccountIsOneToOne = true;
                        }
                        
                }        
                losers = [Select Account.Id,Account.Type from Contact where Id IN :losers];
                
                for(Contact thisloserContact : losers){
                        //don't try to merge null Accounts or Accounts that are the same as the winner's Account
                        if (thisloserContact.id!=null && thisloserContact.AccountId!=winner.AccountId){
                                loserAccountIds.add(thisloserContact.AccountId);
                        }
                }
                system.debug('losers: ' + loserAccountIds);
                system.debug('winneraccountid: ' + winner.AccountId);
                //get loser contact Accounts that should be merged out--only one-to-one accounts
                loserAccountsToBeMerged = [Select Id,Type,Name from Account where Id IN :loserAccountIds and Type= 'One-to-One Individual' and Name<>: 'Individual'];
                
                
                //one-to-one contacts each have an Account, so when merging Contacts we have to merge Accounts as well
                //we merge the Accounts first, if there are any one-to-one Accounts in the mix
                if(loserAccountsToBeMerged.size()>0){        
                                        
                        merge winnerAccount[0] loserAccountsToBeMerged;
                }
                
                //merge the contacts
                
                //there is a Contact delete trigger that deletes the one-to-one Account of a Contact after it is deleted
                //merge deletes the losing Contacts, so their Accounts get deleted, which causes errors
                //to get around this, we detach the Contacts for their Accounts before we merge
                
                //create new contacts for updating as the SOSL returned contacts have read-only fields on them
                Contact winnerMakePrivate = new Contact();
                if(winnerAccountIsOneToOne){                        
                        winnerMakePrivate = new Contact(Id = winner.id,AccountId = null);
                } else {
                        winnerMakePrivate = new Contact(Id = winner.id);
                }
                List<Contact> losersMakePrivate = new List<Contact>();
                
                for(Contact contactForUpdate : losers){                        
                        Contact loserMakePrivate = new Contact(id=contactForUpdate.id,accountId=null);
                        losersMakePrivate.add(loserMakePrivate);
                }
                        
                //set the account to null and mark private so that trigger won't reset the Account
                if (winningAccountId!=null && winnerAccountIsOneToOne){                        
                        update winnerMakePrivate;                        
                }
                
                if(losersMakePrivate.size()>0){
                        update losersMakePrivate;
                }

                merge winnerMakePrivate losersMakePrivate;
                
                //set the contact Account Id back to the winning Account Id
                if (winnerAccountIsOneToOne){
                        winnerMakePrivate.AccountId = winningAccountId;
                        //winnerMakePrivate.Private__c = false;
                        update winnerMakePrivate;
                }                
                system.debug('loserAccounts: ' + loserAccountsToBeDeleted);
                if(loserAccountsToBeDeleted.size()>0){
                        delete loserAccountsToBeDeleted;
                }
                successfulMerge = true;
                return successfulMerge;
        }
                
    //constructor for mergeSet class
    public ContactMerge(Contact winner, List<Contact> losers) {
                this.losers = losers;
                this.winner = winner;
    }
    
}