public with sharing class ObjectDataController {
        //Method to get all object API names and label
        @AuraEnabled
        public static Map<String, String> getObjects() {
            Map<String, SObjectType> sObjects = Schema.getGlobalDescribe();
            Map<String, String> resultMap = new Map<String, String>();
            for (String apiName : sObjects.keySet()) {
                resultMap.put(sObjects.get(apiName).getDescribe().getLabel(), sObjects.get(apiName).getDescribe().getName());
            }
            return resultMap;
        }
        
        //Method to get all attributes API name and lable of selected object
        @AuraEnabled
        public static Map<String, String> getAttributes(String objectName) {
              Map <String, Schema.SObjectType> objectMap = Schema.getGlobalDescribe();
            Schema.SObjectType sobjType = objectMap.get(objectName);
            Schema.DescribeSObjectResult description = sobjType.getDescribe();
            Map<String, Schema.SObjectField> fieldMap = description.fields.getMap();
            
            Map<String, String> resultMap = new Map<String, String>();
            
            for(String fName : fieldMap.keySet()) {
                Schema.SObjectField field = fieldMap.get(fName);
                Schema.DescribeFieldResult fieldDescription = field.getDescribe();
                resultMap.put(fieldDescription.getLabel(), fieldDescription.getName());
            }
            return resultMap;
        }
        
        //Method to Generate and Run Query
        @AuraEnabled
        public static List<sObject> runSOQLQuery(String objectName, List<String> fields) {
            String fieldList = String.join(fields, ', ');
            String query = 'SELECT ' + fieldList + ' FROM ' + objectName;
            return Database.query(query);
        }
}