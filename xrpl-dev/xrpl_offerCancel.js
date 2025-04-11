import xrpl from "xrpl";

// 클라이언트 생성 및 테스트넷 연결
const client = new xrpl.Client("wss://s.altnet.rippletest.net:51233");
await client.connect();

const MyWalleSeed = "sEdV3v6Vqct1zAxmaf63Ev74uRK6gPk";

const MyWallet = xrpl.Wallet.fromSeed(MyWalleSeed);
console.log("내 지갑 주소:", MyWallet.address);

const account_offer = await client.request({
  command: "account_offers",
  account: MyWallet.address,
  ledger_index: "validated",
});

console.dir(account_offer.result, { depth: null });
