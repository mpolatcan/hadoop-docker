# Written by Mutlu Polatcan
# 27.10.2020
import yaml
import requests
from sys import argv
from bs4 import BeautifulSoup


class HadoopConfigLoaderGenerator:
    KEY_CONFIG_LOADER_SH_TEMPLATE = "config_loader_sh_template"
    HADOOP_DOC_BASE_URL = "https://hadoop.apache.org/docs/r"
    CONFIG_LOADER_STD_STATEMENT_FMT = "load_config \"{property}\" \"${{{env_var_name}:={env_var_value}}}\" \"{config_filename}\""
    CONFIGURATION_TAG_WRITE_FMT = "printf \"<configuration>\\n\" > \"${{HADOOP_CONF_DIR}}/{filename}\""
    CONFIGURATION_TAG_APPEND_FMT = "printf \"</configuration>\" >> \"${{HADOOP_CONF_DIR}}/{filename}\""

    def __init__(self, hadoop_version: str):
        self.__hadoop_version = hadoop_version
        self.__hadop_major_version, self.__hadoop_minor_version, _ = tuple(self.__hadoop_version.split("."))
        self.__config_loader_config = yaml.safe_load(open(f"config.yaml", "r"))

    def __get_configs_and_parse(self):
        core_site_config_raw = requests.get(
            f"{self.HADOOP_DOC_BASE_URL}{self.__hadoop_version}/hadoop-project-dist/hadoop-common/core-default.xml"
        ).content.decode("utf-8")
        yarn_site_config_raw = requests.get(
            f"{self.HADOOP_DOC_BASE_URL}{self.__hadoop_version}/hadoop-yarn/hadoop-yarn-common/yarn-default.xml"
        ).content.decode("utf-8")
        hdfs_site_config_raw = requests.get(
            f"{self.HADOOP_DOC_BASE_URL}{self.__hadoop_version}/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml"
        ).content.decode("utf-8")
        mapred_site_config_raw = requests.get(
            f"{self.HADOOP_DOC_BASE_URL}{self.__hadoop_version}/hadoop-mapreduce-client/hadoop-mapreduce-client-core/mapred-default.xml"
        ).content.decode("utf-8")
        hdfs_rbf_site_config_raw = None

        if int(self.__hadop_major_version) >= 3 and int(self.__hadoop_minor_version) >= 1:
            hdfs_rbf_site_config_raw = requests.get(
                f"{self.HADOOP_DOC_BASE_URL}{self.__hadoop_version}/hadoop-project-dist/hadoop-hdfs-rbf/hdfs-rbf-default.xml"
            ).content.decode("utf-8")

        core_site_soup = BeautifulSoup(core_site_config_raw, "html.parser")
        yarn_site_soup = BeautifulSoup(yarn_site_config_raw, "html.parser")
        hdfs_site_soup = BeautifulSoup(hdfs_site_config_raw, "html.parser")
        mapred_site_soup = BeautifulSoup(mapred_site_config_raw, "html.parser")

        soups = [(core_site_soup, "core-site.xml"),
                 (yarn_site_soup, "yarn-site.xml"),
                 (hdfs_site_soup, "hdfs-site.xml"),
                 (mapred_site_soup, "mapred-site.xml")]

        if int(self.__hadop_major_version) >= 3 and int(self.__hadoop_minor_version) >= 1:
            soups.append((BeautifulSoup(hdfs_rbf_site_config_raw, "html.parser"), "hdfs-site.xml"))

        return soups

    def generate(self):
        load_fn_calls = []

        for soup, config_filename in self.__get_configs_and_parse():
            _load_fn_calls = [
                "# ==================================== {filename} "
                "CONFIGURATIONS ==================================".format(filename=config_filename),
                self.CONFIGURATION_TAG_WRITE_FMT.format(filename=config_filename)
            ]

            for property in soup.find_all("property"):
                name = property.find("name").get_text().strip().replace("\n", "").replace(" ", "")
                raw_value = property.find("value")

                if raw_value:
                    value = raw_value.get_text().strip().replace("\n", "") \
                                                        .replace(" ", "") \
                                                        .replace("\"", "\\\"") \
                                                        .replace("}", "\\}") \
                                                        .replace("$", "\\$")

                    if value == "":
                        value = "NULL"
                else:
                    value = "NULL"

                if "[" not in name:
                    _load_fn_calls.append(
                        self.CONFIG_LOADER_STD_STATEMENT_FMT.format(property=name,
                                                                    env_var_name=name.upper().replace(".","_")
                                                                                             .replace("-", "_"),
                                                                    env_var_value=value,
                                                                    config_filename=config_filename)
                    )

            load_fn_calls.extend(_load_fn_calls)

        open("config_loader.sh", "w").write(
            self.__config_loader_config[self.KEY_CONFIG_LOADER_SH_TEMPLATE].format(
                begin_load_fn_calls="\n\t\t".join(load_fn_calls),
                end_load_fn_calls="\n\t\t".join([
                    self.CONFIGURATION_TAG_APPEND_FMT.format(filename=config_filename)
                    for config_filename in ["core-site.xml", "yarn-site.xml", "hdfs-site.xml", "mapred-site.xml"]
                ])
            )
        )


if __name__ == "__main__":
    HadoopConfigLoaderGenerator(hadoop_version=argv[1]).generate()




