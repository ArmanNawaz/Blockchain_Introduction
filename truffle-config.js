module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*" // Match any network id
    }
  },
  contracts_build_directory: "./src/artifacts/",
  solc: {
    version: "0.8.13",
    optimizer: {
      enabled: true,
      runs: 200,
      details: {
        yul: false
      }
    }
  }
}