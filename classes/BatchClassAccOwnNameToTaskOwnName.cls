public without sharing class BatchClassAccOwnNameToTaskOwnName implements Database.Batchable<SObject>, Database.Stateful{
    public Integer numberOfProcessedRecords = 0;
    public Integer numberOfBatch = 0;

    public Database.QueryLocator start(Database.BatchableContext bc){
        //Create Batch Job which select all tasks with Is Synced = false
        return Database.getQueryLocator('SELECT Id, Task.Is_Synced__c FROM Task WHERE Task.Is_Synced__c = FALSE');
    }
    //Выполняется столько раз, сколько в него передано партий
    // по умолчанию в него передаются пачки по 200 записей
    public void execute(Database.BatchableContext bc, List<Task> tasks){

        for(Task tsk: tasks){
            //Batch should copy from Account.Owner.Name to Task.AccountOwner__c
            tsk.Account_Owner__c = tsk.Account.Name;
            //Set Task.IsSynced__c = true
            tsk.Account.Updated_By_Task__c = true;
            //Update Account field Updated By Task = true;
            numberOfProcessedRecords++;
        }

        update tasks;
        numberOfBatch++;
    }

    public void finish(Database.BatchableContext bc){
        System.debug('numberOfBatch = '+numberOfBatch);
        System.debug('numberOfProcessedRecords = '+numberOfProcessedRecords);
    }
/*
//вызов нашего баch
    Id jobId = Database.executeBatch(new BatchClassAccOwnNameToTaskOwnName(), 10);
    //провек
    System.debug([SELECT Id, Status, NumberOfErrors, TotalJobItems, JobItemsProcessed
    FROM AsyncApexJob WHERE Id = : jobId]);

    //Второй параметр 10 определяет объем партий, по умолчанию 200, диапазон 1-2000

*/

}