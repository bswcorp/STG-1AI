// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CarbonShard
 * @dev Tokenisasi kredit karbon (Unit 009) sebagai aset hijau STG.
 *      Setiap Carbon Shard mewakili 1 ton CO₂e yang diverifikasi.
 *      Kontrak ini mendukung minting, transfer, dan verifikasi kepemilikan.
 */

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CarbonShard is ERC20, Ownable {
    // Metadata tambahan untuk verifikasi ESG
    string public verificationHash;   // Hash dari laporan PoR/ZKP
    string public sovereignSignature; // RSA signature dari UBO (Andi Muhammad Harpianto)

    constructor(
        string memory _verificationHash,
        string memory _sovereignSignature
    ) ERC20("CarbonShard", "CSHARD") {
        verificationHash = _verificationHash;
        sovereignSignature = _sovereignSignature;
    }

    /**
     * @dev Mint Carbon Shards baru (hanya oleh owner).
     * @param to Alamat penerima token.
     * @param amount Jumlah token (1 token = 1 ton CO₂e).
     */
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    /**
     * @dev Update hash verifikasi (misalnya laporan baru dari Unit 009).
     * @param _newHash Hash baru dari laporan PoR/ZKP.
     */
    function updateVerificationHash(string memory _newHash) external onlyOwner {
        verificationHash = _newHash;
    }

    /**
     * @dev Update sovereign signature (misalnya RSA signature baru).
     * @param _newSignature Signature baru dari UBO.
     */
    function updateSovereignSignature(string memory _newSignature) external onlyOwner {
        sovereignSignature = _newSignature;
    }
}
