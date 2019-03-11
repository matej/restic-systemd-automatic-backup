# Not file targets.
.PHONY: help install install-scripts install-conf install-systemd

### Macros ###
SRCS_SCRIPTS	= $(filter-out %cron_mail, $(wildcard home/restic/bin*))
SRCS_CONF	= $(wildcard home/restic/.config*)
SRCS_SYSTEMD	= $(wildcard etc/systemd/system/*)

# Just set PREFIX in envionment, like
# $ PREFIX=/tmp/test make
DEST_SCRIPTS	= $(PREFIX)/home/restic/bin
DEST_CONF	= $(PREFIX)/home/restic/.config
DEST_SYSTEMD	= $(PREFIX)/etc/systemd/system


### Targets ###
# target: all - Default target.
all: install

# target: help - Display all targets.
help:
	@egrep "#\starget:" [Mm]akefile  | sed 's/\s-\s/\t\t\t/' | cut -d " " -f3- | sort -d

# target: install - Install all files
install: install-scripts install-conf install-systemd


# target: install-scripts - Install executables.
install-scripts:
	install -d $(DEST_SCRIPTS)
	install -m 744 -o restic -g restic $(SRCS_SCRIPTS) $(DEST_SCRIPTS)

# target: install-conf - Install restic configuration files.
install-conf:
	install -d $(DEST_CONF) -m 700  -o restic -g restic
	install $(SRCS_CONF) $(DEST_CONF)

# target: install-systemd - Install systemd timer and service files
install-systemd:
	install -d $(DEST_SYSTEMD)
	install -m 0644  -o restic -g restic $(SRCS_SYSTEMD) $(DEST_SYSTEMD)
