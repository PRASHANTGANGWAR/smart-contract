
pragma solidity ^0.4.24;
import "./token.sol";
contract ico is Ownable {
    uint  decimal = 18; //decimal of 18th for one unit of crncy
    uint public valueOfEther = 1500; // 1 sofoCoin = 1 ehter 
    uint public minTradeAmt =100000000000000000;//0.1eth
    uint public hardCap = 1000 * (10 ** 18);//1000 ether
    uint public softCap =  500 * (10 ** 18);//500 ether
    uint public weiRaised;
    uint public coinsDistrubuted; //coins distrubuted or amt of coins bought by users
    uint public startDate ;
    uint public endDate ;
    bool public stateActive;
    bool public statePending;
    bool public stateInactive;
    bool public state;
     /*constructor updated  var*/
    address tokenContractOwner ; // adress of token contract owner
    uint public  totalSupply ; //totalSupply of this ico defined within token contract
    sofoCoin ercObject; // created object of token contract 

  constructor (address tokenaddress) public{
     ercObject = sofoCoin(tokenaddress);
     totalSupply = ercObject.totalSupply();
     tokenContractOwner = ercObject.getTokenOwner();
     startDate = now;
     endDate = now + 2629743 ;
  } 
  
   // modifier afterDeadline() { if (now >= endDate) _; }

    function calcuateRate (uint amount) internal view returns(uint token){
     amount = amount * (valueOfEther) * (10 ** decimal); // return token = wei sent * 1
     amount = amount /(10 ** 18);
     return amount;
    }
    
    function buyToken() public payable { //
      require ((weiRaised +msg.value <= hardCap) && (endDate>=now) && (msg.value >=minTradeAmt));
      uint sofotoken = calcuateRate(msg.value);//here tokens are the mini. value of sofocoin sofo
      sofotoken  = calDiscount(sofotoken);
      require(sofotoken<= ercObject.balanceOf(address(this)));//CHECK bal of this contract in terms of sofotoken
      ercObject.transfer(msg.sender, sofotoken);// transfer function caall now msg.sender is icoContract
      coinsDistrubuted= coinsDistrubuted + sofotoken;
      weiRaised = msg.value + weiRaised;
    }

    function calDiscount (uint tokens) view public returns(uint bonus)  {
      if( coinsDistrubuted < 100000000000000000000 ){ //10 ^20 
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
      buyToken();
    }
  
  function getBackEther() public returns(uint amount){
      require (endDate < now );
      require(weiRaised < softCap);
      uint balance = ercObject.balanceOf(msg.sender) / valueOfEther;
      require(balance >0);
      //update mapping 
      //ercObject.balanceOf[msg.sender]=0;
      ercObject.updatecoinBalance(msg.sender);
      require (msg.sender.send(balance));//sending ether to the users account //require for recurrsion attack
      return balance;
  }
  
  function withdrawEther() public onlyOwner {
      bool sucess = false;
      if(weiRaised>=softCap){
          sucess = true;
      }
      if(!sucess){
        require (endDate < now );
      }
     msg.sender.transfer(address(this).balance);
  }
}