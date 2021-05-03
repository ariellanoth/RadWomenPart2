@isTest
public with sharing class RecipeController_Test {
    @testSetup public static void testSetup(){
        List<Recipe__c> testRecipes = TestFactory.insertRecipes(3);
        List<Ingredient__c> testIngredients = TestFactory.insertIngredients(3, testRecipes);

    }
    @isTest public static void testAddIngredient(){
        List<Recipe__c> recipeList = [SELECT ID FROM Recipe__c];
        system.assertEquals(FALSE, recipeList.isEmpty());
        test.startTest();
        RecipeController.addIngredient('Fancy Validation Name', 3, 'Cups', recipeList[0].Id);
        test.StopTest();

        List<Ingredient__c> ingredientInserted = [SELECT ID FROM Ingredient__c WHERE Name = 'Fancy Validation Name' ];
        system.assertEquals(1, ingredientInserted.size());
    }
}
