require! <[fs jsonfile]>
[type] = process.argv .slice 2
allprot = (fs.read-file-sync \../res/allprot.fa, encoding: \utf-8) / \\n
train = (fs.read-file-sync "../res/#type", encoding: \utf-8) / \\n
train.pop!

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

jsonfile.write-file-sync "../output/#type.json", mapped-train, spaces: 2
