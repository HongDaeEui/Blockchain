pragma solidity 0.8.6;

contract ERC20Basic {

    string public constant name = "Daily Value";
    string public constant symbol = "Day";
    uint8 public constant decimals = 0;  

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);

    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;
    
    uint256 totalSupply_;

    using SafeMath for uint256;

   constructor(uint256 total) public {  
		totalSupply_ = total;
		balances[address(this)] = totalSupply_;
    }  

    function totalSupply() public view returns (uint256) {
	return totalSupply_;
    }
    
    function balanceOf(address tokenOwner) public view returns (uint) {
        return balances[tokenOwner];
    }
    
      function getToken() public{
          require(balances[address(this)] >= 1000);
       balances[address(this)] = balances[address(this)].sub(100);
       balances[msg.sender] = balances[msg.sender].add(100);
    }

    function transfer(address receiver, uint numTokens) public returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint numTokens) public returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
        require(numTokens <= balances[owner]);    
        require(numTokens <= allowed[owner][msg.sender]);
    
        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}

library SafeMath { 
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

contract WeatherBet {
    address owner;
    enum VoteTypes { Notbetted, sunny, cloudy, rainny }
    mapping (address => VoteTypes) public votes;
    address[] public voters;
    uint winners;
    uint startTime;
    uint timeout;
    struct VotersResult {
        address vote;
        VoteTypes result;
    }
    string weatherResult;
    VotersResult[] votersresults;
    
    
    modifier onlyOwner() {require(msg.sender == owner); _;}

    
    constructor() public{
        owner=msg.sender;
        votes[0x0000000000000000000000000000000000000000]=VoteTypes.Notbetted;
        startTime = block.timestamp;
        timeout = block.timestamp + 6 hours;
    }
    
    function voteSunny() public returns (bool success) {
        require(block.timestamp < timeout);
        if(!addressInArray(msg.sender)){voters.push(msg.sender);}
        votes[msg.sender] = VoteTypes.sunny;
        return true;
    }
    
    function voteCloudy() public returns (bool sucess) {
        require(block.timestamp < timeout);
        if(!addressInArray(msg.sender)){voters.push(msg.sender);}
        votes[msg.sender] = VoteTypes.cloudy;
        return true;
    }
    
      function voteRainny() public returns (bool sucess) {
        require(block.timestamp < timeout);
        if(!addressInArray(msg.sender)){voters.push(msg.sender);}
        votes[msg.sender] = VoteTypes.rainny;
        return true;
    }
    
    function removeVote() public {
        require(block.timestamp < timeout);
        require (addressInArray(msg.sender)); 
        votes[msg.sender] = VoteTypes.Notbetted;
        for(uint i=0; i<voters.length; i++){
         if(voters[i] == msg.sender){
            voters[i] = 0x0000000000000000000000000000000000000000;
            }
        }
    }
    
    function getVoter() public view returns (VoteTypes) {
        return votes[msg.sender];
    }
    
    function getVote() public view returns (uint, uint, uint){
        require(block.timestamp < timeout);
        uint _sunnyVotes = 0;
        uint _cloudyVotes = 0;
        uint _rainnyVotes = 0;
        for(uint i=0; i<voters.length;i++){
          if(votes[voters[i]]==VoteTypes.sunny){
            _sunnyVotes++;
          }
          if(votes[voters[i]]==VoteTypes.cloudy){
            _cloudyVotes++;
          }
          if(votes[voters[i]]==VoteTypes.rainny){
            _rainnyVotes++;
          }
        }
        return ( _sunnyVotes, _cloudyVotes, _rainnyVotes );
      }
      
      function result(uint weatherCode) public returns (bool, uint) {
          bool win;
          uint prize;
          uint totalPrize = ERC20Basic(0xbae4b2Ac594699E6EC7D154f552A0DB499529c22).balanceOf(address(this));
          if(votes[msg.sender] == VoteTypes(weatherCode)) {
              win = true;
              for(uint i=0; i<voters.length;i++) {
                 if(votes[voters[i]] == VoteTypes(weatherCode)) {
                     winners++;
                 }
              }
              prize =  totalPrize/winners;
              ERC20Basic(0xbae4b2Ac594699E6EC7D154f552A0DB499529c22).transfer(msg.sender, prize);
          }else {
              win = false;
              prize = 0;
          }
          return (win, prize );
      }
    
    
     function votersResult() public {
         for(uint i=0; i<voters.length; i++) {
            votersresults.push(VotersResult(voters[i], votes[voters[i]]));
         }
        }
    
     function getVotersResult() public view returns(VotersResult[] memory) {
        // require(block.timestamp >= startTime + 1 hours);
        return votersresults;
        }
    
    function addressInArray(address inAddress) private view returns (bool inArray) {
        for(uint i=0; i<voters.length; i++){
            if(voters[i] == inAddress){
                return true;
            }else{
                return false;
            }
        }
    }
    
        function destroy() public {
        selfdestruct(payable(msg.sender));
    }
    
}

