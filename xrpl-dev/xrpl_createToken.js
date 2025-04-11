import xrpl from "xrpl";

const client = new xrpl.Client("wss://s.altnet.rippletest.net:51233");
await client.connect();

//지갑 생성하면서 얻은 seed 값 입력
const mySeed = "sEd7seS8Noxpokvkcty7WYT1qXLzE43";
const myWallet = xrpl.Wallet.fromSeed(mySeed);
console.log("내 지갑 주소:", myWallet.address);

//토큰 발행: Payment 트랜잭션을 사용해, 발행 화폐를 자기 자신에게 전송하기
const tokenCurrency = "YSJ"; // 발행할 토큰의 symbol
const tokenAmount = "1000"; // 발행할 토큰의 수량

const paymentTx = {
  TransactionType: "Payment", //트랜잭션 타입 지정 -> swap, send는 Payment
  Account: myWallet.address, //트랜잭션이 시작되는 지갑
  Destination: myWallet.address, //도착하는 지갑
  Amount: {
    currency: tokenCurrency,
    value: tokenAmount,
    issuer: myWallet.address, // 토큰의 발행자를 자신으로 설정
  },
};

//트랜잭션 준비, 서명 및 제출
const pre = await client.submit(paymentTx, { wallet: myWallet });
console.log("토큰 발행 결과:", pre.result.tx_json);

client.disconnect();
