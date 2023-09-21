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

### 2.2 Deploy contracts on testnet 🌐

- Deploy the Lilium contract using the command below, ensuring you replace the placeholders with the appropriate values:

    ```bash
    $ make lilium CONFIG="--network sepolia"
    ```

- Deploy the certifier contract with the following command:

    ```bash
    $ make certifier lilium="<LILIUM_CONTRACT_ADDRESS>" cid="QmRSAi9LVTuzN3zLu3kKeiESDug27gE3F6CFYvuMLFrt2C" name="Verra" token_name="VERRA" token_symbol="VRR" token_decimals="18" CONFIG="--network sepolia"
    ```

- Deploy the company contract:

    ```bash
    $ make company certifier="CERTIFIER_CONTRACT_ADDRESS" cid="QmQp9iagQS9uEQPV7hg5YGwWmCXxAs2ApyBCkpcu9ZAK6k" name="Gerdau" country="Brazil" industry="Steelworks" allowance="100000000" compensation_per_hour="10000" CONFIG="--network sepolia"
    ```

- Set the device contract:

    ```bash
    $ make device company="COMPANY_CONTRACT_ADDRESS" CONFIG="--network sepolia"
    ```

- Set the auxiliary contract:

    ```bash
    $ make auxiliary company="COMPANY_CONTRACT_ADDRESS" verifier="VERIFIER_CONTRACT_ADDRESS" auction="AUCTION_CONTRACT_ADDRESS" CONFIG="--network sepolia"
    ```

- Verify the real world state:

    ```bash
    $ make verify company="COMPANY_CONTRACT_ADDRESS" CONFIG="--network sepolia"
    ```

## 3. Generating Documentation 📖

Generate project documentation using:

```bash
forge doc
```

This command generates documentation based on the project's code and structure.

## 4. Viewing Documentation Locally 💻

View the generated documentation locally by serving it on a local server at port 4000. Use:

```bash
forge doc --serve --port 4001
```

Access the documentation through your web browser by navigating to <http://localhost:4001>.

Explore and understand the project using the provided documentation. If you encounter any issues or need assistance, please reach out for support. We're here to help! 🤝