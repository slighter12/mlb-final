require! <[fs jsonfile]>
allprot = (fs.read-file-sync \./res/allprot.fa, encoding: \utf-8) / \\n
train = (fs.read-file-sync \./res/train, encoding: \utf-8) / \\n

# resolve fasta
prot = {}; seq = ''; id = ''
for line in allprot
  if line is /^>.*?\|(.*)?\|.*/
    if seq => prot[id] = seq; seq := ''
    id := that.1
  else if seq => seq := seq + line
  else => seq := line
if seq => prot[id] = seq

# map to train data
mapped-train = {}
for line in train
  [label, id, pair] = line / \\t
  if prot[id] => mapped-train[id] = label: label, seq: prot[id]
  else console.log "Miss #{id}"

jsonfile.write-file-sync \./output/train.json, mapped-train, spaces: 2
