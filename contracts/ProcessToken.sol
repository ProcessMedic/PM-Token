// SPDX-License-Identifier: MPL
pragma solidity ^0.8.4
// We are going to make a contract called ProcessToken. 
// The goal of this token will be to act as a foundation for a freelance-type of DAO (possibly). 
// A series of smart contracts will handle the logic on-chain, while we present users with an elegant frontend. 
// By possession of ProcessTokens, holders can use our services and infrastucture for their projects. 
// In other words, how can we bring freelance and project management to the blockchain?
// Or better yet, bring the DAO concept to the world of remote work/distributed teams or internet infrastructure?
// 	- when it comes to infra, think: 
//		* decentralized hosting (could host sites on ipfs)
//		* crypto vpn service
// ------------------------------------------------------
// contract begin
contract ProcessToken {
    // state vars 
    string public constant pm_token_init = "ProcessToken first run.";
    string public constant mission = "The first professional and web infrastructure powered by the Ethereum blockchain.";
    // token-specific vars
    string public constant Process_Token = "ProcessToken"; 
    string public constant ticker_sym = "PMT";
    string public constant token_type = "ERC20";
    // origin and receiving wallets 
    address public constant origin_Addr;    // origin address
    address public constant rec_Addr;       // receiving address 1
    mapping(address => uint256) balances;
    // define how tokens are sent and received.
    event TokenTransfer(address indexed from, address indexed to, uint256 process_medic_token); 
    // create a var for the total supply of tokens. this value should be immutable.
    uint256 public immutable PM_Token_Supply;
    // "tokenCap" represents the total number of tokens that will eventually be minted. 
    constructor(uint256 tokenCap) {
        PM_Token_Supply = tokenCap; 
        balances[msg.sender] = tokenCap; 
    }
    function intro() public pure immutable returns (string memory) {
        // describe the token and its characteristics. 
        string public token1 = "Token name: "; 
        string public token2 = "Token type: "; 
        string public token3 = "Token ticker symbol: "; 
        return(pm_token_init);
        return(mission); 
        return(token1); 
        return(Process_Token); 
        return(token2); 
        return(token_type); 
        return(token3); 
        return(ticker_sym);  
    }
    // handle sending and transfer logic. 
    function origin_Balance(address origin_Addr) public view returns (uint256) {
        return balances[origin_Addr]; 
    }
    function transferTokens(address rec_Addr, uint256 numberOfTokens) public returns (bool) {
        require(balances[msg.sender] >= numberOfTokens); 
        balances[msg.sender] = balances[msg.sender] - numberOfTokens; 
        balances[rec_Addr] = balances[rec_Addr] + numberOfTokens; 
        emit Transfer(msg.sender, rec_Addr, numberOfTokens); 
        return true; 
    }
    function transferFromWallet(address origin_Addr, address purchaser, uint256 numberOfTokens) public returns (bool) {
        require(balances[origin_Addr] >= numberOfTokens);
        balances[origin_Addr] = balances[origin_Addr] - numberOfTokens; 
        balances[purchaser] = balances[purchaser] + numberOfTokens; 
        emit Transfer(origin_Addr, purchaser, numberOfTokens); 
        return true; 
    }
    // finish contract execution.
    string public constant deployed = "Smart contract executed on Ethereum blockchain."; 
    string public constant testnet = "If deploying on testnet, make sure you check debug logs.";
    string public constant mainnet = "If on mainnet, there is nothing left to do."; 
    function contract_deployed() public pure returns (string memory) {
        return(deployed); 
        return(testnet); 
        return(mainnet); 
    }
}
//TODO: 
// ...list anything we may need to add later on here.
