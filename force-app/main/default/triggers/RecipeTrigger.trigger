trigger RecipeTrigger on Recipe__c (before insert, after insert, before update, after update){
    if(trigger.isBefore){
        if(trigger.isInsert){
            recipeTriggerHandler.isRecipeDraft(trigger.New);
            recipeTriggerHandler.determineComplexity(trigger.New);
        }
        if(trigger.isUpdate){
            recipeTriggerHandler.isRecipeDraft(trigger.New);
            recipeTriggerHandler.determineComplexity(trigger.New);
        }
    }
    if(trigger.isAfter){
        if(trigger.isUpdate){
            recipeTriggerHandler.createReviewTask(trigger.New);
        }
    }

}