.PHONY: publish-hadoop
publish-hadoop:
	$(MAKE) publish-hadoop-helper dist=ubuntu hadoop_version=3.1.1
	$(MAKE) publish-hadoop-helper dist=alpine hadoop_version=3.1.1
	$(MAKE) publish-hadoop-helper dist=ubuntu hadoop_version=3.0.3
	$(MAKE) publish-hadoop-helper dist=alpine hadoop_version=3.0.3
	$(MAKE) publish-hadoop-helper dist=ubuntu hadoop_version=3.0.2
	$(MAKE) publish-hadoop-helper dist=alpine hadoop_version=3.0.2
	$(MAKE) publish-hadoop-helper dist=ubuntu hadoop_version=2.9.1
	$(MAKE) publish-hadoop-helper dist=alpine hadoop_version=2.9.1
	$(MAKE) publish-hadoop-helper dist=ubuntu hadoop_version=2.9.0
	$(MAKE) publish-hadoop-helper dist=alpine hadoop_version=2.9.0
	$(MAKE) publish-hadoop-helper dist=ubuntu hadoop_version=2.8.4
	$(MAKE) publish-hadoop-helper dist=alpine hadoop_version=2.8.4
	$(MAKE) publish-hadoop-helper dist=ubuntu hadoop_version=2.7.6
	$(MAKE) publish-hadoop-helper dist=alpine hadoop_version=2.7.6
	$(MAKE) publish-hadoop-helper dist=ubuntu hadoop_version=2.6.5
	$(MAKE) publish-hadoop-helper dist=alpine hadoop_version=2.6.5

.PHONY: publish-hadoop-helper
publish-hadoop-helper:
	sudo docker build -q -t mpolatcan/hadoop:$(dist)-$(hadoop_version) --build-arg HADOOP_VERSION=$(hadoop_version) ./$(dist)/
	sudo docker push mpolatcan/hadoop:$(dist)-$(hadoop_version)
	sudo docker rmi $$(sudo docker images -q)