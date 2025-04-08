import { ethers } from "ethers";
// 컴파일된 컨트랙트의 ABI와 바이트코드를 가져옵니다.
// 경로는 여러분의 프로젝트 구조에 따라 수정해야 합니다.
import SimpleStorageArtifact from "./artifacts/contracts/SimpleStorage.sol/SimpleStorage.json";

async function main() {
  // JSON RPC Provider 설정 (예: 로컬 Ganache 또는 Hardhat 네트워크)
  const provider = new ethers.providers.JsonRpcProvider(
    "http://localhost:8545"
  );

  // 배포할 계정의 서명자(signer)를 가져옵니다.
  const signer = provider.getSigner();

  // ContractFactory를 생성합니다.
  // 초기 값(예: 42)을 인자로 전달할 수 있습니다.
  const factory = new ethers.ContractFactory(
    SimpleStorageArtifact.abi,
    SimpleStorageArtifact.bytecode,
    signer
  );

  // 컨트랙트 배포 (생성자에 초기 값 전달)
  const contract = await factory.deploy(42);
  console.log(
    "Contract deployment transaction hash:",
    contract.deployTransaction.hash
  );

  // 배포 완료까지 대기
  await contract.deployed();
  console.log("Contract deployed at address:", contract.address);
}

main().catch((error) => {
  console.error("Deployment failed:", error);
  process.exit(1);
});
