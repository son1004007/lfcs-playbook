.PHONY: test lint md

test: lint

lint:
	find scripts -type f -name "*.sh" -print0 | xargs -0 -I{} shellcheck {}

md:
	npx markdownlint-cli2 "**/*.md"
