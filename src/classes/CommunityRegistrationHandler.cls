global with sharing class CommunityRegistrationHandler implements Auth.RegistrationHandler
{
// See: http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_auth_plugin.htm

global User createUser(Id portalId, Auth.UserData data)
{
        debug('createUser',data);

// TODO - replace this primitive Contact search with your own implementation
List<Contact> contacts = [SELECT Id FROM Contact WHERE Email = :data.Email ORDER BY CreatedDate DESC];
Contact contact = contacts.isEmpty() ? null : contacts[0];

        if (contact==null)
        {
            throw new CommunityRegistrationHandlerException('Unable to find a contact for this email address: ' + data.Email);
        }
                
        List<User> users = [SELECT Id,Email,Username,FirstName,LastName,Alias,CommunityNickname,ProfileId,
         ContactId,LocaleSidKey,LanguageLocaleKey,TimeZoneSidKey,EmailEncodingKey FROM User WHERE ContactId = :contact.Id];
User user = users.isEmpty() ? null : users[0];

        if(user==null)
        {
List<Profile> profiles = [SELECT Id FROM Profile WHERE Name = 'High Volume Customer Portal'];
Profile profile = profiles.isEmpty() ? null : profiles[0];

if(profile==null)
throw new CommunityRegistrationHandlerException('Could not find a Community user profile');

// TODO nickname/alias collision avoidance
String alias = data.email.replace('@', '').substring(0, 8);
String nickname = data.attributeMap.get('display_name');

user = new User(
Email = data.email,
Username = data.email,
Alias = alias,
CommunityNickname = nickname,
ProfileId = profile.Id,
ContactId = contact.Id
);
        }

updateUserSobject(user,data);

        return user;
    }
    
    global void updateUser(Id userId, Id portalId, Auth.UserData data)
    {
        debug('updateUser',data);
        User user = new User(Id=userId);
        updateUserSobject(user,data);
        update user;
    }

void updateUserSobject(User user, Auth.UserData data)
{
        user.FirstName = data.firstName;
        user.LastName = data.lastName;
        user.LocaleSidKey = data.locale;
        user.LanguageLocaleKey = data.attributeMap.get('language');
        user.TimeZoneSidKey = 'Europe/London'; // TODO
        user.EmailEncodingKey = 'ISO-8859-1';
}


void debug(String context,Auth.UserData data)
{
system.debug('§ ' + context);
        // Useful data which you may want to store or make use of:
system.debug('§ organization_id ' + data.attributeMap.get('organization_id'));
system.debug('§ user_id ' + data.attributeMap.get('user_id'));
system.debug('§ username ' + data.attributeMap.get('username'));
}

    class CommunityRegistrationHandlerException extends Exception{}
    

}