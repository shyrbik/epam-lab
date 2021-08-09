trigger AccountTrigger on Account (
        before insert,
        before update,
        before delete,
        after insert,
        after update,
        after delete,
        after undelete) {

    //тут посути ничего не изменяется, один раз написали и забыли, все  изменения внедряются дальше в ХЕНДЛЕРЕ
    //и реализуются в ХЕЛПЕРЕ
    //В идеале в Бефо нужно реализовывать Валидацию и Заполнение дефолтными полями , которые мы не можем реализовать стандартными
    //средствами Сейлфорс
    if(Trigger.isBefore && Trigger.isInsert) {
        System.debug('Before insert Account Trigger is starting to work - handleBeforeInsert');
        AccountTriggerHandler.handleBeforeInsert(Trigger.new);
    }

    if(Trigger.isBefore && Trigger.isUpdate) {
        AccountTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
    }

    if(Trigger.isBefore && Trigger.isDelete) {
        AccountTriggerHandler.handleBeforeDelete(Trigger.old, Trigger.oldMap);
    }

    if(Trigger.isAfter && Trigger.isInsert) {
        System.debug('Is After Insert Account Trigger is starting to work - handleAfterInsert');
        AccountTriggerHandler.handleAfterInsert(Trigger.new, Trigger.newMap);
    }

    if(Trigger.isAfter && Trigger.isUpdate) {
        System.debug('Is After Update Account Trigger is starting to work - handleAfterUpdate');
        AccountTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
    }

    if(Trigger.isAfter && Trigger.isDelete) {
        AccountTriggerHandler.handleAfterDelete(Trigger.old, Trigger.oldMap);
    }

    if(Trigger.isAfter && Trigger.isUndelete) {
        AccountTriggerHandler.handleAfterUndelete(Trigger.new, Trigger.newMap);
    }


}