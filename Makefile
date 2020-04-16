build:
	./scripts/build.sh

clean:
	@echo 'Remove .build directory.'
	@rm -rf .build

format:
	@./scripts/format-code.sh
