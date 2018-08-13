DUMMY: image

languages: import/index.js
	node ./import/index.js

out/setup.sh: languages/*
	python3 setup.py

image: Dockerfile out/setup.sh
	docker build -t polygott:latest .