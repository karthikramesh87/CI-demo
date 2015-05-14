/**
Author         : Cognizant
Date           : 08/11/2012
Description    : To provide visibility of the products to the users based on ProductTeam records
*/

trigger aINS_ProductTeam on ProductTeam__c (after insert, after update, after delete) {
    
    /* List<MyProduct__Share> prodShareList = new List<MyProduct_Share>();
    Set<Id> majorProdIdSet = new Set<Id>();
    Set<Id> oldTeamMembersSet = new Set<Id>();
    Set<Id> childProdIdSet = new Set<Id>();
    Set<Id> minorProdIdSet = new Set<Id>();
    Map<Id,Id> prodGroupMap = new Map<Id,Id>();
    
    if(Trigger.isDelete){
        for(ProductTeam__c prodTeam: Trigger.New){
            // set for ProductGroup
            majorProdIdSet.add(prodTeam.MyProduct__c);
            
            //to capture all old version product team member id if product team got updated
            if(Trigger.isUpdate){
                ProductTeam__c.oldProdTeamVersion = Trigger.oldMap.get(prodTeam.Id);
                // prepare set of old users that needs to be removed from product share
                if(oldProdTeamVersion.User__c != prodTeam.User__c){
                    //for update
                    oldTeamMembersSet.add(oldProdTeamVersion.User__c);
                }
            }
        }
    }
    
    if(Trigger.isDelete){
        for(ProductTeam__c prodTeam: Trigger.Old){
            majorProdIdSet.add(prodTeam.MyProduct__c);
            //for delete
            oldTeamMemberSet.add(prodTeam.User__c);
        }
    }
    
    //Query child product list
    List<MyProduct__c> childProductList = [Select Id, Parent_Product__c, Owner.Id from MyProduct__c where Active__c = true and Parent_Product__c in : majorProdIdSet];
    
    //query the product group
    List<MyProduct__c> productGroupList = [Select Id, Owner.Id from MyProduct__c where Active__c = true and Id in : majorProdIdSet];
    
    if(productGroupList != null && productGroupList.size()>0){
        for(MyProduct__c prodGroup: productGroupList){
            prodGroupMap.put(prodGroup.Id,prodGroup.Owner.Id);
        }
    }
    
    if(childProductList != null && childProductList.size()>0){
        system.debug('---childProductList.size---'+childProductList.size());
        if(Trigger.isInsert){
            system.debug('--- insert block---');
            for(ProductTeam__c prodTeam : Trigger.New){
                for(MyProduct__c prod : childProductList){
                    //owner of the record will have access, so to avoid of providing sharing for owner Parent_product__r.
                    if(prod.Parent_Product__c == prodTeam.MyProduct__c && prodTeam.User__c != prod.Owner.Id){
                        //add share object for Product.
                        MyProduct__Share mpsObj = new MyProduct__Share();
                        mpsObj.AccessLevel = 'Edit';
                        mpsObj.UserOrGroupId = prodTeam.User__c;
                        mpsObj.ParentId = prod.Id;
                        prodShareList.add(mpsObj);
                    }
                }
                //To share product of type product group
                Id OwnerId = prodGroupMap.get(prodTeam.MyProduct__c);
                if(prodTeam.User__c != ownerId){
                    MyProduct__Share mpsObj = new MyProduct__Share();
                    mpsObj.AccessLevel = 'Edit';
                    mpsObj.UserOrGroupId = prodTeam.User__c;
                    mpsObj.ParentId = prodTeam.MyProduct__c;
                    prodShareList.add(mpsObj);
                }
            }
        }
        if(Trigger.isUpdate){
            system.debug('---update block---');
            for(ProductTeam__c prodTeam : Trigger.New){
                ProductTeam__c oldProdTeamVersion = Trigger.OldMap.get(prodTeam.Id);
                if(oldProdTeamVersion.User__c != prodTeam.User__c){
                    system.debug('---product team member modified');
                    //add share object for product with new details
                    for(MyProduct__c prod : childProductList){
                        // owner of the record will have access, so to avoid of providing sharing for owner Parent_Product__r
                        if(prod.Parent_Product__c == prodTeam.MyProduct__c && prodTeam.User__c != prod.Owner.Id){
                            // add share object for Product
                            MyProduct__Share mpsObj = new MyProduct__Share();
                            mpsObj.AccessLevel = 'Edit';
                            mpsObj.UserOrGroupId = prodTeam.User__c;
                            mpsObj.ParentId = prod.Id;
                            prodShareList.add(mpsObj);
                        }
                        childProdIdSet.add(prod.Id);
                    }
                }
            }
            //get all product share records for the specified user & child products of a specified product.
            if(oldTeamMemberSet != null && oldTeamMemberSet.size()>0 && childProdIdSet != null && childProdIdSet.size()>0){
                //you cannot delete share records for product owner.
                List<MyProduct__Share> userProductShareList = [Select id from MyProduct__Share where UserOrGroupId in : oldTeamMemberSet and ParentId in : childProdIdSet and Parent.Owner.Id not in : oldTeamMemberSet]; // need to check this query
                
                //delete the product share records for old version record user as we cannot update UserOrGroupId
                if(userProductShareList != null && userProductShareList.size()>0)
            }       delete userProductShareList;
        }
        if(Trigger.isDelete){
            system.debug('--- delete block---');
            for(MyProduct__c prod : childProductList){
                childProdIdSet.add(prod.Id);
                childProdIdSet.add(prod.Parent_Product__c); // to delete product group product
            }
            //get all product share records for the specified user & child products of a specified product
            if(oldTeamMemberSet != null && oldTeamMemberSet.size()>0 && childProdIdSet != null && childProdIdSet.size()>0){
                //you cannot delete share records for product owner
                List<MyProduct__Share> userProductShareList = [select Id from MyProduct__Share where UserOrGroup in: oldTeamMemberSet and ParentId in : childProdIdSet and Parent.Owner.Id not in: oldTeamMemberSet]; // need to check this query
                
                //delete the product share records for deleted product team record
                if(userProductShareList != null && userProductShareList.size()>0)
                    delete userProductShareList;
            }
        }
        system.debug('---prodShareList size---'+ prodShareList.size());       
        if(prodShareList != null && prodShareList.size()>0){
            insert prodShareList;
        }else{
            system.debug('--- no childProducts---');
        }
    }*/
}