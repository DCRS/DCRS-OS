KEY=default
CHANNEL=stable
ID=account_id
FLAVOR=pc
DATE=$(shell date --rfc-3339=seconds | sed "s/ /T/g")

KERNEL=$(shell cat flavor/$(FLAVOR) | grep "^KERNEL=" | grep "=[a-z0-9-]*" -o | grep "[a-z0-9-]*" -o)
CORE=$(shell cat flavor/$(FLAVOR) | grep "^CORE=" | grep "=[a-z0-9-]*" -o | grep "[a-z0-9-]*" -o)

SNAPDIR=$(wildcard snaps/*-snap)
SRC=$(SNAPDIR) core/dcrs-core-$(CORE)
SNAP=$(SNAPDIR:-snap=.snap) core/dcrs-core-$(CORE).snap

all: dcrs.img

dcrs.img: snap dcrs.model
	sudo ubuntu-image \
	 -c $(CHANNEL) \
	 --image-size 4G \
	 -o dcrs.img \
	 $(foreach snap,$(SNAP),--extra-snaps $(snap)) \
	 dcrs.model

dcrs.model:
	cat dcrs-model.json | sed "s/ID/$(ID)/g" | sed "s/TIMESTAMP/$(DATE)/g" | sed "s/CORE/$(CORE)/g" | sed "s/KERNEL/$(KERNEL)/g" > model.json
	cat model.json | snap sign -k $(KEY) > dcrs.model
	rm model.json

snap: $(SNAP)

core/dcrs-core-%.snap: core/dcrs-core-%
	snapcraft snap $(@:.snap=) -o $@

%.snap: %-snap
	cd $(@:.snap=-snap) && snapcraft && cp *.snap ../../$@

clean:
	rm -f $(SNAP) dcrs.model dcrs.img model.json

full-clean: clean
	$(foreach snapdir,$(SNAPDIR),cd $(snapdir) && snapcraft clean)
