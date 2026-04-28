# 🔐 SECURITY-CHECKLIST — STG-1AI

## Cryptographic Verification
- [ ] Proof of Reserve (PoR) hash diperbarui dan diverifikasi
- [ ] Zero-Knowledge Proof (ZKP) certificate valid
- [ ] RSA signature diverifikasi dengan public key STG

## Compliance & Governance
- [ ] KBLI/NIB/OSS status sinkron dengan dokumen legal
- [ ] AML/KYC selective disclosure sesuai standar regulator
- [ ] UBO identity diverifikasi melalui RSA signature

## CI/CD Security
- [ ] Fail-fast mode aktif (tidak ada fallback `|| true`)
- [ ] Vulnerability scan/linting pass
- [ ] OPA/Rego policy checks pass
- [ ] Workflow enforcement untuk PR checklist berjalan

## Operational Security
- [ ] Stress-test metrics valid (TPS, latency, stability)
- [ ] Dashboard sinkron dengan OSS/KBLI legal status
- [ ] Ledger audit trail tersedia untuk auditor resmi

---

📌 **Catatan:** Checklist ini wajib dicentang di setiap PR sebelum merge. Reviewer bertanggung jawab memastikan semua poin terpenuhi.
