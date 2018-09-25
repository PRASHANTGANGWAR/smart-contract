
pragma solidity ^0.4.24;

import "./token.sol";

contract ico {
     mapping (address => uint) coinBalance;
     mapping(address => mapping (address => uint256)) allowed;
     uint  decimal = 8; //decimal of 18th for one unit of crncy
     uint public  totalSupply =  3000000000 * (10 ** decimal); 
     uint public initialSupply = address(this).balance;
     address public owner; 
     uint valueOfEther = 1000; // 1000 sofoCoin = 1 ehter  
     sofoCoin ercObject;
     event chk(address);
    
	constructor (address tokenaddress) public payable{
		 ercObject = sofoCoin(tokenaddress);
		 owner = address(this);
	}	
    
    function  burnTokens( uint tokens) public returns(bool res)  {
        // burn token from qwner acc only burn from intitialSupply
        uint haveToken = ercObject.balanceOf(owner);
       emit chk(owner);
        require (msg.sender==owner && haveToken >= tokens);
        coinBalance[owner] = coinBalance[owner] - tokens;
        
        initialSupply = initialSupply-tokens;
        return true; 
    }

    function tokenDistribution (address to,uint tokens) private returns(bool res)  {
      require(msg.sender== owner);
      calDiscount(tokens);
      return ercObject.transfer(to ,tokens);
    }

    function calcuateRate (uint amount) internal view returns(uint token){
     return amount * (valueOfEther /10^18);
    }
    
    function buyToken() public payable {
      require(msg.value >= 100000000000000);
      uint tokens = calcuateRate(msg.value);
	  tokens  = calDiscount(tokens);
	  tokens= tokens * (10 ** decimal);
	  ercObject.transfer(msg.sender, tokens);
    }

    function calDiscount (uint tokens) view public returns(uint bonus)  {
  
      uint coinsDistrubuted = initialSupply - coinBalance[owner]; // initially owner have all coins so money distrubuted among the acc is deducted from owner  
      
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
         
     function  mintCoin(uint tokens) public returns(bool res){
        uint mintToken = initialSupply+tokens;//initialsupply after minting 
        require ((msg.sender == owner) && (tokens>0) && (totalSupply>=mintToken));
        coinBalance[owner] = coinBalance[owner] + tokens; 
/*         initialSupply = coinBalance[owner];*/
        initialSupply = initialSupply + tokens;
        return true;
    }

   /* This unnamed function is called whenever someone tries to send ether to it */
    function  () {
        revert();     // Prevents accidental sending of ether
    }
}
