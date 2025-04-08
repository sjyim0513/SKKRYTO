const { ethers } = require("hardhat");

async function main() {
  // 개인키
  const PRIVATE_KEY =
    "493ce00b7db73e50938b0efce46d2c8a0f1e15b8478799cab6da84007b171543";

  const wallet = new ethers.Wallet(PRIVATE_KEY, ethers.provider);
  console.log("복원된 지갑 주소:", wallet.address);

  const contractFactory = await ethers.getContractFactory(
    "SimpleStorage",
    wallet
  );

  const contract = await contractFactory.deploy(10);

  console.log("컨트랙트 배포 완료: ", contract.target);
}

main();
