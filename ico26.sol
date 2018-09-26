
pragma solidity ^0.4.24;

import "./token.sol";

contract ico {
   /*  mapping (address => uint) coinBalance;
     mapping(address => mapping (address => uint256)) allowed;*/
     uint  decimal = 18; //decimal of 18th for one unit of crncy
     uint public  totalSupply ; 
     uint public initialSupply ;
    uint public contractOwnerBalance;
     address public owner; 
     uint valueOfEther = 1; // 1000 sofoCoin = 1 ehter  
     sofoCoin ercObject;
     event chk(address);
	constructor (address tokenaddress) public payable{
		 ercObject = sofoCoin(tokenaddress);
		 owner = address(this);
		 totalSupply = ercObject.totalSupply();
		 initialSupply = 1500000000 * (10 ** 18);
		 ercObject.transfer(owner,initialSupply);
	}	
    
    function  burnTokens( uint tokens) public returns(bool res)  {
        // burn token from qwner acc only burn from intitialSupply
        uint haveToken = ercObject.balanceOf(owner);
     address tokenContractOwner = ercObject.getTokenOwner();
        tokens = tokens * (10 ** decimal);
     require (msg.sender==tokenContractOwner && haveToken >= tokens);
        ercObject.updateBalancesMapping(owner,tokens);
        initialSupply =  address(this).balance;
        return true; 
    }

    function tokenDistribution (address to,uint tokens) private returns(bool res)  {
      require(msg.sender== owner);
      calDiscount(tokens);
      return ercObject.transfer(to ,tokens);
    }

    function calcuateRate (uint amount) internal view returns(uint token){
     return amount * (valueOfEther); // return token = wei sent * 1000
    }
    
    function buyToken() public payable { 
        // initialSupply = address(this).balance;
    contractOwnerBalance = ercObject.balanceOf(owner);    
      require(msg.value >0);//contains amount of wie sent in tx
      uint tokens = calcuateRate(msg.value);//here tokens are the mini. value of sofocoin
      require(tokens<=initialSupply);
	  tokens  = calDiscount(tokens);
	  ercObject.transfer(msg.sender, tokens);// transfer function caall now msg.sender is icoContract
    }

    function calDiscount (uint tokens) view public returns(uint bonus)  {
  
      uint coinsDistrubuted = initialSupply - ercObject.balanceOf(owner); // initially owner have all coins so money distrubuted among the acc is deducted from owner  
      
      uint percentage =  (100 * coinsDistrubuted) /initialSupply; 

       if( percentage <=10 || percentage == 0){
          bonus = 40;
        }
       else if( percentage <=20){
          bonus = 30;
        }
       else if(percentage <=30){
          bonus = 20;
        }
       else if(percentage <= 40){
          bonus = 10;
       }
       else{
          bonus = 0;
       }
       tokens = tokens + (tokens/100)*bonus;
        return tokens;
    }
         
     function  mintCoin(uint tokens) public returns(uint retTotalSupply){
        address tokenContractOwner = ercObject.getTokenOwner();
        require ((msg.sender == tokenContractOwner) && (tokens>0));
        totalSupply = totalSupply + tokens;
        return totalSupply;
    }

   /* This unnamed function is called whenever someone tries to send ether to it */
   /* function  () public payable{
        revert();     // Prevents accidental sending of ether
    }
    */
 
     
    /*function  burnTokens( uint tokens) public returns(bool res)  {
        // burn token from qwner acc only burn from intitialSupply
        address tokenContractOwner = ercObject.getTokenOwner();
        uint haveToken = ercObject.balanceOf(tokenContractOwner);
        tokens = tokens * (10 ** decimal);
       emit chk(owner);
        require (msg.sender==tokenContractOwner && haveToken >= tokens);
        ercObject.updateBalancesMapping(tokenContractOwner,tokens);
        initialSupply = initialSupply-tokens;
        return true; 
    }*/
 
   
}
