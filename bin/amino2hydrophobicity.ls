require! <[fs]>
root =
  protein: \../output/train.json
  hydro: \../output/protein2predata.json

allprotein = JSON.parse fs.read-file-sync root.protein
for key, protein of allprotein
  allprotein[key] <<< hydro: class-amino protein
  # class-amino protein
  # break
# console.log JSON.stringify allprotein, null, 2
fs.write-file-sync root.hydro, JSON.stringify allprotein, null, 2

function class-amino protein
  polar = <[R K E D Q N]>; netral = <[G A S T P H Y]>; hydrophobic = <[C V L I M F W]>
  hydrophobicityseq = ''
  for eachamino in protein.seq
    # console.log eachamino
    hydrophobicityseq += switch true | (in polar) eachamino => \P | (in netral) eachamino => \N | (in hydrophobic) eachamino => \H
  return hydrophobicityseq

# vi:et:sw=2:ts=2
