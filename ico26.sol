
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
    mapping (address => uint) public discountMapping;
    mapping (address => uint) public weiPaidMapping;


     /*constructor updated  var*/
    address tokenContractOwner ; // adress of token contract owner
    uint public  totalSupply ; //totalSupply of this ico defined within token contract
    sofoCoin ercObject; // created object of token contract 

  constructor (address tokenaddress) public{
     ercObject = sofoCoin(tokenaddress);
     totalSupply = ercObject.totalSupply();
     tokenContractOwner = ercObject.getTokenOwner();
     startDate = now;
     endDate = now + 2419200 + 172800;// 28 + 2 days ico
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
      uint bonusSofotoken  = calDiscount(sofotoken);
      require(bonusSofotoken<= ercObject.balanceOf(address(this)));//CHECK bal of this contract in terms of sofotoken
      ercObject.transfer(msg.sender, bonusSofotoken);// transfer function caall now msg.sender is icoContract
      coinsDistrubuted= coinsDistrubuted + bonusSofotoken;
      weiRaised = msg.value + weiRaised;
      discountMapping[msg.sender]= bonusSofotoken - sofotoken;
      weiPaidMapping[msg.sender] = msg.value; // wei paid  by user to return back the exact amt given by the user(buyer)
    }

    function calDiscount (uint tokens) view public returns(uint bonus)  {
      if((coinsDistrubuted < 100000000000000000000)  && (now <= startDate + 604800)){ //10 ^20 , 604800=1 week
        bonus = 40;         
      }
      else if((coinsDistrubuted < 200000000000000000000)  && (now <= startDate + 604800 *2 )){ //week 2
        bonus = 30;
      }
      else if((coinsDistrubuted < 300000000000000000000)  && (now <= startDate + 604800 *3)){ // week 3 
        bonus = 20;
      }
      else if((coinsDistrubuted < 400000000000000000000)  && (now <= startDate + 604800 *4)){ // week 4 
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
  
  function getBackEther() public returns(bool sucess){
      require(endDate < now );// can execute function only after end date
      require(weiRaised < softCap);// 499 or less < 500(softCap)
     // uint balance = ;
      require (msg.sender.send(weiPaidMapping[msg.sender]));//sending ether to the users account //require for recurrsion attack
      weiPaidMapping[msg.sender] = 0;    
      return true;
  }
  
  function withdrawEther() public onlyOwner {
      require (weiRaised >= softCap);// no one can buy token after end date of ico so ico owner can not transact ethers to his account
      msg.sender.transfer(address(this).balance);
  }
}