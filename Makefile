TARGET = airpi
PREFIX = $(DESTDIR)/usr/local
LIBDIR = $(PREFIX)/lib/$(TARGET)
WWW_ROOT = /var/www/html
WWW_CONFIG = $(WWW_ROOT)/config.php

DIRECTORIES = /etc/airpi /etc/host-config /var/lib/airpi /var/www/html

AIRPI_CFG = /etc/airpi/airpi.cfg
CRON_AIRPI = /etc/cron.d/airpi
CRON_PMS5003 = /etc/cron.d/pms5003
SUDOERS = /etc/sudoers.d/airpi
BME280_STATUS = /var/run/bme280.status


CFG_WEBCFG = /etc/host-config/webconfig.cfg
CFG_OPTIONS = /etc/host-config/options
CFG_PENDING = /etc/host-config/options-pending
CFG_REGEXP = /etc/host-config/options-regexp

LIB_FILES := $(shell cd lib; echo airpi-* bme280* pms5003* rrd-graph-*)
LIB_PYLIB := $(shell cd lib; echo Adafruit_BME280*)

.PHONY: all
all: ;

.PHONY: install
install: install-lib

.PHONY: install-lib
install-lib:
	install -m 755 -o root -g root -D -t $(LIBDIR) $(addprefix lib/, $(LIB_FILES))
	install -m 644 -o root -g root -D -t $(LIBDIR) $(addprefix lib/, $(LIB_PYLIB))
	python -m compileall $(LIBDIR)

.PHONY: install-directories
install-directories:
	install -m 0755 -o root -g root -d $(DIRECTORIES)

.PHONY: install-config
install-config: install-directories
	test -e $(AIRPI_CFG)     || install -m 0640 -o root -g root examples/airpi.cfg $(AIRPI_CFG)
	test -e $(CRON_AIRPI)    || install -m 0644 -o root -g root examples/cron.airpi $(CRON_AIRPI)
	test -e $(CRON_PMS5003)  || install -m 0644 -o root -g root examples/cron.pms5003 $(CRON_PMS5003)
	test -e $(SUDOERS)       || install -m 0644 -o root -g root examples/sudoers.airpi $(SUDOERS)
	test -e $(BME280_STATUS) || install -m 0664 -o root -g snmp /dev/null $(BME280_STATUS)

.PHONY: install-webconfig
install-webconfig:
	test -e $(CFG_WEBCFG)    || install -m 0640 -o www-data -g root /dev/null $(CFG_WEBCFG)
	test -e $(CFG_PENDING)   || install -m 0640 -o www-data -g root /dev/null $(CFG_PENDING)
	test -e $(CFG_OPTIONS)   || install -m 0640 -o www-data -g root examples/webconfig.options $(CFG_OPTIONS)
	install -m 0640 -o root -g root examples/webconfig.options-regexp $(CFG_REGEXP)

.PHONY: install-html
install-html: install-directories
	cp -pr html/* $(WWW_ROOT)
	chown -R root:root $(WWW_ROOT)
	test -e $(WWW_CONFIG) || install -m 0644 -o root -g root html/config-sample.php $(WWW_CONFIG)

.PHONY: uninstall
uninstall:
	-rm -f $(addprefix $(LIBDIR)/, $(LIB_FILES))
	-rm -f $(addprefix $(LIBDIR)/, $(LIB_PYLIB))
	-rm -f $(LIBDIR)/*.pyc
