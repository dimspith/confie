build:
	nimble build

clean:
	rm confie

docs: clean-docs
	@cd docs
	@nim doc --project --outdir:docs --index:on src/confie.nim
	@nim buildIndex -o:docs/theindex.html docs

clean-docs:
	@rm -f docs/{*.html,*.idx,*.css}
