pragma solidity 0.8.6;
contract WeatherBet {
    address owner;
    enum VoteTypes { Notbetted, sunny, cloudy, rainny }
    mapping (address => VoteTypes) public votes;
    address[] public voters;
    uint startTime;
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
    }
    
    function voteSunny() public returns (bool success) {
        require(block.timestamp < startTime + 30 minutes);
        if(!addressInArray(msg.sender)){voters.push(msg.sender);}
        votes[msg.sender] = VoteTypes.sunny;
        return true;
    }
    
    function voteCloudy() public returns (bool sucess) {
        require(block.timestamp < startTime + 30 minutes);
        if(!addressInArray(msg.sender)){voters.push(msg.sender);}
        votes[msg.sender] = VoteTypes.cloudy;
        return true;
    }
    
      function voteRainny() public returns (bool sucess) {
        require(block.timestamp < startTime + 30 minutes);
        if(!addressInArray(msg.sender)){voters.push(msg.sender);}
        votes[msg.sender] = VoteTypes.rainny;
        return true;
    }
    
    function removeVote() public {
        require(block.timestamp < startTime + 30 minutes);
        require (addressInArray(msg.sender)); 
        votes[msg.sender] = VoteTypes.Notbetted;
        for(uint i=0; i<voters.length; i++){
         if(voters[i] == msg.sender){
            voters[i] = 0x0000000000000000000000000000000000000000;
            }
        }
    }
    
    function currentSituation() public view returns (uint sunnyVotes, uint cloudyVotes, uint rainnyVotes){
        // require(block.timestamp >= startTime + 30 minutes);
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

