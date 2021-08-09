global with sharing class AccountTriggerHelper {

    public static void logSomething() {
        System.debug('test trigger pattern');

    }

    @Future
    public static void createTaskForNewAcc(Set<Id> setNewAccId) {
        System.debug('Future method createTaskForNewAcc is working ');
        List<Task> newTaskList = new List<Task>();

        List<Account> newAcc = [SELECT Id, Name FROM Account WHERE Id IN : setNewAccId];

        for(Account acc: newAcc){
            newTaskList.add(new Task(Subject='Negotiations with ' + acc.Name,  WhatId = acc.Id, Is_Synced__c = false));
            System.debug('Add new Task for Account Name = ' + acc.Name);
        }

         if(newTaskList.size()>0){
            System.debug('Number of inserting Tasks  ' + newTaskList.size());
            insert newTaskList;
        }

    }

    public static List<Id> idContactWithChangedBillingAddress(List<Account> newAccList, List<Account> oldAccList) {

        List<Id> idChangedBillAddress = new List<Id>();

        for (Integer i = 0; i < newAccList.size(); i++) {
            //Compare old and new values

        if(newAccList.get(i).BillingAddress != oldAccList.get(i).BillingAddress){
            idChangedBillAddress.add(newAccList.get(i).Id);
            System.debug('Find  idChangedBillAddress = ' + newAccList.get(i).Id);
            }

        }
        System.debug('Number of changed BillingAddress fields' + idChangedBillAddress.size());

        if(idChangedBillAddress.size() > 0) {
            System.debug('Return list Id contacts for update');
            return idChangedBillAddress;
        }

        return null;

    }


    @Future
    public static void updateContact(List<Id> idChangedBillAddress) {
        if (idChangedBillAddress != null) {
            System.debug('Starting future method updateContact');
            List<Contact> contactsForChange = new List<Contact>();

            contactsForChange = [SELECT Id, Is_Synced__c, Processed_By_Future__c FROM Contact WHERE AccountId IN :idChangedBillAddress];

            for (Contact cont : contactsForChange) {
                cont.Is_Synced__c = false;
                cont.Processed_By_Future__c = true;
                cont.Processed_By_Queue__c = true;
                System.debug('Update contact with Id= ' + cont.Id);
            }

            System.debug('End of updating Is_Synced__c Processed_By_Future__c fields in Contacts');

            //Апдейтать записи не нужно, так как мы их перезаписали прямо в созданные поля


        }

    }

}