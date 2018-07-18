.PHONY: publish-hadoop
publish-hadoop:
	sudo docker build -q -t mpolatcan/hadoop:ubuntu-3.1.0 --build-arg HADOOP_VERSION="3.1.0" ./ubuntu/
	sudo docker build -q -t mpolatcan/hadoop:alpine-3.1.0 --build-arg HADOOP_VERSION="3.1.0" ./alpine/
	sudo docker build -q -t mpolatcan/hadoop:ubuntu-3.0.3 --build-arg HADOOP_VERSION="3.0.3" ./ubuntu/
	sudo docker build -q -t mpolatcan/hadoop:alpine-3.0.3 --build-arg HADOOP_VERSION="3.0.3" ./alpine/
	sudo docker build -q -t mpolatcan/hadoop:ubuntu-3.0.2 --build-arg HADOOP_VERSION="3.0.2" ./ubuntu/
	sudo docker build -q -t mpolatcan/hadoop:alpine-3.0.2 --build-arg HADOOP_VERSION="3.0.2" ./alpine/
	sudo docker build -q -t mpolatcan/hadoop:ubuntu-2.9.1 --build-arg HADOOP_VERSION="2.9.1" ./ubuntu/
	sudo docker build -q -t mpolatcan/hadoop:alpine-2.9.1 --build-arg HADOOP_VERSION="2.9.1" ./alpine/
	sudo docker build -q -t mpolatcan/hadoop:ubuntu-2.9.0 --build-arg HADOOP_VERSION="2.9.0" ./ubuntu/
	sudo docker build -q -t mpolatcan/hadoop:alpine-2.9.0 --build-arg HADOOP_VERSION="2.9.0" ./alpine/
	sudo docker build -q -t mpolatcan/hadoop:ubuntu-2.8.4 --build-arg HADOOP_VERSION="2.8.4" ./ubuntu/
	sudo docker build -q -t mpolatcan/hadoop:alpine-2.8.4 --build-arg HADOOP_VERSION="2.8.4" ./alpine/
	sudo docker build -q -t mpolatcan/hadoop:ubuntu-2.7.6 --build-arg HADOOP_VERSION="2.7.6" ./ubuntu/
	sudo docker build -q -t mpolatcan/hadoop:alpine-2.7.6 --build-arg HADOOP_VERSION="2.7.6" ./alpine/
	sudo docker build -q -t mpolatcan/hadoop:ubuntu-2.6.5 --build-arg HADOOP_VERSION="2.6.5" ./ubuntu/
	sudo docker build -q -t mpolatcan/hadoop:alpine-2.6.5 --build-arg HADOOP_VERSION="2.6.5" ./alpine/