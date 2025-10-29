# kipu-bank
O smart contract *kipuSafe* foi deployado na rede de teste *SepoliaETH* no seguinte endereço:
```
0x3c9eA9e8066d630438516541640A711cC546eb00
```
Pode ser consultado no explorador de blocos *EtherScan*:
```
https://sepolia.etherscan.io/address/0x3c9eA9e8066d630438516541640A711cC546eb00#code
```
# Interação com o contrato

O contrato permite interação por meio das seguintes funções:

  depositFunds(): Funtion to deposit ether into the contract <br>
  withDrawFunds(): Function for withdraw ether from proprietary <br>
  SetannotationBank(): Function for set a string in proprietary account for a cost of 0.1 ether <br>
  infoBalanceContract(): Function to get contract balance and stats <br>
  getmaxAllowedCash(): Function to get max allowed cash for a user's withdraw <br>
  changeOwner(): Function to change the owner contract <br>

# Eventos

O contrato possui os seguintes alertas de evento: 

  event Deposited(); <br>
  event AllowanceSet(); <br>
  event Pulled(); <br>
  event FallbackCalled(); <br>
  event OwnerContractTransferred(); <br>
  event MessageSet(); <br>

# Tutorial de Validação do Contrato

A validação é uma etapa importante pois gaante que o código-fonte de um contrato inteligente corresponde ao bytecode (código executável) que foi implantado na blockchain. Esse processo é fundamental para trazer transparência, segurança e confiabilidade aos usuários do contrato. 

# Deploy

Comando para deployar o contrato na rede de teste SepoliaETH:
```
npx hardhat run deploy.js --network sepolia
```
Após rodar o comando tem que realizar a verificação do contrato em

sepolia.etherscan.io na aba de Contracts, 'Verify and ...'

Na aba de verificação a EVM Target deve ser especificada (Exemplo: 'EVM target: Paris')

O endereço do contrato vai ser retornado após o comando
