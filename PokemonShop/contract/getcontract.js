let provider;
let web3;
let account;
async function connect() {
  if (window.ethereum) {
    web3 = new Web3(window.ethereum);
    try {
      // Request account access if needed
      await window.ethereum.enable();
      // Acccounts now exposed
      web3.eth.getAccounts().then(function (accounts) {
        account = accounts[0];
        document.getElementById("account").innerText = account;
      });
    } catch (error) {}
  }
  // Legacy dapp browsers...
  else if (window.web3) {
    // Use Mist/MetaMask's provider.
    web3 = window.web3;
    console.log("Injected web3 detected.");
  }
}

function getContract() {
  let abi = [
    {
      inputs: [],
      stateMutability: "nonpayable",
      type: "constructor",
    },
    {
      inputs: [
        {
          internalType: "uint256",
          name: "petId",
          type: "uint256",
        },
      ],
      name: "adopt",
      outputs: [
        {
          internalType: "uint256",
          name: "",
          type: "uint256",
        },
      ],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "uint256",
          name: "",
          type: "uint256",
        },
      ],
      name: "adopters",
      outputs: [
        {
          internalType: "address",
          name: "",
          type: "address",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "destroy",
      outputs: [],
      stateMutability: "payable",
      type: "function",
    },
    {
      inputs: [],
      name: "getAdopters",
      outputs: [
        {
          internalType: "address[9]",
          name: "",
          type: "address[9]",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
  ];

  contract = new web3.eth.Contract(
    abi,
    "0xbbE4aabcAd9Fb442CDd5c543D85cCDc97Ae8EEfD"
  );
  document.getElementById("contract").innerHTML = contract._address;
  console.log(contract);
}
