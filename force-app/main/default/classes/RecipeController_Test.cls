@isTest
public class RecipeController_Test {
    @testSetup public static void testSetup(){
     
    
        List<Recipe__c> testRecipes = TestFactory.insertRecipes(4);
        system.assertEquals(3, testRecipes.size());
        List<Ingredient__c> testIngredients = TestFactory.insertIngredients(4, testRecipes);
        system.assertEquals(9, testIngredients.size());
        
    }
    @isTest public static void testAddIngredient(){
        List<Recipe__c> recipeList = [SELECT ID FROM Recipe__c];
        system.assertEquals(3, recipeList.size());
        test.startTest();
        RecipeController.addIngredient('Fancy Validation Name', 3, 'Cups', recipeList[0].Id);
        test.StopTest();

        List<Ingredient__c> ingredientInserted = [SELECT ID FROM Ingredient__c WHERE Name = 'Fancy Validation Name' ];
        system.assertEquals(1, ingredientInserted.size());
    }
    @isTest public static void testGroceryList(){
        List<Recipe__c> recipeList = [SELECT ID FROM Recipe__c];
        system.assertEquals(3, recipeList.size());
        test.startTest();
        List<Ingredient__c> groceryList = RecipeController.generateGroceryList(recipeList[0].Id);
        test.StopTest();
        
        system.assertEquals(3, groceryList.size());

       

    }
    @isTest public static void testScaleRecipe(){
        List<Recipe__c> recipeList = [SELECT ID FROM Recipe__c];
        system.assertEquals(3, recipeList.size());
        Map<Id, Ingredient__c> ingredientsBefore = new Map<Id, Ingredient__c>([SELECT ID, Measurement__c FROM Ingredient__c WHERE Recipe__c = : recipelist[0].id]);
        system.assertEquals(3, ingredientsBefore.size());
        test.startTest();
        List<Ingredient__c> ingredientList = RecipeController.scaleRecipeForServings(recipeList[0].Id, 4);
        test.stopTest();
        
        for(Ingredient__c ingredientAfter : ingredientList){
            system.assertEquals((ingredientsBefore.get(ingredientAfter.Id).Measurement__c * 4), ingredientAfter.Measurement__c);
        }
        
    }
    @isTest public static void testScaleRecipeNoChange(){
        List<Recipe__c> recipeList = [SELECT ID FROM Recipe__c];
        system.assertEquals(3, recipeList.size());
        Map<Id, Ingredient__c> ingredientsBefore = new Map<Id, Ingredient__c>([SELECT ID, Measurement__c FROM Ingredient__c WHERE Recipe__c = : recipelist[0].id]);
        system.assertEquals(3, ingredientsBefore.size());
        test.startTest();
        List<Ingredient__c> ingredientList = RecipeController.scaleRecipeForServings(recipeList[0].Id, 1);
        test.stopTest();
        
        for(Ingredient__c ingredientAfter : ingredientList){
            system.assertEquals(ingredientsBefore.get(ingredientAfter.Id).Measurement__c, ingredientAfter.Measurement__c);
        }
        
    }
    @isTest public static void testGetAllRecipes(){
        List<Recipe__c> recipeList = new List<Recipe__c>();
        test.startTest();
        
        recipeList = RecipeController.getAllRecipes();
        
        test.stopTest();
        
        system.assertEquals(3, recipeList.size());
    }
    @isTest public static void testNoSearchTerm(){
        List<Recipe__c> searchResults = new List<Recipe__c>();
        test.startTest();
        searchResults = RecipeController.searchRecipes('');
        test.stopTest();
        
        system.assertEquals(3, searchResults.size());
        
    }
    @isTest public static void testWithSearchTerm(){
        List<Recipe__c> searchResults = new List<Recipe__c>();
        Recipe__c newRecipe = new Recipe__c();
        newRecipe.Name = 'Blueberry Cake';
        newRecipe.Active_Time__c = 1; 
        newRecipe.Active_Time_Units__c = 'Hour';
        newRecipe.Description__c = 'Fancy Cake to search for';
        newRecipe.Servings__c = 3;
        
        test.startTest();
        insert newRecipe;
        searchResults = RecipeController.searchRecipes('Cake');
        test.stopTest();
        
        system.assertEquals(1, searchResults.size());
        
    }

}