require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
let {RINKEBY_PRV_KEY,RINKEBY_URL,ETHERSCAN_API_KEY} = require("./secrets.json");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});
// https://eth-rinkeby.alchemyapi.io/v2/4tbQ72Jsb1zLMcN2-19FN7TwcJee5wu4

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.0",
  networks: {
    rinkeby: {
      url: RINKEBY_URL,
      accounts: [RINKEBY_PRV_KEY], // account 3
    },
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: ETHERSCAN_API_KEY,
  }
};
