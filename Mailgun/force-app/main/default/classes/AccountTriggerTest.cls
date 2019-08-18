@isTest
public class AccountTriggerTest {
    @isTest
    static void test1(){
        List<Account> newAccnt = new List<Account>();
        for(integer i=1; i < 6; i++){
            Account acc = new Account(Name = 'Test ' + i +' Corp.', Rating='Hot', email__c = 'test'+i+'@gmail.com');
            newAccnt.add(acc);
        }
        insert newAccnt;
        List<Account> insertedAccount = [Select Id from Account where Rating='Hot' AND Name like 'Test %'];
        System.assertEquals(5, insertedAccount.size());
    }
    
    @isTest
    static void test2(){
        List<Account> newAccnt = new List<Account>();
            Account acc = new Account(Name = 'Test123 Corp.', Rating='Hot', email__c = 'test1@gmail.com');
        	insert acc;
        	acc.Email__c = 'bats0077@gmail.com';
         	update acc;
        
        System.assertEquals('bats0077@gmail.com', [Select Email__c from Account where Id =: acc.id][0].Email__c);
        
    }
    
}