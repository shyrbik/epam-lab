

public with sharing class AccountTriggerHandler {
    //Здесь мы храним только вызовы методов, порядок вызова методов
    //В бефор триггерах не нужно вызывать ДМЛ операций для апдейта, если нам нужно что то изменить,
    // мы просто напрямую в цикле меняем

    public static void handleBeforeInsert(List<Account> newAccList) {
        AccountTriggerHelper.logSomething();
    }

    public static void handleBeforeUpdate(List<Account> newAccList, Map<Id, Account> newAccMap,
                                List<Account> oldAccList, Map<Id, Account> oldAccMap) {
        //Второе задание по обновлению контактов
        System.debug('Start to update Contacts List where related Accounts Billing Address was changed');
        //в качестве параметра передаем результат метода idContactWithChangedBillingAddress
        AccountTriggerHelper.updateContact(AccountTriggerHelper.idContactWithChangedBillingAddress(newAccList, oldAccList));

        //Same logic for Queueble Job
        Id jobId = System.enqueueJob(new QueuebleClass(AccountTriggerHelper.idContactWithChangedBillingAddress(newAccList, oldAccList)));


    }

    public static void handleBeforeDelete(List<Account> oldAccList, Map<Id, Account> oldAccMap) {

    }

    ///а в Афтер методах ДМЛ записи нужно, так как после афтера они сохранены в базу данных,
    // (7 шаг в ордер экзекьюшен)

    public static void handleAfterInsert(List<Account> newAccList, Map<Id, Account> newAccMap) {
        //create array of new Acc Id for future method
        //первое задание по добавлению тасок к новым аккаунтам
        System.debug('createTaskForNewAcc is starting to work');
        AccountTriggerHelper.createTaskForNewAcc(newAccMap.keySet());

    }


    public static void handleAfterUpdate(List<Account> newAccList, Map<Id, Account> newAccMap,
            List<Account> oldAccList, Map<Id, Account> oldAccMap) {

    }

    public static void handleAfterDelete(List<Account> oldAccList, Map<Id, Account> oldAccMap) {

    }

    public static void handleAfterUndelete(List<Account> newAccList, Map<Id, Account> newAccMap) {

    }


}