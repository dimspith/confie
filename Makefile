build:
	@nimble build

clean:
	@rm confie

docs: clean-docs
	@nimble doc --project --outdir:docs --index:on src/confie.nim
	@nim buildIndex -o:docs/index.html docs

clean-docs:
	@rm -f docs/*
