.PHONY: export-env test

export-env:
	@export $$(cat .env | xargs)

test: export-env
	@k6 run load-test.js
