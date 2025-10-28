const hre = require("hardhat");

async function main() {
  const YourContract = await hre.ethers.getContractFactory("kipuSafe");
  const yourContract = await YourContract.deploy();

  console.log(`Contract deployed to address: ${await yourContract.getAddress()}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });