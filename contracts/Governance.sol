// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title GovernanceSentinel
 * @dev Smart contract compliance & voting untuk STG-1AI.
 *      Menyediakan mekanisme whitelist, audit trail, dan voting berbasis token
 *      agar transaksi STG selalu sesuai dengan standar KYC/AML dan governance.
 */

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract GovernanceSentinel is AccessControl {
    bytes32 public constant AUDITOR_ROLE = keccak256("AUDITOR_ROLE");
    bytes32 public constant COMPLIANCE_ROLE = keccak256("COMPLIANCE_ROLE");

    // Token utama STG (Unit 008)
    IERC20 public sovereignToken;

    // Whitelist akun yang lolos verifikasi KYC/AML
    mapping(address => bool) public isWhitelisted;

    // Voting hasil keputusan governance
    struct Proposal {
        string description;
        uint256 yesVotes;
        uint256 noVotes;
        bool executed;
    }

    Proposal[] public proposals;

    event ComplianceVerified(address indexed account, string docHash);
    event TransactionFlagged(address indexed account, string reason);
    event ProposalCreated(uint256 indexed proposalId, string description);
    event Voted(uint256 indexed proposalId, address voter, bool support);
    event ProposalExecuted(uint256 indexed proposalId, bool passed);

    constructor(address admin, address _sovereignToken) {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        sovereignToken = IERC20(_sovereignToken);
    }

    /**
     * @dev Verifikasi akun oleh Compliance Officer.
     */
    function verifyAccount(address account, string memory docHash) external onlyRole(COMPLIANCE_ROLE) {
        isWhitelisted[account] = true;
        emit ComplianceVerified(account, docHash);
    }

    /**
     * @dev Tandai akun mencurigakan oleh Auditor.
     */
    function flagSuspicious(address account, string memory reason) external onlyRole(AUDITOR_ROLE) {
        isWhitelisted[account] = false;
        emit TransactionFlagged(account, reason);
    }

    /**
     * @dev Membuat proposal governance baru.
     */
    function createProposal(string memory description) external onlyRole(DEFAULT_ADMIN_ROLE) {
        proposals.push(Proposal(description, 0, 0, false));
        emit ProposalCreated(proposals.length - 1, description);
    }

    /**
     * @dev Voting proposal menggunakan SovereignToken.
     *      1 token = 1 suara.
     */
    function vote(uint256 proposalId, bool support) external {
        require(isWhitelisted[msg.sender], "Account not whitelisted");
        require(proposalId < proposals.length, "Invalid proposal");

        uint256 balance = sovereignToken.balanceOf(msg.sender);
        require(balance > 0, "No voting power");

        Proposal storage proposal = proposals[proposalId];
        if (support) {
            proposal.yesVotes += balance;
        } else {
            proposal.noVotes += balance;
        }

        emit Voted(proposalId, msg.sender, support);
    }

    /**
     * @dev Eksekusi proposal jika suara mayoritas mendukung.
     */
    function executeProposal(uint256 proposalId) external onlyRole(DEFAULT_ADMIN_ROLE) {
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.executed, "Already executed");

        bool passed = proposal.yesVotes > proposal.noVotes;
        proposal.executed = true;

        emit ProposalExecuted(proposalId, passed);
    }
}
