import xrpl from "xrpl";

// 클라이언트 생성 및 테스트넷 연결
const client = new xrpl.Client("wss://s.altnet.rippletest.net:51233");
await client.connect();

// 새 지갑 생성
const wallet = xrpl.Wallet.generate();
console.log("새로운 지갑 주소:", wallet.address);

//faucet에서 xrp 받기
const response = await client.fundWallet(wallet);
console.log("Faucet 응답:", response);

client.disconnect();
