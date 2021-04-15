@isTest
public class RecipeTriggerHandler_Test {
    @testSetup 
    public static void setupMethod(){
        List<Recipe__c> testDraftRecipes = new List<Recipe__c>();
        integer noOfDraftRecipes = 0;
        while(noOfDraftRecipes < 150) {
            Recipe__c draftRecipe = new Recipe__c();
            draftRecipe.Name = 'Test Recipe ' + noOfDraftRecipes; 
            draftRecipe.Description__c = 'Test Recipe';
            noOfDraftRecipes++; 
            testDraftRecipes.add(draftRecipe);
            
        }
        //insert testDraftRecipes; 
        
        List<Recipe__c> testPublishedRecipes = new List<Recipe__c>();
        integer noOfPublishedRecipes = 0; 
        while(noOfPublishedRecipes < 150){
            Recipe__c publishedRecipe = new Recipe__c();
            publishedRecipe.Name = 'Published Recipe ' + noOfPublishedRecipes;
            publishedRecipe.Description__c = 'Published Recipe';
            publishedRecipe.Active_Time__c = noOfPublishedRecipes;
            publishedRecipe.Active_Time_Units__c = 'Minutes';
            publishedRecipe.Servings__c = noOfPublishedRecipes;
            noOfPublishedRecipes++; 
            testPublishedRecipes.add(publishedRecipe);
        }
        insert testPublishedRecipes; 
        
        List<Cookbook__c> testCookbooks = new List<Cookbook__c>();
        integer noOfCookbooks = 0; 
        while(noOfCookbooks < 10){
            Cookbook__c cookbookRec = new Cookbook__c();
            cookBookRec.Name = 'Test Cookbook ' + noOfCookbooks; 
            noOfCookbooks++; 
            testCookbooks.add(cookbookRec);
        }
        
        insert testCookbooks; 
        
        List<Recipe_Usage__c> testRecipeUsageRecords = new List<Recipe_Usage__c>();
        integer recipeIndex = 0; 
        
        
        for(Cookbook__c cookbookRecord : testCookbooks){
            Recipe_Usage__c testRecipeUsageRecord = new Recipe_Usage__c();
            testRecipeUsageRecord.Cookbook__c = cookbookRecord.Id; 
            //testRecipeUsageRecord.Recipe__c = testDraftRecipes[recipeIndex].Id;
            testRecipeUsageRecord.Recipe__c = testPublishedRecipes[recipeIndex].Id;
            testRecipeUsageRecords.add(testRecipeUsageRecord);
            recipeIndex++;
        }
        
        insert testRecipeUsageRecords; 
        
        
        
    }
    /*@isTest public static void validateSetAsDraftOnInsert(){
Recipe__c recipeRecord = new Recipe__c();
recipeRecord.Name = 'Test Recipe';
insert recipeRecord; 

Recipe__c updatedRecipe = [SELECT ID, Draft__c FROM Recipe__c WHERE Id = : recipeRecord.Id];

system.assertEquals(TRUE, updatedRecipe.Draft__c);
}*/
    @isTest public static void validateNotSetAsDraftOnInsert(){
        Recipe__c recipeRecord = new Recipe__c();
        recipeRecord.Name = 'Test Recipe';
        recipeRecord.Servings__c = 1;
        recipeRecord.Active_Time__c = 3; 
        recipeRecord.Active_Time_Units__c = 'Minutes';
        recipeRecord.Description__c = 'Test';
        insert recipeRecord; 
        
        Recipe__c updatedRecipe = [SELECT ID, Draft__c FROM Recipe__c WHERE Id = :recipeRecord.Id];
        system.assertEquals(FALSE, updatedRecipe.Draft__c);
    }
    /*@isTest public static void validateUnsetAsDraftOnUpdate(){
Recipe__c recipeRecord = [SELECT ID, Draft__c FROM Recipe__c WHERE Draft__c = TRUE LIMIT 1];
system.assertEquals(TRUE, recipeRecord.Draft__c);

recipeRecord.Active_Time__c = 1;
recipeRecord.Active_Time_Units__c = 'Hours';
recipeRecord.Servings__c = 3;

test.startTest();
update recipeRecord;
test.stopTest(); 

Recipe__c updatedRecipe = [SELECT ID, Draft__c FROM Recipe__c WHERE Id = : recipeRecord.Id];
system.assertEquals(FALSE, updatedRecipe.Draft__c);
}*/
    @isTest public static void validateComplexitySetAsSimpleOnInsert(){
        Recipe__c recipeRecord = [SELECT ID, Complexity__c FROM Recipe__c WHERE Complexity__c = 'Simple' LIMIT 1];
        system.assertEquals('Simple', recipeRecord.Complexity__c);
        
    }
    @isTest public static void validateComplexitySetAsModerateOnInsert(){
        Recipe__c recipeRecord = [SELECT ID, Complexity__c FROM Recipe__c WHERE Complexity__c = 'Moderate' LIMIT 1];
        system.assertEquals('Moderate', recipeRecord.Complexity__c);
        
    }
    @isTest public static void validateComplexitySetAsDifficultOnInsert(){
        Recipe__c recipeRecord = [SELECT ID, Complexity__c FROM Recipe__c WHERE Complexity__c = 'Difficult' LIMIT 1];
        system.assertEquals('Difficult', recipeRecord.Complexity__c);
        
    }
    @isTest public static void validateComplexitySetAsSimpleOnUpdate(){
        Recipe__c recipeRecord = [SELECT ID, Complexity__c FROM Recipe__c WHERE Complexity__c = 'Difficult' LIMIT 1];
        system.assertEquals('Difficult', recipeRecord.Complexity__c);
        
        recipeRecord.Active_Time_Units__c = 'Minutes';
        recipeRecord.Active_Time__c = 10; 
        recipeRecord.Servings__c = 1; 
        
        test.startTest();
        update recipeRecord; 
        test.stopTest();
        
        Recipe__c updatedRecipe = [SELECT ID, Complexity__c FROM Recipe__c WHERE id = : recipeRecord.Id];
        system.assertEquals('Simple', updatedRecipe.Complexity__c);
        
    }
    @isTest public static void validateComplexitySetAsModerateOnUpdate(){
        Recipe__c recipeRecord = [SELECT ID, Complexity__c FROM Recipe__c WHERE Complexity__c = 'Simple' LIMIT 1];
        system.assertEquals('Simple', recipeRecord.Complexity__c);
        
        recipeRecord.Servings__c = 100;
        recipeRecord.Active_Time_Units__c = 'Minutes';
        recipeRecord.Active_Time__c = 10; 
        
        test.startTest();
        update recipeRecord;
        test.stopTest();
        
        Recipe__c updatedRecipe = [SELECT ID, Complexity__c FROM Recipe__c WHERE id = : recipeRecord.Id];
        system.assertEquals('Moderate', updatedRecipe.Complexity__c);
        
    }
    @isTest public static void validateComplexitySetAsDifficultOnUpdate(){
        Recipe__c recipeRecord = [SELECT ID, Complexity__c FROM Recipe__c WHERE Complexity__c = 'Simple' LIMIT 1];
        system.assertEquals('Simple', recipeRecord.Complexity__c);
        
        recipeRecord.Active_Time_Units__c = 'Hours';
        recipeRecord.Active_Time__c = 30;
        
        test.startTest();
        update recipeRecord; 
        test.stopTest();
        
        Recipe__c updatedRecipe = [SELECT ID, Complexity__c FROM Recipe__c WHERE id = : recipeRecord.Id];
        system.assertEquals('Difficult', updatedRecipe.Complexity__c);
        
    }
    
