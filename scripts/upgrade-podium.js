const { ethers, upgrades } = require("hardhat");

async function main() {
  const Podium = await ethers.getContractFactory("PodiumContract");
  console.log("Upgrading Podium...");
  await upgrades.upgradeProxy(process.env.CONTRACT_ADDRESS, Podium);
  console.log("Podium upgraded");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
