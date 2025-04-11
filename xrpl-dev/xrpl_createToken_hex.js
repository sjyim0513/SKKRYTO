import xrpl from "xrpl";

const client = new xrpl.Client("wss://s.altnet.rippletest.net:51233");
await client.connect();

const issuerSeed = "sEd7seS8Noxpokvkcty7WYT1qXLzE43";
const recipientSeed = "sEdV3v6Vqct1zAxmaf63Ev74uRK6gPk";

const issuerWallet = xrpl.Wallet.fromSeed(issuerSeed);
const recipientWallet = xrpl.Wallet.fromSeed(recipientSeed);

console.log("발행자 주소:", issuerWallet.address);
console.log("수신자 주소:", recipientWallet.address);

// 만들 3글자 이상 토큰 symbol
const tokenCurrency = "SKKRYPTO";

// 문자열을 utc8 16진수 문자열로 인코딩
const hexCode = Buffer.from(tokenCurrency, "utf8")
  .toString("hex")
  .toUpperCase()
  .padEnd(40, "0");

const trustSetTx = {
  TransactionType: "TrustSet",
  Account: recipientWallet.address,
  LimitAmount: {
    currency: hexCode,
    issuer: issuerWallet.address,
    value: "1000000",
  },
};

const trusTx = await client.submit(trustSetTx, { wallet: recipientWallet });
console.log("신뢰선 설정(TrustSet) 결과:", trusTx.result);

const paymentTx = {
  TransactionType: "Payment",
  Account: issuerWallet.address,
  Destination: recipientWallet.address,
  Amount: {
    currency: hexCode,
    value: "1000",
    issuer: issuerWallet.address,
  },
};

const sendTx = await client.submit(paymentTx, { wallet: issuerWallet });
console.log("토큰 발행(Payment) 결과:", sendTx.result);

client.disconnect();
