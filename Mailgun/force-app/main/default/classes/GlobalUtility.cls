public class GlobalUtility {
    
    //declare variables so that code doesn't need changing 
    
    private static String MSG_SUBJECT		=	'You are most valuable "Corporation" customer.';
    private static String MSG_BODY			=	'You are unique and valuable for our business, your email is safe with us.';
    private static String MG_SENDER			=	'no-reply@sandboxc82d721943d940c69ccb813d6a98af83.mailgun.org';
    private static String MG_METHOD_POST 	=	'POST';
    private static String MG_URL			=	'callout:MGEndPoint/messages';
    private static String FLTR				= 	'Corp.';
    private static Integer MG_TIMEOUT		= 	 60000;
    
    // method returns true when email is not blank and contains defined filter word
    // used in AccountTriggerHandler class
    public static boolean shouldEmailAccount(Account accnts)
    {
        return (
            String.isNotBlank(accnts.Email__c) &&
            accnts.Name.contains(FLTR)
        );
    }
    
    @future(callout=true)
    public static void prepAndSendEmail(Map<String,Id> emailAndIds)
    {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(MG_URL);
        req.setMethod(MG_METHOD_POST);
        req.setBody(populateDetails(FLTR, emailAndIds));
        req.setTimeout(MG_TIMEOUT);
        system.debug('=== Calling http send '+req);
        try{
            HttpResponse res = new Http().send(req);
            if(res.getStatusCode() != 200){
                system.debug('=== Some error calling exception handling '+res);               
                throw new DeliveryException('=== Enable to finish this request===' + res.getBody() + res.getStatus() + res.getStatusCode());
            }
			system.debug('=== Call complete ==='+res);               
            
        }
        catch(Exception e){
            // insert exception as a task for admin to check, this can be custom object with more details as to class name, payload etc.
            Task t = new Task();
            t.OwnerId =  UserInfo.getUserId();
            t.Subject = 'Email failure during MailGun callout - check urgently';
            t.Status = 'Not Started';
            t.Priority = 'High';
            t.ActivityDate = system.today();
            t.Description = 'Error Details are : \r\n Line number -' + e.getLineNumber() +'\r\n StackTrace -' +  e.getStackTraceString() +'\r\n Error Message -' + e.getMessage() +'\r\n' + e;
            insert t;
        }
    }
    
    //method populates required parameter and returns merged string of body contains To Ids, From Ids, subject etc
    //added recipient-variable to call batch api and not to expose email ids in To parameter.
    public static String populateDetails(String str, Map<String,Id> emailId){
        List<String> keys = new List<String>(emailId.keySet());
        string toEmail = string.join(keys,',');
        String rvar = JSON.serialize(emailId); // convert to json as per MailGun to represent values and unique Ids
        String sBody =  'from=' + MG_SENDER + 
            '&to=' + toEmail + 
            '&subject=' + MSG_SUBJECT + 
            '&html=' + MSG_BODY + 
            '&recipient-variables=' + rvar ;
        return sBody;
    }
    public class DeliveryException extends Exception {}
    
    
}