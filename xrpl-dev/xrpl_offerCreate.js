import xrpl from "xrpl";

// 클라이언트 생성 및 테스트넷 연결
const client = new xrpl.Client("wss://s.altnet.rippletest.net:51233");
await client.connect();

const MyWalleSeed = "sEdV3v6Vqct1zAxmaf63Ev74uRK6gPk";

const MyWallet = xrpl.Wallet.fromSeed(MyWalleSeed);
console.log("내 지갑 주소:", MyWallet.address);

const hexCode = Buffer.from("COCOA", "utf8")
  .toString("hex")
  .toUpperCase()
  .padEnd(40, "0");

const buyOffer = {
  TransactionType: "OfferCreate",
  Account: MyWallet.address,
  TakerGets: xrpl.xrpToDrops("10"), // 10 XRP 지불
  TakerPays: {
    currency: hexCode,
    issuer: "raJSRkGDTpQ5VxLW82hMLL1N94TUAdHjLS",
    value: "10",
  },
  Flags: 0,
};

const buyOfferTx = await client.submit(buyOffer, { wallet: MyWallet });
console.log("OfferCreate 결과:", buyOfferTx.result.tx_json);

const seq = MyWallet.sequence;
const canceOffer = {
  TransactionType: "OfferCancel",
  Account: MyWallet.address,
  OfferSequence: 6036852,
};

const cancelOfferTx = await client.submit(canceOffer, { wallet: MyWallet });
console.log("OfferCancel 결과:", cancelOfferTx.result.tx_json);

await client.disconnect();
