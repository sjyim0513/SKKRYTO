import xrpl from "xrpl";

// 클라이언트 생성 및 테스트넷 연결
const client = new xrpl.Client("wss://s.altnet.rippletest.net:51233");
await client.connect();

// issuer(토큰발행자), recipient(토큰 수신자) seed 입력
const issuerSeed = "sEd7seS8Noxpokvkcty7WYT1qXLzE43"; // 발행자 seed
const recipientSeed = "sEdV3v6Vqct1zAxmaf63Ev74uRK6gPk"; // 수신자 seed

const issuerWallet = xrpl.Wallet.fromSeed(issuerSeed);
const recipientWallet = xrpl.Wallet.fromSeed(recipientSeed);

console.log("발행자 주소:", issuerWallet.address);
console.log("수신자 주소:", recipientWallet.address);

// 수신자가 발행 토큰을 받을 수 있도록 TrustSet 트랜잭션 실행
const trustSetTx = {
  TransactionType: "TrustSet",
  Account: recipientWallet.address,
  LimitAmount: {
    currency: "YSJ", // 발행한 토큰의 코드 (예: "YSJ")
    issuer: issuerWallet.address, // 토큰 발행자 주소
    value: "1000000", // 최대 허용량
  },
};

const trusTx = await client.submit(trustSetTx, { wallet: recipientWallet });
console.log("신뢰선 설정(TrustSet) 결과:", trusTx.result);

// 발행자 지갑에서 수신자 지갑으로 토큰 발행(Payment 트랜잭션)
const paymentTx = {
  TransactionType: "Payment",
  Account: issuerWallet.address,
  Destination: recipientWallet.address,
  Amount: {
    currency: "YSJ",
    value: "1000", // 전송할 토큰의 양
    issuer: issuerWallet.address, // 토큰 발행자 (내 지갑)
  },
};

const sendTx = await client.submit(paymentTx, { wallet: issuerWallet });
console.log("토큰 발행(Payment) 결과:", sendTx.result);

client.disconnect();
