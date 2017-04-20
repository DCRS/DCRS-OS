SRC=$(wildcard *-snap) dcrs-snap dcrs-core-metasnap
SNAP=$(SRC:-snap=.snap) #dcrs-gadget.snap

KEY=default
CHANNEL=stable
ID=account_id
DATE=$(shell date --rfc-3339=seconds | sed "s/ /T/g")

all: dcrs.img

dcrs.img: snap dcrs.model
	sudo ubuntu-image \
	 -c $(CHANNEL) \
	 --image-size 4G \
	 -o dcrs.img \
	 $(foreach snap,$(SNAP),--extra-snaps $(snap)) \
	 dcrs.model

dcrs.model:
	cat dcrs-model.json | sed "s/ID/$(ID)/g" | sed "s/TIMESTAMP/$(DATE)/g" > model.json
	cat model.json | snap sign -k $(KEY) > dcrs.model

snap: $(SNAP)

dcrs.snap: dcrs-snap
	snapcraft
	mv *.snap dcrs.snap

%.snap: %-metasnap
	snapcraft snap $(@:.snap=-metasnap) -o $@

%.snap: %-snap
	cd $(@:.snap=-snap) && snapcraft && mv *.snap ../$@ #-o $@

clean:
	rm -f $(SNAP) dcrs.model dcrs.img
