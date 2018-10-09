
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
    bool public statePending = true;
    bool public icoIsSuccessfull;
    uint public maxTokenCanBuy = 15000000 * (10 ** decimal);//to achieve decentralisation 10000 ether capping
    // uint public contributionPercentage ;
    //mapping (address => uint)  discountMapping;
    mapping (address => uint)  weiPaidMapping;

    /* shares */
   uint founderShare   = 390000000 * (10 ** decimal); //13%
   uint bountyShare    = 60000000 * (10 ** decimal); // 2%
   uint advisorShare   = 300000000 * (10 ** decimal); // 10%
   uint teamShare      = 450000000 * (10 ** decimal); // 15%
   uint liquidityShare = 300000000 * (10 ** decimal); // 10%  
   // to liquidate market value of the coin by increasing the coins in flow etc
   uint public tokenReleasedFounder ;
   uint public tokenReleasedAdvisor ;
   uint public tokenReleasedTeam ;
   uint public tokenReleasedBounty ;
   uint public tokenReleasedliquidity ;
    /* shares */

     /*constructor updated  var*/
    uint public  totalSupply ; //totalSupply of this ico defined within token contract
    sofoCoin ercObject; // created object of token contract 

    event TokenBuyer(address indexed buyer , uint weiPaid);
    event EtherWithdrawn(address indexed buyer ,uint ethers);
    
  constructor (address tokenaddress) public{
     ercObject = sofoCoin(tokenaddress);
     totalSupply = ercObject.totalSupply();
     startDate = now;
     endDate = now + 30 days;//30 days ico
  } 
   // modifier afterDeadline() { if (now >= endDate) _; }
    function buyToken() public payable { //
      require ((weiRaised +msg.value <= hardCap) && (endDate>=now) && (msg.value >=minTradeAmt) && (startDate<=now));
      //uint sofotoken = calcuateRate(msg.value);//here tokens are the mini. value of sofocoin sofo
      uint bonusSofotoken  = calDiscount(msg.value);
      require(bonusSofotoken <= ercObject.balanceOf(address(this)));//CHECK bal of this contract in terms of sofotoken
      require(ercObject.balanceOf(msg.sender) +bonusSofotoken <= maxTokenCanBuy );
      ercObject.transfer(msg.sender, bonusSofotoken);// transfer function caall now msg.sender is icoContract
      coinsDistrubuted= coinsDistrubuted.add(bonusSofotoken);
      weiRaised = msg.value.add(weiRaised);
    //   discountMapping[msg.sender]= bonusSofotoken - sofotoken;//discount given or extra tokens given
      weiPaidMapping[msg.sender] = weiPaidMapping[msg.sender].add(msg.value); // wei paid  by user to return back the exact amt given by the user(buyer)
      emit TokenBuyer(msg.sender , msg.value);
    }

    function calDiscount (uint amount) view public returns(uint bonus)  {
      amount = amount * (valueOfEther) * (10 ** decimal); // return token = wei sent * 1
      amount = amount.div(10 ** 18);
      if((coinsDistrubuted < 1000000 * (10 ** decimal))  && (now <= startDate + 604800)){ //10 ^20 , 604800=1 week
        bonus = 40;         
      }
      else if((coinsDistrubuted < 2000000 * (10 ** decimal))  && (now <= startDate + 604800 *2 )){ //week 2
        bonus = 30;
      }
      else if((coinsDistrubuted < 3000000 * (10 ** decimal))  && (now <= startDate + 604800 *3)){ // week 3 
        bonus = 20;
      }
      else if((coinsDistrubuted < 4000000 * (10 ** decimal))  && (now <= startDate + 604800 *4)){ // week 4 
        bonus = 10;              
      }
      else{
        bonus = 0;
      }
      amount = amount + (amount/100)*bonus;
      return amount;
    }

       /* This unnamed function is called whenever someone tries to send ether to it */
    function  () public payable{
      buyToken();
    }
  
  function getBackEther() public returns(bool sucess){
      require((endDate < now) && (weiRaised < softCap) && (weiPaidMapping[msg.sender] > 0));// can execute function only after end date && 499 or less < 500(softCap)
      emit EtherWithdrawn(msg.sender,weiPaidMapping[msg.sender]);
      uint etherReturn = weiPaidMapping[msg.sender];    
      weiPaidMapping[msg.sender] = 0;
      require (msg.sender.send(etherReturn));//sending ether to the users account //require for recurrsion attack
      return true;
  }
  
  function withdrawEther() public onlyOwner {
      require (weiRaised >= softCap);// no one can buy token after end date of ico so ico owner can not transact ethers to his account
      msg.sender.transfer(address(this).balance);
  }

  function icoState () public {
    if(startDate < now){
      statePending = false;
    }
    if(endDate > now && weiRaised<hardCap){
      stateActive = true;
    }
    else{
        stateActive = false;
    }

    if(weiRaised > softCap)
    {
      icoIsSuccessfull = true;
    }
  }


  function isEligible (uint tokens) public view returns(uint token ) {
    require (now > endDate + 90 days);//can take out tokens after 3 month of ico enddate
    require (tokens>0 && icoIsSuccessfull);
    tokens = tokens * (10 ** decimal); // b/w 3-6 month
    return tokens;
  }

  function transferFunds (uint tokens , bool select) internal returns(bool res)  {
        if(select){
       founderShare = founderShare.sub(tokens);
       tokenReleasedFounder = tokenReleasedFounder + tokens;
       ercObject.transfer(msg.sender, tokens);//msg.sender owner
       return true;
     }
     else
     {
        advisorShare = advisorShare.sub(tokens);
        tokenReleasedAdvisor = tokenReleasedAdvisor + tokens;
        ercObject.transfer(msg.sender, tokens);//msg.sender owner
        return true;
     }
  }
  

   function releaseVestedTokenFounder(uint tokens) onlyOwner public returns(bool sucess){
       tokens= isEligible(tokens);
        if((endDate + 180 days  >= now )&& ( now > endDate + 90 days )&&(tokenReleasedFounder +tokens <= 97500000 * (10 ** decimal))){
          transferFunds(tokens , true);
           return true;
        }
        else if ((endDate + 270 days >= now )&& ( now > endDate + 180 days ) && (tokenReleasedFounder + tokens<= 195000000 * (10 ** decimal))){
          transferFunds(tokens , true);
           return true;
        }                                           
        else if ((endDate + 360 days >= now )&& ( now > endDate + 270 days )&& (tokenReleasedFounder +tokens <= 292500000 * (10 ** decimal))){
          transferFunds(tokens , true);
           return true;
        }
        else if (( now > endDate +  360 days )&& (tokenReleasedFounder +tokens <= 390000000 * (10 ** decimal))){
          transferFunds(tokens , true);
           return true;
        }
        revert();
    }

     function releaseVestedTokenAdvisor(uint tokens) onlyOwner public returns(bool sucess){
        tokens= isEligible(tokens);
        if((endDate +  180 days  >= now )&& ( now > endDate + 90 days )&&(tokenReleasedAdvisor +tokens <= 75000000 * (10 ** decimal))){
          transferFunds(tokens , false);
           return true;
        }
        //6-9 month
        else if ((endDate + 270 days >= now )&& ( now > endDate + 180 days ) && (tokenReleasedAdvisor + tokens<= 150000000 * (10 ** decimal))){
         transferFunds(tokens , false);
          return true;
        }  
        // 9-12 month                                         
        else if ((endDate + 360 days >= now )&& ( now > endDate + 270 days )&& (tokenReleasedAdvisor +tokens <= 225000000 * (10 ** decimal))){
         transferFunds(tokens , false);
          return true;
        }
        //after 12+ month
        else if (( now > endDate + 360 days )&& (tokenReleasedAdvisor +tokens <= 300000000 * (10 ** decimal))){
         transferFunds(tokens , false);
          return true;
        }
        revert();
    }

    function releaseTeamShare(uint tokens) onlyOwner public returns(bool res)  {  
      tokens = tokens * (10 ** decimal);  
      require (tokens>0 && icoIsSuccessfull);
      require (tokenReleasedTeam +tokens <= 450000000 * (10 ** decimal));
      tokenReleasedTeam = tokenReleasedTeam + tokens;
      ercObject.transfer(msg.sender, tokens);//msg.sender owner 
      return true;
    }

     function releaseBountyShare(uint tokens) onlyOwner public returns(bool res)  {    
      tokens = tokens * (10 ** decimal);  
      require (tokens>0 && icoIsSuccessfull);
      require (tokenReleasedBounty +tokens <= 60000000 * (10 ** decimal));
      tokenReleasedBounty = tokenReleasedBounty + tokens;
      ercObject.transfer(msg.sender, tokens);//msg.sender owner 
      return true;
    }

     function releaseLiquidityShare(uint tokens) onlyOwner public returns(bool res)  {
      tokens = tokens * (10 ** decimal);           
      require (tokens>0 && icoIsSuccessfull);
      require (tokenReleasedliquidity +tokens <= 300000000 * (10 ** decimal));
      tokenReleasedliquidity = tokenReleasedliquidity + tokens;
      ercObject.transfer(msg.sender, tokens);//msg.sender owner 
      return true;
    }
    
  function contributionPercent() public view returns(uint percentage){
      // let buyer know what percentage they hold in ico9
    return  (ercObject.balanceOf(msg.sender).mul(100)).div(totalSupply) * (10 ** decimal);
  } 
}