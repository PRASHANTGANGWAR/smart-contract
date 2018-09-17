pragma solidity ^0.4.6;
contract ct{
    
    
     address key ;
     address[] userIndex;
    uint count = userIndex.length;
        mapping (address => uint) public userBalances;
         uint public constant decimal = 4;
            
    
    constructor() public {
        address key = msg.sender; 
        userBalances[key] = 1000*10 ** uint256(decimal);
    }
    
    function setBal(address addOf, uint bal){
         address key = msg.sender; 
        uint balOfOwner = userBalances[key]; 
        userBalances[key]= balOfOwner-bal;
        userBalances[addOf]= bal;
        userIndex.push(addOf);
    }
    
    
    function transfer(address frm, address to , uint amtTransfer) public constant  returns(uint userBal){
        uint balOfPayee=0;
        uint balOfReciver=0;
         balOfPayee =userBalances[frm];
         balOfReciver =userBalances[to];
         bool sucess =allowance(frm,amtTransfer);
      
      if(sucess)
      {  userBalances[to]= balOfReciver + amtTransfer;
       uint userCurrentBal= balOfReciver + amtTransfer;
        }
        return userCurrentBal;
    }
    

    function allowance (address checkBalAtAdress, uint checkBal) returns(bool res) internal {
                 uint bal = userBalances[checkBalAtAdress]; 
                if(bal>=checkBal)
                {
                    return true;

                }
    }
    
    
      /*  function transfer(address frm, address to , uint amtTransfer) public constant  returns(bool sucess){
       
         if(userBalances[frm]>=amtTransfer)
         {
         userBalances[frm]= userBalances[frm]-amtTransfer;
         }
        userBalances[to]=  userBalances[to] + amtTransfer;
      return true;
    }*/
    
    function getBal(address add) public constant  returns(uint userBal){
        uint bal = userBalances[add]; //
       return bal;
          }
    
  

}