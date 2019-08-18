trigger AccountTrigger on Account (after insert, after update) {
    AccountTriggerHandler handler = new AccountTriggerHandler();

    if (Trigger.isAfter && Trigger.isInsert)
    {
        handler.handleAfterInsert(Trigger.new);
    }

    else if (Trigger.isAfter&& Trigger.isUpdate)
    {
        handler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}