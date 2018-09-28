
pragma solidity ^0.4.24;

import "./token.sol";

contract ico is Ownable {
     uint  decimal = 18; //decimal of 18th for one unit of crncy
/*     uint public initialSupply ; //initial supply for the contract to distribute coins can be increased later
  */ uint public contractBalance;// balance of this contract can be used address(this).balance
     uint valueOfEther = 1; // 1 sofoCoin = 1 ehter 
     uint minTradeAmt =100000000000000000;//0.1eth
    uint public hardCap = 1000 * (10 ** 18);//ether
    uint public softCap =  500 * (10 ** 18);//ether
    uint public weiRaised;
    uint public coinsDistrubuted; //coins distrubuted or amt of coins bought by users
    uint balanceInEther;
    uint public startDate ;
    uint public bonusEnds;
    uint public endDate ;
     
     /*constructor updated  var*/
     address tokenContractOwner ; // adress of token contract owner
     uint public  totalSupply ; //totalSupply of this ico defined within token contract
     address public owner; //address of this contract
     sofoCoin ercObject; // created object of token contract 

  constructor (address tokenaddress) public{
     ercObject = sofoCoin(tokenaddress);
     owner = address(this);
     totalSupply = ercObject.totalSupply();
     tokenContractOwner = ercObject.getTokenOwner();
     startDate = now;
     bonusEnds = now + 2629743;// 1 month in epoch time 
         endDate = now + 7 ;
  } 
  
    function calcuateRate (uint amount) internal view returns(uint token){
      return amount * (valueOfEther); // return token = wei sent * 1
      
    }
    
    function buyToken() public payable { 
      require(msg.value >=minTradeAmt);//contains amount of wie sent in tx ,, min contribution 0.1 ehter 
      uint sofo = calcuateRate(msg.value);//here tokens are the mini. value of sofocoin sofo
      contractBalance = ercObject.balanceOf(owner);
      require(sofo<=contractBalance);
    sofo  = calDiscount(sofo);
    ercObject.transfer(msg.sender, sofo);// transfer function caall now msg.sender is icoContract
    coinsDistrubuted= coinsDistrubuted + sofo;
    weiRaised += msg.value;
     balanceInEther  += address(this).balance;
    }

    function calDiscount (uint tokens) view public returns(uint bonus)  {

       if( coinsDistrubuted < 100000000000000000000 ){
          bonus = 40;         
        }
       else if( coinsDistrubuted < 200000000000000000000){
          bonus = 30;
        }
       else if(coinsDistrubuted < 300000000000000000000){
          bonus = 20;
        }
       else if(coinsDistrubuted < 400000000000000000000){
          bonus = 10;
       }
       else{
          bonus = 0;
       }
       tokens = tokens + (tokens/100)*bonus;
        return tokens;
    }
         

       /* This unnamed function is called whenever someone tries to send ether to it */
    function  () public payable{
        revert();     // Prevents accidental sending of ether
    }
  
  function getBackEther() public returns(uint amount){
      /*require(timePeriod);*/
      require(weiRaised<softCap);
      
      
  }
  
  function withdrawEther() public returns(uint amount){
      require(msg.sender == tokenContractOwner);
      msg.sender.transfer(this.balance);

  }
  
}
