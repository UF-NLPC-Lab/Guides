#!/usr/bin/env python3

import sys
import json
import pdb

from babelnet.resources import BabelSynsetID, WordNetSynsetID
import babelnet as bn

offset = 9046
part_of_speech = 'a'
wn_synset_id = f"wn:{offset:08d}{part_of_speech}"

# Query the server for what the corresponding BabelNet synset for this WD synset is
bn_synset = bn.get_synset(WordNetSynsetID(wn_synset_id))
print(bn_synset)
