# kipu-bank
O smart contract kipuSafe foi deployado na rede de teste SepoliaETH no endereço:

0x3c9eA9e8066d630438516541640A711cC546eb00

https://sepolia.etherscan.io/address/0x3c9eA9e8066d630438516541640A711cC546eb00#code

# Interação com o contrato

O contrato permite interação por meio das seguintes funções


# Alertas

O contrato possui os seguintes alertas


# Tutorial de Validação do Contrato

A validação é uma etapa importante pois garante que ...

Comando para deployar o contrato na rede de teste SepoliaETH
npx hardhat run deploy.js --network sepolia

Após rodar o comando tem que realizar a verificação do contrato em

sepolia.etherscan.io na aba de Contracts, 'Verify and ...'

Na aba de verificação a EVM Target deve ser especificada (Exemplo: 'EVM target: Paris')

O endereço do contrato vai ser retornado após o comando