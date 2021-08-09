/**
 * Created by shyrbik on 09.08.2021.
 */

public with sharing class QueuebleClass implements Queueable{
    List<Id> idChangedBillAddress;

    public QueuebleClass(List<Id> listOfId){
        System.debug('init list of Id in QueuebleClass');
        this.idChangedBillAddress = listOfId;

    }

    public void execute(QueueableContext QB){
        System.debug('start execution QueuebleClass');
        List<Contact> contactsForChange = new List<Contact>();

        contactsForChange = [SELECT Id, Is_Synced__c, Processed_By_Future__c FROM Contact WHERE AccountId IN :idChangedBillAddress];

        for (Contact cont : contactsForChange) {
            cont.Is_Synced__c = false;
            cont.Processed_By_Queue__c = true;
            System.debug('Update contact with Id= ' + cont.Id);
        }

        System.debug('End of updating Is_Synced__c Processed_By_Future__c fields in Contacts');
    }



}