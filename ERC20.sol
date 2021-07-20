pragma solidity ^0.5.0;
contract ERC20Interface {
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function totalSupply() public view returns (uint);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
contract Math {
    function Add(uint a, uint b) 
        public pure returns (uint c) {
            c = a + b;
            require(c >= a);
        }
    function Sub(uint a, uint b) 
        public pure returns (uint c) 
        {
            require(b <= a); 
            c = a - b; 
        } 
}
contract NTN is ERC20Interface, Math {
    string public name;
    string public symbol;
    uint8 public decimals; 
    uint256 public _totalSupply;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    constructor() public {
        name = "NTN";
        symbol = "NTN";
        decimals = 18;
        _totalSupply = 100000 * 10 ** uint256(decimals);
        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }
    function totalSupply() public view returns (uint) {
        return _totalSupply  - balances[address(0)];
    }
    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }
    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }
    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = Sub(balances[msg.sender], tokens);
        balances[to] = Add(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = Sub(balances[from], tokens);
        allowed[from][msg.sender] = Sub(allowed[from][msg.sender], tokens);
        balances[to] = Add(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }
}
