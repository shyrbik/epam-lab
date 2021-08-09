/**
 * Created by shyrbik on 07.08.2021.
 */

public with sharing class SingletonTriggerHelper {
    private static Boolean singleFlag = true;

    public static void onAfterInsertAction(Account[] newAccounts){

        System.debug('singleFlag = ' + singleFlag);
        if(singleFlag){
            //do something
            System.debug('SingletonTriggerHelper is running');
            singleFlag = false;
            System.debug('singleFlag = ' + singleFlag);
        }
    }

}