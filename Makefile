requirements_frozen.txt requirements.nix requirements_override.nix: requirements.txt
	pypi2nix -V 3.6 -r $^

.PHONY: all
all: requirements_frozen.txt requirements.nix requirements_override.nix default.nix
	nix-build -K .

.PHONY: clean
clean:
	rm -rf .cache result requirements_frozen.txt

.PHONY: bump-requirements
bump-requirements: clean requirements_frozen.txt

.PHONY: dockerize
dockerize: dockerize.nix
	docker load --input $$(nix-build dockerize.nix)


.PHONY: dockerhub
docker-push:
	docker login
	docker tag smarketshq/marge-bot:$$(cat version) smarketshq/marge-bot:latest
	docker push smarketshq/marge-bot:$$(cat version)
	docker push smarketshq/marge-bot:latest
