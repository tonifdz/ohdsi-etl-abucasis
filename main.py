#!/usr/bin/env python3

import click
import logging
from pathlib import Path
import sys

from delphyne.config.models import MainConfig
from delphyne.log.setup_logging import setup_logging
from delphyne.util.io import read_yaml_file

from src.main.python.wrapper import Wrapper

__version__ = '5.0.2-SNAPSHOT'

logger = logging.getLogger(__name__)


@click.command()
@click.option('--config', '-c', required=True, metavar='<config_file_path>',
              help='Path to the yaml configuration file.',
              type=click.Path(file_okay=True, exists=True, readable=True))
def main(config):

    setup_logging()
    logger.info('ETL version {}'.format(__version__))

    config = MainConfig(**read_yaml_file(Path(config)))

    # Initialize ETL with configuration parameters
    etl = Wrapper(config)

    etl.run()


if __name__ == "__main__":
    sys.exit(main())
