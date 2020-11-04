# Written by Mutlu Polatcan
# 27.10.2020
import yaml
import requests
from sys import argv
from bs4 import BeautifulSoup


class TezConfigLoaderGenerator:
    KEY_CONFIG_LOADER_SH_TEMPLATE = "config_loader_sh_template"
    KEY_OVERRIDDEN_CONFIGS = "overridden_configs"
    KEY_DEPRECATED_CONFIGS = "deprecated_configs"
    KEY_ADDITIONAL_CONFIGS = "additional_configs"
    CONFIG_LOADER_STD_STATEMENT_FMT = "load_config \"{property}\" \"${{{env_var_name}:={env_var_value}}}\" \"{config_filename}\""
    CONFIGURATION_TAG_WRITE_FMT = "printf \"<configuration>\\n\" > \"{config_filename}\""
    CONFIGURATION_TAG_APPEND_FMT = "printf \"</configuration>\" >> \"{config_filename}\""

    def __init__(self, tez_version):
        self.__tez_version = tez_version
        self.__config_loader_config = yaml.safe_load(open(f"config.yaml", "r"))

    def __get_configs_and_parse(self):
        tez_site_config_raw = requests.get(
            f"https://tez.apache.org/releases/{self.__tez_version}/tez-api-javadocs/configs/TezConfiguration.html"
        ).content.decode("utf-8")
        tez_site_soup = BeautifulSoup(tez_site_config_raw, "html.parser")

        return (
            [
                tuple(
                    [
                        tag.get_text().strip().replace("\n", "").replace("\"", "\\\"")
                                              .replace("}", "\\}").replace("$", "\\$")
                        if tag.get_text() != "null" else "NULL"
                        for tag in property.find_all("td")[:2]
                    ]
                )
                for property in tez_site_soup.find_all("tr")[1:]
            ],
            "${TEZ_CONF_DIR}",
            "tez-site.xml"
        )

    def __get_formatted_config(self, property, value, config_filename):
        # If value overridden take it from config, else set given value
        _value = self.__config_loader_config.get(self.KEY_OVERRIDDEN_CONFIGS, {}).get(property, value)

        return self.CONFIG_LOADER_STD_STATEMENT_FMT.format(property=property,
                                                           env_var_name=property.upper().replace(".", "_")
                                                                                        .replace("-", "_"),
                                                           env_var_value=_value if _value != "" else "NULL",
                                                           config_filename=config_filename)

    def generate(self):
        configs, config_path, config_filename = self.__get_configs_and_parse()

        load_fn_calls = [
            "# ==================================== {config_filename} "
            "CONFIGURATIONS ==================================".format(config_filename=config_filename),
            self.CONFIGURATION_TAG_WRITE_FMT.format(config_filename=f"{config_path}/{config_filename}")
        ]

        for property, value in configs:
            # If property not deprecated or not include square bracket, add this property
            if "[" not in property and property not in self.__config_loader_config.get(self.KEY_DEPRECATED_CONFIGS, []):
                load_fn_calls.append(self.__get_formatted_config(property, value, f"{config_path}/{config_filename}"))

        # If there any additional properties for that config file, add these properties
        additional_configs = self.__config_loader_config.get(self.KEY_ADDITIONAL_CONFIGS, {}).get(config_filename)

        if additional_configs:
            for property, value in additional_configs.items():
                load_fn_calls.append(self.__get_formatted_config(property, value, f"{config_path}/{config_filename}"))

        open("config_loader.sh", "w").write(
            self.__config_loader_config[self.KEY_CONFIG_LOADER_SH_TEMPLATE].format(
                begin_load_fn_calls="\n\t\t".join(load_fn_calls),
                end_load_fn_calls="\n\t\t".join([
                    self.CONFIGURATION_TAG_APPEND_FMT.format(config_filename=f"${config_path}/{config_filename}")
                ])
            )
        )


if __name__ == "__main__":
    TezConfigLoaderGenerator(tez_version=argv[1]).generate()
