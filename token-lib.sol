pragma solidity ^0.4.24;

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

 contract ERC20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Burn(address indexed tokenOwner,uint tokens);
}
 contract Ownable {
    address public owner;
    using SafeMath for uint256;

    constructor () public {
        owner = msg.sender; 
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
     function transferOwnership(address newOwner) public onlyOwner {
        if (newOwner != address(0)) {
            owner = newOwner;
        }
    }
}

contract sofoCoin is ERC20Interface ,Ownable{   
 string constant tokenName = "SofoCoin"; //
 string constant symbol = "Sofo";
 mapping (address => uint)  coinBalance;
 mapping(address => mapping (address => uint256)) public allowed;
 uint  decimal = 18; //decimal of 18th for one unit of crncy
 uint public initialSupply ;
 address public owner;
 uint public  totalSupply;

    constructor() public {
        totalSupply = 3000000000 * (10 ** decimal) ;// 300million tokens 3000000000 * 000000000000000000
        owner = msg.sender;
        coinBalance[owner]= totalSupply;
        initialSupply = 1500000000 * (10 ** decimal) ;// 300million tokens 3000000000 * 000000000000000000
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
        coinBalance[msg.sender]= coinBalance[msg.sender].sub(tokens);
        coinBalance[to]  = coinBalance[to].add(tokens);
        emit  Transfer(msg.sender, to, tokens);
        return true;      
    }
        
    function transferFrom(address from, address to, uint tokens) public  returns (bool success){
        uint allowedToken = allowance(from , msg.sender);
        require (allowedToken>0 && allowedToken>=tokens);
        coinBalance[from]=  coinBalance[from].sub(tokens) ;
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);//here msg.sender is the person having acess for acc of person
        coinBalance[to] = coinBalance[to].add(tokens);
        emit Transfer(from, to, tokens);
        return true; 
    }          
         /* only owner acessed function */    
    function  burnTokens( uint burnTokensAmt) public onlyOwner returns (bool res)  {
        require (coinBalance[owner] >= burnTokensAmt);      
        totalSupply = totalSupply.sub(burnTokensAmt);// dec totalSupply by burned tokens
        coinBalance[owner]=coinBalance[owner].sub(burnTokensAmt);//coin deducted to the owner coinbalance   
        // emit  Burn(msg.sender, burnTokensAmt);
        return true; 
    }
    function  mintCoin(uint mintTokens) public onlyOwner returns(bool res){
        require(mintTokens>0);
        totalSupply = totalSupply.add(mintTokens);//inc totalSupply by burned tokens 
        coinBalance[owner]=coinBalance[owner].add(mintTokens);//coin added to the owner coinbalance

        return true;
    }
     /* only owner acessed function ENDS*/    
}

 

