/**
 * Created by shyrbik on 08.08.2021.
 */
public class BatchClassAccBillAddToConcMailAdd implements Database.Batchable<SObject>, Database.Stateful{
    public Integer numberOfProcessedRecords = 0;
    public Integer numberOfBatch = 0;

    public Database.QueryLocator start(Database.BatchableContext bc){
        //Create Batch Job which select all tasks with Is Synced = false
        return Database.getQueryLocator('SELECT Id, Contact.MailingAddress FROM Contact WHERE Contact.Is_Synced__c = FALSE');
    }

    // по умолчанию в него передаются пачки по 200 записей
    public void execute(Database.BatchableContext bc, List<Contact> contacts){

        for(Contact cont: contacts){
            //Batch should copy from Account.BillingAddress to Contact.MailingAddress
            cont.MailingAddress = cont.Account.BillingAddress;
            //Update Account field Updated By Contact = true;
            cont.Account.Updated_By_Contact__c = true;
            numberOfProcessedRecords++;
        }

        update contacts;
        numberOfBatch++;
    }

    public void finish(Database.BatchableContext bc){
        System.debug('numberOfBatch = '+numberOfBatch);
        System.debug('numberOfProcessedRecords = '+numberOfProcessedRecords);
    }
/*
//вызов нашего баch
    Id jobId = Database.executeBatch(new BatchClassAccBillAddToConcMailAdd(), 10);
    //провек
    System.debug([SELECT Id, Status, NumberOfErrors, TotalJobItems, JobItemsProcessed
    FROM AsyncApexJob WHERE Id = : jobId]);

    //Второй параметр 10 определяет объем партий, по умолчанию 200, диапазон 1-2000

*/

}