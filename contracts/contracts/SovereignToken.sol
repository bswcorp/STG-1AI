// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SovereignToken
 * @dev Token utama STG (Unit 008) yang mewakili Financial Sovereignty.
 *      Token ini berfungsi sebagai likuiditas inti, collateral, dan instrumen
 *      untuk settlement internasional. Dikelola oleh LUMEN-Sovereign AI Oracle.
 */

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SovereignToken is ERC20, Ownable {
    // Metadata tambahan untuk compliance & governance
    string public complianceHash;      // Hash dokumen KBLI/NIB/OSS
    string public solvencyProofHash;   // Hash Proof of Reserve (PoR)
    string public sovereignSignature;  // RSA signature UBO (Andi Muhammad Harpianto)

    constructor(
        string memory _complianceHash,
        string memory _solvencyProofHash,
        string memory _sovereignSignature
    ) ERC20("SovereignToken", "STG") {
        complianceHash = _complianceHash;
        solvencyProofHash = _solvencyProofHash;
        sovereignSignature = _sovereignSignature;

        // Initial mint: 100,000 STG Units (PoR basis)
        _mint(msg.sender, 100000 * 10 ** decimals());
    }

    /**
     * @dev Mint Sovereign Tokens baru (hanya oleh owner).
     * @param to Alamat penerima token.
     * @param amount Jumlah token.
     */
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    /**
     * @dev Update hash compliance (KBLI/NIB/OSS).
     * @param _newHash Hash baru dokumen compliance.
     */
    function updateComplianceHash(string memory _newHash) external onlyOwner {
        complianceHash = _newHash;
    }

    /**
     * @dev Update Proof of Reserve hash.
     * @param _newHash Hash baru PoR.
     */
    function updateSolvencyProofHash(string memory _newHash) external onlyOwner {
        solvencyProofHash = _newHash;
    }

    /**
     * @dev Update sovereign signature (RSA UBO).
     * @param _newSignature Signature baru.
     */
    function updateSovereignSignature(string memory _newSignature) external onlyOwner {
        sovereignSignature = _newSignature;
    }
}
