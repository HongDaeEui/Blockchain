pragma solidity ^0.8.6;

contract Petshop {
  
   address[9] public adopters;
   
   constructor () public {}
   
   function adopt(uint petId) public returns (uint) {
       require(petId >= 0 && petId <= 9);
       
       adopters[petId] = msg.sender;
       
       return petId;
   }
   
   function getAdopters() public view returns (address[9] memory) {
   
       return adopters; 
   }
 
 
    function destroy() payable public {
    }
    
    
}