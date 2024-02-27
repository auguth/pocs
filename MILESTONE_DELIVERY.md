# Milestone Delivery :mailbox:

**The delivery is according to the official [milestone delivery guidelines](https://github.com/w3f/Grants-Program/blob/master/docs/Support%20Docs/milestone-deliverables-guidelines.md).**  

> ⚡ Only the GitHub account that submitted the application is allowed to submit milestones. 
> 
> Don't remove any of the mandatory parts presented in bold letters or as headlines! Lines starting with `>`, such as this one, can be removed.

* **Application Document:** [Proof of Contract Stake](https://github.com/w3f/Grants-Program/tree/master/applications/PoCS.md)
* **Milestone Number:** 2

**Context**

> Please provide a short paragraph or two connecting the deliverables in this milestone and describing their purpose.

The goal is to integrate pallet-staking with modified pallet-contracts, ensuring NPoS and PoCS systems work together seamlessly. A working prototype of the PoCS full node is achieved. 

**Deliverables**
> Please provide a list of all deliverables of the milestone extracted from the initial application and a link to the deliverable itself. Ideally all links inside the below table should include a commit hash, which will be used for testing. If you don't provide a commit hash, we will work off the default branch of your repository. Thus, if you plan on continuing work after delivery, we suggest you create a separate branch for either the delivery or your continuing work. 
> 
> If there is anything particular about any of the deliverables we or a future reader should know, use the respective `Notes` column.

|Number|Deliverable|Link|Notes|
|-------------|-------------|------------- |------------- |
|0a.|License| [Apache 2.0](https://github.com/auguth/pocs/blob/master/LICENSE) |-|
|0b.|Documentation| [Pallet Contracts](https://auguth.github.io/pocs/target/doc/pallet_contracts/), [Pallet Staking](https://auguth.github.io/pocs/target/doc/pallet_staking/) | Crate Documentation of modified `pallet_contracts` and `pallet_staking` for PoCS|
|0c.|Testing and Testing Guide| [Testing guide](https://github.com/auguth/pocs/blob/master/TESTING-GUIDE.md) | `nightly-2023-12-21` required and overridden. Guide includes implementation details|
|0d.|Docker | [Dockerfile](https://github.com/auguth/pocs/blob/master/Dockerfile) , [Docker Compose](https://github.com/auguth/pocs/blob/master/docker-compose.yml) , [DockerImage](https://github.com/auguth/pocs/blob/master/README.md#docker-pull)| To Build and Run using Docker `docker compose up --build -d` |
|0e.|Article|[PoCS Implementation Details](https://github.com/auguth/pocs/blob/master/TESTING-GUIDE.md#implementation-details), [PoCS README](https://github.com/auguth/pocs/blob/master/README.md) |In Milestone 3 only the Article will be a blog article, right now we've given the integration details in [Testing Guide](https://github.com/auguth/pocs/blob/master/TESTING-GUIDE.md) itself.|
|1.|Modify pallet staking for PoCS|[PoCS x NPoS #29](https://github.com/auguth/pocs/pull/29)|PoCS Node Repository - includes modified [pallet-contracts](https://github.com/auguth/pocs/tree/master/pallets/contracts) & [pallet-staking](https://github.com/auguth/pocs/tree/master/pallets/staking)|


**Additional Information**
> Any further comments on the milestone that you would like to share with us.

1. [To Build & Run PoCS Node](https://github.com/auguth/pocs/blob/master/README.md#pocs-node-set-up)
2. [List of Testing Commands](https://github.com/auguth/pocs/blob/master/TESTING-GUIDE.md#unit-tests--benchmarking-tests)
3. [To Build & Run using Docker Compose](https://github.com/auguth/pocs/blob/master/README.md#docker-compose)
4. [Nominator Test Using Polkadot JS and Contracts UI](https://github.com/auguth/pocs/blob/master/TESTING-GUIDE.md#test-using-front-end)
5. Upcoming Final **Milestone 3** will include these deliverables,
     1. Multi Node Test
     2. Yellow Paper (Security Report Included)
     3. Sample PoCS ink! Contract (Verifying Contract's Delegate and Stake Score)
     4. PoCS Blog Article
     5. PoCS Tutorial Video