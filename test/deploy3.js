const { ethers } = require("hardhat");

async function main() {
  const PK = "e46b2ea6ca4de49cf26a5cced3716bc400209cc9f3d13af70b18a3d50bf3b7d6";

  const wallet = new ethers.Wallet(PK, ethers.provider);
  console.log("복원된 지갑 주소: ", wallet.address);

  const contractfactory = await ethers.getContractFactory(
    "testContract_0408",
    wallet
  );

  const contract = await contractfactory.deploy(
    "0xf69A21Bdb87c851FA9c2B1C8A48289151ca2cAda"
  );

  console.log("컨트랙트 배포 완료: ", contract.target);
}

main();
