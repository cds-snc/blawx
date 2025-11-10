# Blawx performance tests

Performance testing suite for the Blawx application using Grafana k6.

## Prerequisites

- [k6 installed](https://grafana.com/docs/k6/latest/set-up/install-k6/) on your system
- Test user created in Blawx
- `.env` file created and populated with values:

```sh
cp .env.example .env
```

## Running tests

```sh
export $(cat .env | xargs -0)
k6 run load-test.js
```