const { ethers, upgrades } = require("hardhat");

const ROOT_CONTRACT_ADDRESS = "<BASE_CONTRACT_ADDRESS>";

async function main() {
  const Podium = await ethers.getContractFactory("PodiumContract");
  console.log("Upgrading Podium...");
  await upgrades.upgradeProxy(ROOT_CONTRACT_ADDRESS, Podium);
  console.log("Podium upgraded");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
