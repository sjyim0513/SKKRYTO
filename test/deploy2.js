const { ethers } = require("ethers");

async function main() {
  // 1. 개인키
  const privateKey =
    "493ce00b7db73e50938b0efce46d2c8a0f1e15b8478799cab6da84007b171543";

  // 2. Sepolia 네트워크의 공식 RPC URL로 공급자(provider) 생성
  const provider = new ethers.JsonRpcProvider("https://rpc.sepolia.org");

  // 3. 개인키로 지갑 인스턴스를 생성하고 공급자에 연결
  const wallet = new ethers.Wallet(privateKey, provider);
  console.log("지갑 주소:", wallet.address);

  // 4. 보낼 트랜잭션 구성 (예: 0.001 ETH를 특정 주소로 전송)
  const tx = {
    to: "0xRecipientAddressHere", // 실제 수신자 주소로 변경하세요.
    value: ethers.parseEther("0.001"), // 보내는 금액 (0.001 ETH)
  };

  // 5. 트랜잭션 전송
  console.log("트랜잭션 전송 중...");
  const txResponse = await wallet.sendTransaction(tx);
  console.log("트랜잭션 해시:", txResponse.hash);

  // 6. 트랜잭션 확정까지 대기
  const txReceipt = await txResponse.wait();
  console.log("트랜잭션 확정됨. 블록 번호:", txReceipt.blockNumber);
}

main().catch(console.error);
