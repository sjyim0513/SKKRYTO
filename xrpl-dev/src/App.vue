<template>
  <div>
    <h2>트랜잭션 가져와보기</h2>
    <input v-model="tokenAddress" placeholder="토큰 주소를 입력하세요" />
    <button @click="fetchAndProcessTx">조회하기</button>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue";
import { Client } from "xrpl";

const tokenAddress = ref("");
const client = new Client("wss://s1.ripple.com/");

async function fetchAndProcessTx() {
  if (!tokenAddress.value) {
    alert("토큰 주소를 입력하세요");
    return;
  }

  await client.connect();

  const response = await client.request({
    command: "account_tx",
    account: tokenAddress.value,
    ledger_index_max: -1,
    ledger_index_min: -1,
    limit: 15,
  });

  console.dir(response.result);
}
</script>

<style></style>
