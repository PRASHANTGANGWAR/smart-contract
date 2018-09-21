pragma solidity ^0.4.24;
 contract ERC20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
contract sofoCoin is ERC20Interface {
       
 string constant tokenName = "SofoCoin"; //
 string constant symbol = "Sofo";
 mapping (address => uint) coinBalance;
 mapping(address => mapping (address => uint256)) allowed;
 uint  decimal = 8; //decimal of 18th for one unit of crncy
 uint public  totalSupply;
 uint public initialSupply ;
 address public owner;
    constructor() public{
        totalSupply = 3000000000 * (10 ** decimal);
        initialSupply = 1500000000 * (10 ** decimal);
        owner = msg.sender;
        coinBalance[msg.sender] = initialSupply;

    }
    
    function  mintCoin(uint token) public returns(bool res){
        uint mintToken = initialSupply+token;//total supplky after minting
        require ((msg.sender == owner) && (token>0) && (totalSupply>=mintToken));
        coinBalance[owner] = coinBalance[owner] + token; 
        initialSupply = coinBalance[owner];
        return true;
    }
    
    function initialSupply() public constant returns(uint){
        return initialSupply;   
    } 

    function  totalSupply() public constant returns (uint){
        return totalSupply;
    }

    function balanceOf(address tokenOwner) public constant returns(uint balance)  {
        return coinBalance[tokenOwner];
    }

    function allowance (address tokenOwner,address spender) public constant returns(uint remaining)  {
        return allowed[tokenOwner][spender];
    }
        
    function approve(address spender, uint tokens) public  returns (bool success){
        uint haveToken = balanceOf(msg.sender);
        require (haveToken>= tokens && tokens>0);
        allowed[msg.sender][spender] = tokens;//address(msg.sender) -> [address(spender)->token(amount of acess)] 
        emit  Approval(msg.sender, spender, tokens);
        return true;
    }
    
    function transfer(address to, uint tokens) public  returns (bool success){// from any  acc to any addres
        uint haveToken = balanceOf(msg.sender);
        require (haveToken>= tokens && tokens>0);
        coinBalance[msg.sender]= coinBalance[msg.sender] - tokens;
        coinBalance[to]  = coinBalance[to] + tokens;
        emit  Transfer(msg.sender, to, tokens);
        return true;      
    }
        
    function transferFrom(address from, address to, uint tokens) public  returns (bool success){
        uint allowedToken = allowance(from , msg.sender);
        require (allowedToken>0 && allowedToken>=tokens);
        coinBalance[from]=  coinBalance[from] - tokens ;
        allowed[from][msg.sender] = allowed[from][msg.sender] -tokens;//here msg.sender is the person having acess for acc of person
        coinBalance[to] = coinBalance[to] + tokens;
        emit Transfer(from, to, tokens);
        return true; 
    }  

    function  burnTokens( uint tokens) public returns(bool res)  {// burn token from qwner acc only burn from intitialSupply
        uint haveToken = balanceOf(owner);
        require (msg.sender==owner && haveToken >= tokens);
        coinBalance[owner] = coinBalance[owner] - tokens;
        initialSupply = initialSupply-tokens;
        return true; 
    }
    
}



 

/* 
ac 1 -  0x0c5C35C3be3CE6DA4fcC03B591D7f10FEE17A446
ac 2 - 0x158fC9f10e299086BC44d7518Dbd71B00EFa739b   10 trns
ac 3 - 0xE96C875804ef2dD11Acb98bD77e244D264c9dD31       1> 3 for 10
ac 4 - 0xB89d92322cEe368060af0d035a4B0bB8cfd8A99f
*/




/* 


ac1  0xca35b7d915458ef540ade6068dfe2f44e8fa733c  150000
ac2 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c    10
ac3  0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db    1>3 10  
ac4 0x583031d1113ad414f02576bd6afabfb302140225
ac 5  0xdd870fa1b7c4700f2bd7f44238821c26f7392148

 */
