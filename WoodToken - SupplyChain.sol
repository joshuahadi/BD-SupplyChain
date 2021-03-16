pragma solidity 0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";


contract WoodToken is ERC20, Ownable{
    
    using Counters for Counters.Counter;
    Counters.Counter private _transactionIds;
    
    mapping (address => uint256) public currentCompanyBalance; 
    
    informations[] public info;
    struct informations
    {
             uint transactionId;
             string companyName;
             uint batchID;
             string productInformation;
             string countryOfOrigin;
             address wallet;
             uint amountTokenSent;
    }
    
    
    constructor(uint256 initialSupply) ERC20("WoodToken", "WOOD") {
        _mint(msg.sender, initialSupply * 1 ** decimals()); 
    }
    
    function mintToken(address to, uint256 amount) public virtual onlyOwner {
        require(owner() == _msgSender(), "Only owner is allowed to mint token.");
        _mint(to, amount);
    }
    
    
    function TransferToken(address to, 
    uint256 amount, 
    string memory _productInformation, 
    string memory _countryOfOrigin,
    uint256 _batchId,
    string memory _fromCompany) public returns (bool) 
    {
        require (amount <= balanceOf(msg.sender), "Token is not sufficient!");
        
        uint256 _amountSent = amount;
        _setStruct(_productInformation, _countryOfOrigin, _batchId, _fromCompany, _amountSent);
        _transfer(_msgSender(), to, amount * 1 **  decimals());
        return true;
    }
    
      
    function _setStruct(string memory _productInformation, 
    string memory _countryOfOrigin,
    uint256 _batchId,
    string memory _fromCompany,
    uint256 _amountSent) internal 
    {
        uint currentTransactionId = _transactionIds.current();
        address  _wallet = _msgSender();
         
         informations memory newInformation = informations ({
             transactionId : currentTransactionId,
             productInformation : _productInformation,
             countryOfOrigin : _countryOfOrigin,
             wallet : _wallet,
             batchID : _batchId,
             companyName : _fromCompany,
             amountTokenSent : _amountSent
         });
         
         info.push(newInformation);
         _transactionIds.increment();
    }
    
    function showAllRecords () public view returns (informations[] memory)
    {
        informations[] memory results = new informations[] (info.length); 
         for(uint i=0; i < info.length; i++)
         {
             results[i] = info[i];
         }
             return (results);
         }
         
    function showAllParticipants () public view returns (address[] memory, string[] memory)
    {
        address[] memory participantWallets = new address[] (info.length); 
        string[] memory participantDetails = new string[] (info.length);
         for(uint i=0; i < info.length; i++)
         {
             participantWallets[i] = info[i].wallet;
             participantDetails[i] = info[i].companyName;
         }
             return (participantWallets, participantDetails);
         }
         
    function showBatchId () public view returns (uint256[] memory, string[] memory)
    {
        uint256[] memory showBatch = new uint256[] (info.length); 
        string[] memory participantDetails = new string[] (info.length);
         for(uint i=0; i < info.length; i++)
         {
            showBatch[i] = info[i].batchID;
            participantDetails[i] = info[i].companyName;
         }
             return (showBatch, participantDetails);
    }
    
    function showCompanyTransactionRecord() public view returns (string[] memory, uint256[] memory)
    {
        string[] memory participantDetails = new string[] (info.length);
        uint256[] memory sentTokenRecord = new uint256[] (info.length);
         for(uint i=0; i < info.length; i++)
         {
            participantDetails[i] = info[i].companyName;
            sentTokenRecord[i] = info[i].amountTokenSent;
         }
             return (participantDetails, sentTokenRecord);
    }
    
    function showCompanyTokenBalances() public view returns (string[] memory, uint256[] memory)
    {
        string[] memory participantDetails = new string[] (info.length);
        uint256[] memory participantBalances = new uint256[] (info.length);
         for(uint i=0; i < info.length; i++)
         {
            participantDetails[i] = info[i].companyName;
            participantBalances[i] = balanceOf(info[i].wallet);
         }
             return (participantDetails, participantBalances);
    }

}