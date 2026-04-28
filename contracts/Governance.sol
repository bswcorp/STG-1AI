// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title STG_Governance_Sentinel
 * @dev Perisai Hukum & Compliance Unit (SENTINEL).
 *      Mengatur daftar putih (whitelist), audit trail, dan persetujuan 
 *      transaksi berdasarkan parameter KYC/AML otomatis.
 */

import "@openzeppelin/contracts/access/AccessControl.sol";

contract STGSentinel is AccessControl {
    bytes32 public constant AUDITOR_ROLE = keccak256("AUDITOR_ROLE");
    bytes32 public constant COMPLIANCE_OFFICER = keccak256("COMPLIANCE_OFFICER");

    mapping(address => bool) public isWhitelisted;
    
    event ComplianceVerified(address indexed account, string docHash);
    event TransactionFlagged(address indexed sender, string reason);

    constructor(address admin) {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
    }

    /**
     * @dev Menambahkan alamat ke daftar putih setelah verifikasi SENTINEL.
     */
    function verifyAccount(address account, string memory docHash) external onlyRole(COMPLIANCE_OFFICER) {
        isWhitelisted[account] = true;
        emit ComplianceVerified(account, docHash);
    }

    /**
     * @dev Fungsi darurat untuk membekukan interaksi jika terdeteksi anomali.
     */
    function flagSuspicious(address account, string memory reason) external onlyRole(AUDITOR_ROLE) {
        isWhitelisted[account] = false;
        emit TransactionFlagged(account, reason);
    }
}
