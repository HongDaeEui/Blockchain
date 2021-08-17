contract WeatherBet {
    address public owner;
    enum VoteTypes { Notbetted, sunny, cloudy, rainny }
    mapping (address => VoteTypes) public votes;
    address[] public voters;
    uint public winners;
    uint startTime;
    uint timeout;
    struct VotersResult {
        address vote;
        VoteTypes result;
    }
    string weatherResult;
    VotersResult[] votersresults;
    mapping (address => uint) prizes;
    
    event Result(bool win, uint prize);
    
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
        ERC20Basic(0x00906AC77D16753dBEE1ddbab66a5a47936c4CDC).transfer(msg.sender, 100);
    }
        
    
    function getVoter() public view returns (VoteTypes) {
        return votes[msg.sender];
    }
    
    function getVote() public view returns (uint, uint, uint){
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
      
      function result(uint weatherCode) public {
          bool win;
          uint prize;
          uint totalPrize = ERC20Basic(0x00906AC77D16753dBEE1ddbab66a5a47936c4CDC).balanceOf(address(this));
          
          for(uint i=0; i<voters.length;i++) {
                 if(votes[voters[i]] == VoteTypes(weatherCode)) {
                     winners++;
                 }
          }
                 
          if(votes[msg.sender] == VoteTypes(weatherCode)) {
              win = true;
              prize =  totalPrize/winners;
              prizes[msg.sender] += prize;
              ERC20Basic(0x00906AC77D16753dBEE1ddbab66a5a47936c4CDC).transfer(msg.sender, prize);
              
              emit Result(win, prize );
          }else {
              win = false;
              prize = 0;
              emit Result(win, prize );
          }
      }
      
      function getPrizes() public view returns(uint) {
       return prizes[msg.sender];   
      }
    
    
     function votersResult() public onlyOwner{
         for(uint i=0; i<voters.length; i++) {
            votersresults.push(VotersResult(voters[i], votes[voters[i]]));
         }
        }
    
     function getVotersResult() public view returns(VotersResult[] memory) {
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
    
        function destroy() public onlyOwner {
        selfdestruct(payable(msg.sender));
    }
    
}

