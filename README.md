# Project Documentation 📚

Welcome to the project documentation! This repository contains essential documentation to guide you through the setup and usage of the project. As a submodule of the Cartesi Machines repositories, it plays a crucial role in ensuring smooth operations. Follow the steps below to get started:

## 1. Setting Up Environment 🌍

- Before you begin, make sure you have the required environment variables properly configured. Create an environment by executing the following command:

    ```bash
    $ make env
    ```

- Ensure you provide the necessary parameters in the generated environment file.

## 2. Deployment 🚀

- As we are using the Foundry framework to develop robustness contracts, an important change must be made in the rollup submodule:

    ```bash
    $ cat lib/rollups/onchain/rollups/contracts/library/LibOutputValidation.sol
    ```

    - Change line 16 to ```import {MerkleV2} from "../../../rollups-arbitration/lib/solidity-util/contracts/MerkleV2.sol";``` instead ```import {MerkleV2} from "@cartesi/util/contracts/MerkleV2.sol";```.

### 2.1 System Rollout on testnet 🌐

- To implement the system in testnet, run the command below:

    ```bash
    $ make system CONFIG="--network <NETWORK_NAME>"
    ```

- ⚠️ Supported Networks:
    - sepolia
    - mumbai

- To interact with the Cartesi machines, follow the instructions contained in the readme of each one:

    - Verfier: https://github.com/Lilium-DApp/verifier
    - Auction: https://github.com/Lilium-DApp/auction

## 3. Generating Documentation 📖

Generate project documentation using:

```bash
forge doc
```

This command generates documentation based on the project's code and structure.

## 4. Viewing Documentation Locally 💻

View the generated documentation locally by serving it on a local server at port 4000. Use:

```bash
forge doc --serve --port 4002
```

Access the documentation through your web browser by navigating to <http://localhost:4002>.

Explore and understand the project using the provided documentation. If you encounter any issues or need assistance, please reach out for support. We're here to help! 🤝