@isTest()
public class AccountTriggerHandlerTest {
    
    private static List<Account> createTestAccounts() {
        List<Account> newAccnt = new List<Account>();
        for(integer i=1; i < 5; i++){
            Account acc = new Account(Name = 'TestAccount' + i +' Corp.', Rating='Hot', email__c = 'test'+i+'@gmail.com');
            newAccnt.add(acc);
        }
        return newAccnt;
    }
    
    static testmethod void test1_success() {
		Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock('Success'));
        List<Account> newAcc = createTestAccounts();
        Insert newAcc;
        Test.stopTest();   
    }
    
    static testmethod void test2_failure() {
		Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock('Fail'));
        List<Account> newAcc = createTestAccounts();
        Insert newAcc;
        Test.stopTest();   
    }
    
     static testmethod void test3_success() {
		Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock('Success'));
        	List<Account> acc = createTestAccounts();
         system.debug(acc);
         for(Account a : acc){
             a.email__c = a.email__c + '.au';
         }
       	 
        Test.stopTest();   
    }
    
        static testmethod void test4_failure() {
		Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock('Failure'));
        	List<Account> acc = createTestAccounts();
         system.debug(acc);
         for(Account a : acc){
             a.email__c = a.email__c + '@g.au';
         }
       	 
        Test.stopTest();   
    }
    
}