    @isTest public static void validateTaskCreatedOnUpdate(){
        Recipe_Usage__c recipeUsageRecord = [SELECT ID, Recipe__c, Recipe__r.Draft__c, Cookbook__c FROM Recipe_Usage__c LIMIT 1];
        
        Recipe__c recipeRecord = recipeUsageRecord.Recipe__r; 
        recipeRecord.Name = 'Test';
        recipeRecord.Description__c = 'Test';
        recipeRecord.Servings__c = 3; 
        recipeRecord.Active_Time_Units__c = 'Minutes';
        recipeRecord.Active_Time__c = 3; 
        
        test.startTest();
        update recipeRecord; 
        test.stopTest();
        
        Task reviewTaskRecord = [SELECT ID FROM Task WHERE WhatId = : recipeUsageRecord.Cookbook__c];
        system.assert(reviewTaskRecord.Id != NULL);
        
        
    }
    @isTest public static void validateSObjectException(){
        Recipe__c recipeRecord = [SELECT ID FROM Recipe__c WHERE Draft__c = FALSE LIMIT 1];
        recipeRecord.Active_Time_Units__c = 'Ten';
        
        List<Boolean> exceptions = new List<Boolean>();
        test.startTest();
        try{
            update recipeRecord;
            
        }
        catch(sObjectException e){
            exceptions.add(true);
        }
        test.stopTest();
        system.assertNotEquals(NULL, exceptions);
        for(Boolean b : exceptions){
            system.assertEquals(True, b);
        }
    }
    @isTest public static void validateCustomException(){
        Recipe__c recipeRecord = new Recipe__c();
        recipeRecord.Name = 'Test Recipe';
        
        List<Boolean> exceptions = new List<Boolean>();
        test.startTest();
        try{
            insert recipeRecord;
        }
        catch(Exception e){
            if(e.getMessage().contains('you are missing a required field')){
                exceptions.add(True);
            }
        }
        test.stopTest();
        system.assertNotEquals(Null, exceptions);
        for(Boolean b : exceptions){
            system.assertEquals(True, b);
        }
    }
}