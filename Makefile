current_branch := 2.3.3-mysql-metastore
build:
	docker build -t registry.advanpro.cn/hive:$(current_branch) ./
