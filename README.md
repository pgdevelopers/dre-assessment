## High Level Context:
You've just been hired at a company to do [database reliability engineering](https://towardsdatascience.com/a-beginners-guide-to-data-reliability-engineering-8bfd9b9fcaf6). The company is moving to a new model where instead of a central Database team, the Site Reliability and Database Reliability engineers are assigned to a product team to help them increase observability, pipelines, performance and reliability.

#### Setup for you:
- Your SRE peer setup prometheus, alertmanager, grafana, jupyter, nginx, an open telemetry collector, and jaeger.

#### Pre-requisites:
- You need Docker Desktop installed (or an alternative you prefer)
- You'll need [Atlas](https://atlasgo.io) installed - We recommend Homebrew for MacOS and Linux
- You'll need to be able to run Makefiles (for windows users this will be a bit more challenging)
- Run `make up` to start the developer environment.

#### Helpful Hints
- Some of these tools only work well on MacOS or Linux, if you are on windows consider WSL
- You can access the CockroachDB Portal [here](https://localhost:8080) but SSL is required, to make development easier consider running chrome with localhost SSL verification disabled.Copy chrome://flags/#allow-insecure-localhost and paste it into the address bar. Set the setting to Enabled.
- Grafana can be found [here](http://localhost:3000)
- Prometheus can be found [here](http://localhost:3000)
- Jaeger can be found [here](http://localhost:16686)
- AlertManager can be found [here](http://localhost:9093)
- Some clients will allow you to connect with buzz others will require root and certificates. To generate client certs run `make certs` and use ca.crt, client.root.crt, client.root.key with no passsphrase to connect.
- Peek at the docker logs for jupyter notebooks. It will likely give you a connect token and url that looks like this: http://127.0.0.1:8888/lab?token=1936f6df8de02d0b88e31a9f8c8a0fcd4406fd3b01ddef10, note that our service is exposed on port 10000 so you'll need to replace that link with http://127.0.0.1:10000/lab?token=1936f6df8de02d0b88e31a9f8c8a0fcd4406fd3b01ddef10. (note the token will be different on every run)
- You may want to run the following in Jupyter to get some nice SQL connection packages `pip install sqlalchemy cockroachdb pandas psycopg2-binary matplotlib`

### Scenario: 
Context: The Movr team is looking to move from their traditional open source database in AWS to a NewSQL database in this case CockroachDB. Their previous database was setup by a DBA that has since retired from the company. None of the DDL scripts for setting up the database are available but the team wants wants to migrate to [Atlas](https://atlasgo.io) and manage their schema in HCL. Their previous Open Source Postgres deployment had an SLO of 99.95% and a SLA of 99.9% after the DBA retired they have struggled to hit either and they attribute it to the lack of monitoring and alerting.

#### Task 1:
- Perform load testing on the database by running the script created by the development team by running `make load`

#### Task 2:
- Create a dashboard with valuable metrics for monitoring the performance of the database. You can use any tool you prefer but we recommend grafana. (You'll likely need 2 or 3 data sources to accomplish this)

#### Task 3:
- Create a seperate business facing dashboard with the BI queries from the sql directory.

#### Task 4:
- Optimize these queries and be prepared to help the team learn why your improvements make the queries better. (schema changes permitted!)

#### Task 5:
- Export the running movr schema into HCL by running the atlas schema inspect command
`atlas schema inspect -u "postgres://buzz:admin@localhost:26257/movr" > schema.hcl`

#### Task 6:
- Help the team with an HA/DR test by deploying that schema to the running basic postgres server.
`atlas schema apply -u "postgres://postgres:postgres@localhost:5432/test" -f schema.hcl`

#### Task 7:
- Help the data science team optimize the jupyter notebook located at jupyter/simple.ipynb. See the helpful hints for ways to do this.