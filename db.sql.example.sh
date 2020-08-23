#!/usr/bin/env bash

set -e

sudo -- mysql <<EOF

CREATE DATABASE IF NOT EXISTS ${DAMP_EXAMPLE_DB_NAME}
    DEFAULT CHARACTER SET utf8
    COLLATE utf8_unicode_ci;
USE ${DAMP_EXAMPLE_DB_NAME};

CREATE TABLE IF NOT EXISTS ${DAMP_EXAMPLE_DB_TABLE}
(
    name        VARCHAR(32) NOT NULL,
    active      TINYINT(1)  NOT NULL DEFAULT '1',
    updated     DATETIME    NOT NULL,
    created     DATETIME    NOT NULL,
    UNIQUE KEY ${DAMP_EXAMPLE_DB_NAME}_${DAMP_EXAMPLE_DB_TABLE}_name_unique (name)
)
    ENGINE = InnoDB;

EOF
