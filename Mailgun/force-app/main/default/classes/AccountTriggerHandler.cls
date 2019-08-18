public class AccountTriggerHandler {
    public static boolean isExecuting = false;
       @TestVisible
    public void handleAfterInsert(List<Account> lstNewAccounts){
        system.debug('=== Inside AfterInsert ===');
        Map<String,Id> AccountEmails = new Map<String,Id>();
        for(Account accnts : lstNewAccounts){
            if(GlobalUtility.shouldEmailAccount(accnts) && !AccountEmails.containsKey(accnts.Email__c)){
                AccountEmails.put(accnts.Email__c,accnts.Id);
            }
        }
        if(AccountEmails.size() > 0 ){
            system.debug('=== Calling prepAndSendEmail '+AccountEmails);
            GlobalUtility.prepAndSendEmail(AccountEmails);
            AccountEmails.clear();
        }
    }
       @TestVisible
    public void handleAfterUpdate(List<Account> lstNewAccounts, Map<Id, Account> oldMap){
                system.debug('=== Inside AfterUpdate ===');
                system.debug('=== Status of isExecuting ===' +isExecuting);
        if(!isExecuting){
            isExecuting = true;
            Map<String,Id> AccountEmails = new Map<String,Id>();
            for(Account accnts : lstNewAccounts){
                if(GlobalUtility.shouldEmailAccount(accnts) && oldMap.get(accnts.Id).Email__c != accnts.Email__c){
                    AccountEmails.put(accnts.Email__c, accnts.Id);
                }
            }
            if(AccountEmails.size() > 0 ){
                system.debug('=== Calling prepAndSendEmail '+AccountEmails);
                GlobalUtility.prepAndSendEmail(AccountEmails);
                AccountEmails.clear();
            }
            
        }
        
    }
    
}